import type { Locale } from '@/lib/i18n';

function pickForEnglishLocale(primary: string, englishAlt: string | null | undefined): string {
  const alt = (englishAlt ?? '').trim();
  if (alt.length > 0) return alt;
  return primary;
}

/** Main `title` / `director` are the default (Chinese site); `title_en` / `director_en` when locale is English. */
export function screeningDisplayTitle(
  locale: Locale,
  title: string,
  titleEn?: string | null
): string {
  if (locale === 'en') return pickForEnglishLocale(title, titleEn);
  return title;
}

export function screeningDisplayDirector(
  locale: Locale,
  director: string | null | undefined,
  directorEn?: string | null
): string {
  const primary = director ?? '';
  if (locale === 'en') return pickForEnglishLocale(primary, directorEn);
  return primary;
}
