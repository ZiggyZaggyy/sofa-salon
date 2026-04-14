import { safeHttpUrl } from '@/lib/safe-http-url';

describe('safeHttpUrl', () => {
  it('returns null for empty input', () => {
    expect(safeHttpUrl('')).toBeNull();
    expect(safeHttpUrl('   ')).toBeNull();
    expect(safeHttpUrl(null)).toBeNull();
  });

  it('keeps valid https URLs', () => {
    expect(safeHttpUrl('https://movie.douban.com/subject/1291999/')).toBe(
      'https://movie.douban.com/subject/1291999/'
    );
  });

  it('prepends https when scheme is missing', () => {
    expect(safeHttpUrl('movie.douban.com/subject/1291999')).toBe(
      'https://movie.douban.com/subject/1291999'
    );
  });

  it('returns null for dangerous schemes', () => {
    expect(safeHttpUrl('javascript:alert(1)')).toBeNull();
    expect(safeHttpUrl('data:text/html,<script>')).toBeNull();
  });

  it('strips zero-width spaces and uses first line', () => {
    expect(safeHttpUrl('https://movie.douban.com/subject/1/\u200b')).toBe('https://movie.douban.com/subject/1/');
    expect(safeHttpUrl('\n\nmovie.douban.com/subject/2')).toBe('https://movie.douban.com/subject/2');
  });

  it('extracts first http(s) URL from a longer pasted string', () => {
    expect(safeHttpUrl('Film: https://letterboxd.com/film/foo/ (recommended)')).toBe(
      'https://letterboxd.com/film/foo/'
    );
  });
});
