import type { SupabaseClient } from '@supabase/supabase-js';

import { persistScreeningAltLocale } from '@/lib/persist-screening-alt-locale';
import { ALT_LOCALE_MIGRATION_ERROR_KEY } from '@/lib/screening-alt-locale-schema';

type DeleteEqResult = Promise<{ error: { message: string } | null }>;
type UpdateEqResult = Promise<{ error: { message: string } | null }>;

function createMockSupabase(opts: {
  deleteResult?: DeleteEqResult;
  upsertResult?: Promise<{ error: { message: string } | null }>;
  updateResult?: UpdateEqResult;
}): SupabaseClient {
  const deleteResult = opts.deleteResult ?? Promise.resolve({ error: null });
  const upsertResult = opts.upsertResult ?? Promise.resolve({ error: null });
  const updateResult = opts.updateResult ?? Promise.resolve({ error: null });
  return {
    from(table: string) {
      if (table === 'screening_alt_locale') {
        return {
          delete: () => ({
            eq: () => deleteResult,
          }),
          upsert: () => upsertResult,
        };
      }
      if (table === 'screenings') {
        return {
          update: () => ({
            eq: () => updateResult,
          }),
        };
      }
      throw new Error(`unexpected table ${table}`);
    },
  } as unknown as SupabaseClient;
}

describe('persistScreeningAltLocale', () => {
  it('returns migration error when neither side table nor legacy columns exist', async () => {
    const supabase = createMockSupabase({
      upsertResult: Promise.resolve({
        error: { message: 'relation "public.screening_alt_locale" does not exist' },
      }),
      updateResult: Promise.resolve({
        error: { message: 'column screenings.title_en does not exist' },
      }),
    });
    const r = await persistScreeningAltLocale(supabase, 'id-1', 'English', '');
    expect(r.ok).toBe(false);
    if (!r.ok) {
      expect(r.errorKey).toBe(ALT_LOCALE_MIGRATION_ERROR_KEY);
      expect(r.error).toContain('24-screening-alt-locale-table');
    }
  });

  it('succeeds when side table is missing but legacy columns accept the update', async () => {
    const supabase = createMockSupabase({
      upsertResult: Promise.resolve({
        error: { message: 'relation "public.screening_alt_locale" does not exist' },
      }),
      updateResult: Promise.resolve({ error: null }),
    });
    const r = await persistScreeningAltLocale(supabase, 'id-1', 'English', '');
    expect(r).toEqual({ ok: true });
  });

  it('clears via delete and legacy update when both fields empty', async () => {
    let deleteCalled = false;
    const supabase = createMockSupabase({
      deleteResult: Promise.resolve().then(() => {
        deleteCalled = true;
        return { error: null };
      }),
      updateResult: Promise.resolve({ error: null }),
    });
    const r = await persistScreeningAltLocale(supabase, 'id-1', '', '  ');
    expect(r).toEqual({ ok: true });
    expect(deleteCalled).toBe(true);
  });
});
