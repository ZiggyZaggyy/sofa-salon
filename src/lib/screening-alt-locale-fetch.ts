import type { SupabaseClient } from '@supabase/supabase-js';

/**
 * Merges English title/director from legacy `screenings` columns (migration 23) and
 * `screening_alt_locale` (migration 24). Side table wins when a row exists.
 */
export async function fetchScreeningAltLocaleByIds(
  client: SupabaseClient,
  ids: string[]
): Promise<Record<string, { title_en: string | null; director_en: string | null }>> {
  const unique = Array.from(new Set(ids.filter(Boolean)));
  if (unique.length === 0) return {};

  const [legacyRes, sideRes] = await Promise.all([
    client.from('screenings').select('id, title_en, director_en').in('id', unique),
    client.from('screening_alt_locale').select('screening_id, title_en, director_en').in('screening_id', unique),
  ]);

  const map: Record<string, { title_en: string | null; director_en: string | null }> = {};

  if (!legacyRes.error && legacyRes.data) {
    for (const row of legacyRes.data) {
      const r = row as { id: string; title_en?: string | null; director_en?: string | null };
      map[r.id] = { title_en: r.title_en ?? null, director_en: r.director_en ?? null };
    }
  }

  if (!sideRes.error && sideRes.data) {
    for (const row of sideRes.data) {
      const r = row as {
        screening_id: string;
        title_en?: string | null;
        director_en?: string | null;
      };
      map[r.screening_id] = { title_en: r.title_en ?? null, director_en: r.director_en ?? null };
    }
  }

  return map;
}
