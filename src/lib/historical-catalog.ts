import type { SupabaseClient } from '@supabase/supabase-js';

export const RETROACTIVE_SEAT_PREFIX = 'catalog';

/** Max screenings per POST /api/historical-attendance/claim (UI chunks above this). */
export const MAX_CLAIM_SCREENINGS_PER_REQUEST = 100;

/** Unique seat_key per user for retroactive past screening claims (no physical seat). */
export function catalogSeatKeyForUser(userId: string): string {
  return `${RETROACTIVE_SEAT_PREFIX}-${userId.replace(/-/g, '').slice(0, 12)}`;
}

export function escapeIlikePrefix(query: string): string {
  return query.trim().replace(/\\/g, '\\\\').replace(/%/g, '\\%').replace(/_/g, '\\_');
}

/** PostgREST `in` / `not.in` list for UUID columns — unquoted, comma-separated in parentheses. */
export function postgrestUuidInList(ids: string[]): string {
  return `(${ids.join(',')})`;
}

export type CatalogScreeningItem = {
  id: string;
  title: string;
  titleEn: string;
  director: string;
  screeningAt: string;
  year: number | null;
  alreadyRegistered: boolean;
};

async function fetchUserRegisteredScreeningIds(
  client: SupabaseClient,
  userId: string,
  screeningIds: string[]
): Promise<Set<string>> {
  if (screeningIds.length === 0) return new Set();

  const { data: reservations, error } = await client
    .from('reservations')
    .select('screening_id')
    .eq('user_id', userId)
    .in('screening_id', screeningIds)
    .or('is_ghost.eq.false,is_ghost.is.null');

  if (error) {
    console.error('[historical-catalog] user reservations:', error.message);
    return new Set();
  }

  return new Set((reservations ?? []).map((r) => r.screening_id as string));
}

/** All past screening ids this user already has a (non-ghost) reservation for. */
export async function fetchUserPastRegisteredScreeningIds(
  client: SupabaseClient,
  userId: string
): Promise<Set<string>> {
  const now = new Date().toISOString();

  const { data: reservations, error: resErr } = await client
    .from('reservations')
    .select('screening_id')
    .eq('user_id', userId)
    .or('is_ghost.eq.false,is_ghost.is.null');

  if (resErr) {
    console.error('[historical-catalog] registered ids:', resErr.message);
    return new Set();
  }

  const candidateIds = (reservations ?? []).map((r) => r.screening_id as string);
  if (candidateIds.length === 0) return new Set();

  const { data: past, error: pastErr } = await client
    .from('screenings')
    .select('id')
    .in('id', candidateIds)
    .lt('screening_at', now);

  if (pastErr) {
    console.error('[historical-catalog] past registered:', pastErr.message);
    return new Set();
  }

  return new Set((past ?? []).map((r) => r.id as string));
}

function applyCatalogSearch<T extends { or: (filters: string) => T }>(
  query: T,
  q: string | undefined
): T {
  const term = q?.trim();
  if (!term) return query;
  const prefix = `${escapeIlikePrefix(term)}%`;
  return query.or(
    `title.ilike.${prefix},title_en.ilike.${prefix},director.ilike.${prefix},director_en.ilike.${prefix}`
  );
}

function mapScreeningRows(
  rows: Array<Record<string, unknown>>,
  registered: Set<string>
): CatalogScreeningItem[] {
  return rows.map((row) => ({
    id: row.id as string,
    title: (row.title as string) ?? '',
    titleEn: (row.title_en as string) ?? '',
    director: (row.director as string) ?? '',
    screeningAt: row.screening_at as string,
    year: row.year != null ? Number(row.year) : null,
    alreadyRegistered: registered.has(row.id as string),
  }));
}

/** Past screenings the user has already registered (for compact top section). */
export async function listRegisteredPastScreenings(
  client: SupabaseClient,
  options: { userId: string; q?: string; limit?: number }
): Promise<{ items: CatalogScreeningItem[]; total: number }> {
  const limit = Math.min(100, Math.max(1, options.limit ?? 50));
  const registeredIds = await fetchUserPastRegisteredScreeningIds(client, options.userId);
  if (registeredIds.size === 0) return { items: [], total: 0 };

  let query = client
    .from('screenings')
    .select('id, title, title_en, director, screening_at, year', { count: 'exact' })
    .in('id', Array.from(registeredIds))
    .order('screening_at', { ascending: false });

  query = applyCatalogSearch(query, options.q);

  const { data, error, count } = await query.range(0, limit - 1);

  if (error) {
    console.error('[historical-catalog] registered list:', error.message);
    return { items: [], total: 0 };
  }

  const items = mapScreeningRows(data ?? [], registeredIds).map((item) => ({
    ...item,
    alreadyRegistered: true,
  }));

  return { items, total: count ?? items.length };
}

/** Past screenings not yet registered — paginate this list for “load more”. */
export async function searchUnclaimedPastScreenings(
  client: SupabaseClient,
  options: {
    userId: string;
    q?: string;
    limit?: number;
    offset?: number;
  }
): Promise<{ items: CatalogScreeningItem[]; total: number }> {
  const limit = Math.min(50, Math.max(1, options.limit ?? 30));
  const offset = Math.max(0, options.offset ?? 0);
  const now = new Date().toISOString();
  const registeredIds = await fetchUserPastRegisteredScreeningIds(client, options.userId);

  let query = client
    .from('screenings')
    .select('id, title, title_en, director, screening_at, year', { count: 'exact' })
    .lt('screening_at', now)
    .order('screening_at', { ascending: false });

  if (registeredIds.size > 0) {
    query = query.filter('id', 'not.in', postgrestUuidInList(Array.from(registeredIds)));
  }

  query = applyCatalogSearch(query, options.q);

  const { data, error, count } = await query.range(offset, offset + limit - 1);

  if (error) {
    console.error('[historical-catalog] unclaimed search:', error.message);
    return { items: [], total: 0 };
  }

  const items = mapScreeningRows(data ?? [], registeredIds).map((item) => ({
    ...item,
    alreadyRegistered: false,
  }));

  return { items, total: count ?? items.length };
}

export type ClaimResult = {
  screeningId: string;
  ok: boolean;
  error?: string;
};

/** Create reservations (attended null = present) for past screenings the user attended. */
export async function claimCatalogScreenings(
  client: SupabaseClient,
  userId: string,
  screeningIds: string[]
): Promise<ClaimResult[]> {
  const unique = Array.from(new Set(screeningIds.filter(Boolean)));
  if (unique.length === 0) return [];

  const now = new Date().toISOString();
  const seatKey = catalogSeatKeyForUser(userId);

  const { data: screenings, error: screenErr } = await client
    .from('screenings')
    .select('id, screening_at')
    .in('id', unique);

  if (screenErr) {
    return unique.map((id) => ({ screeningId: id, ok: false, error: screenErr.message }));
  }

  const screeningById = new Map((screenings ?? []).map((s) => [s.id as string, s]));

  const { data: existing } = await client
    .from('reservations')
    .select('screening_id')
    .eq('user_id', userId)
    .in('screening_id', unique)
    .or('is_ghost.eq.false,is_ghost.is.null');

  const already = new Set((existing ?? []).map((r) => r.screening_id as string));

  const results: ClaimResult[] = [];

  for (const screeningId of unique) {
    const s = screeningById.get(screeningId);
    if (!s) {
      results.push({ screeningId, ok: false, error: 'not_found' });
      continue;
    }
    if (typeof s.screening_at === 'string' && s.screening_at >= now) {
      results.push({ screeningId, ok: false, error: 'not_past' });
      continue;
    }
    if (already.has(screeningId)) {
      results.push({ screeningId, ok: true });
      continue;
    }

    const { error: insertErr } = await client.from('reservations').insert({
      screening_id: screeningId,
      user_id: userId,
      seat_key: seatKey,
      is_squeezed: false,
      is_ghost: false,
      attended: null,
    });

    if (insertErr) {
      results.push({ screeningId, ok: false, error: insertErr.message });
    } else {
      already.add(screeningId);
      results.push({ screeningId, ok: true });
    }
  }

  return results;
}
