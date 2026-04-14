import type { SupabaseClient } from '@supabase/supabase-js';

import {
  ALT_LOCALE_MIGRATION_ERROR_KEY,
  isMissingAltLocaleScreeningColumnsError,
  isScreeningAltLocaleTableMissingError,
} from '@/lib/screening-alt-locale-schema';

const MIGRATION_HINT =
  'Database migration required: run supabase-sql/24-screening-alt-locale-table.sql (or supabase-sql/23-screenings-title-en-director-en.sql) in Supabase SQL Editor.';

export type PersistAltLocaleResult =
  | { ok: true }
  | { ok: false; error: string; errorKey?: typeof ALT_LOCALE_MIGRATION_ERROR_KEY };

/**
 * Persists English title/director to `screening_alt_locale` when available, with
 * fallback to legacy `screenings.title_en` / `director_en` (migration 23). Clears
 * both when values are empty.
 */
export async function persistScreeningAltLocale(
  supabase: SupabaseClient,
  screeningId: string,
  title_en: unknown,
  director_en: unknown
): Promise<PersistAltLocaleResult> {
  const tEn = String(title_en ?? '').trim();
  const dEn = String(director_en ?? '').trim();

  const legacyUpdate = async () => {
    const { error } = await supabase
      .from('screenings')
      .update({ title_en: tEn, director_en: dEn })
      .eq('id', screeningId);
    return error;
  };

  if (!tEn && !dEn) {
    const { error: delErr } = await supabase
      .from('screening_alt_locale')
      .delete()
      .eq('screening_id', screeningId);
    if (delErr && !isScreeningAltLocaleTableMissingError(delErr.message)) {
      return { ok: false, error: delErr.message };
    }
    const legErr = await legacyUpdate();
    if (legErr && !isMissingAltLocaleScreeningColumnsError(legErr.message)) {
      return { ok: false, error: legErr.message };
    }
    return { ok: true };
  }

  const { error: sideErr } = await supabase.from('screening_alt_locale').upsert(
    { screening_id: screeningId, title_en: tEn, director_en: dEn },
    { onConflict: 'screening_id' }
  );

  if (!sideErr) {
    const legErr = await legacyUpdate();
    if (legErr && !isMissingAltLocaleScreeningColumnsError(legErr.message)) {
      return { ok: false, error: legErr.message };
    }
    return { ok: true };
  }

  if (isScreeningAltLocaleTableMissingError(sideErr.message)) {
    const legErr = await legacyUpdate();
    if (!legErr) return { ok: true };
    if (isMissingAltLocaleScreeningColumnsError(legErr.message)) {
      return { ok: false, error: MIGRATION_HINT, errorKey: ALT_LOCALE_MIGRATION_ERROR_KEY };
    }
    return { ok: false, error: legErr.message };
  }

  return { ok: false, error: sideErr.message };
}
