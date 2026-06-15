import {
  normalizePastScreeningsSearch,
  pastScreeningsPageHref,
} from '../past-screenings';

describe('past screenings helpers', () => {
  it('normalizes archive search without PostgREST filter punctuation', () => {
    expect(normalizePastScreeningsSearch('  冰冷, tropical (fish)%  ')).toBe(
      '冰冷 tropical fish'
    );
  });

  it('builds stable pagination links while retaining search', () => {
    expect(pastScreeningsPageHref(1, '')).toBe('/past-screenings');
    expect(pastScreeningsPageHref(2, 'Cold Fish')).toBe(
      '/past-screenings?q=Cold+Fish&page=2'
    );
  });
});
