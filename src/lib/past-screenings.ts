export const PAST_SCREENINGS_PAGE_SIZE = 24;

/** Keep PostgREST `.or(...)` search input free of filter grammar punctuation. */
export function normalizePastScreeningsSearch(value: string | undefined): string {
  return (value ?? '')
    .normalize('NFKC')
    .replace(/[,().%\\:;"'=\[\]{}_*]/g, ' ')
    .replace(/\s+/g, ' ')
    .trim()
    .slice(0, 100);
}

export function pastScreeningsPageHref(page: number, query: string): string {
  const params = new URLSearchParams();
  if (query) params.set('q', query);
  if (page > 1) params.set('page', String(page));
  const suffix = params.toString();
  return suffix ? `/past-screenings?${suffix}` : '/past-screenings';
}
