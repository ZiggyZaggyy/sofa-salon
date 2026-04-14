/** API + admin UI: response body when English fields cannot be stored until migration 24 (or 23) is applied. */
export const ALT_LOCALE_MIGRATION_ERROR_KEY = 'altLocaleMigrationRequired' as const;

/**
 * Detects PostgREST errors when `screening_alt_locale` is missing
 * (migration `24-screening-alt-locale-table.sql` not applied).
 */
export function isScreeningAltLocaleTableMissingError(message: string): boolean {
  const l = message.toLowerCase();
  if (!l.includes('screening_alt_locale')) return false;
  return (
    l.includes('does not exist') ||
    l.includes('schema cache') ||
    l.includes('could not find')
  );
}

/**
 * Detects PostgREST errors when `title_en` / `director_en` are not on `screenings` yet
 * (migration `23-screenings-title-en-director-en.sql` not applied).
 */
export function isMissingAltLocaleScreeningColumnsError(message: string): boolean {
  const l = message.toLowerCase();
  if (!l.includes('title_en') && !l.includes('director_en')) return false;
  return (
    l.includes('schema cache') ||
    l.includes('could not find') ||
    l.includes('does not exist') ||
    l.includes('unknown column')
  );
}

/** True when the admin asked to persist non-empty English title or director fields. */
export function hasNonEmptyAltLocaleScreeningFields(title_en: unknown, director_en: unknown): boolean {
  return String(title_en ?? '').trim() !== '' || String(director_en ?? '').trim() !== '';
}
