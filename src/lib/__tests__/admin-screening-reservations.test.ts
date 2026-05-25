import {
  normalizeDisplayNameQuery,
  pickAvailableSeatKey,
} from '../admin-screening-reservations';

describe('normalizeDisplayNameQuery', () => {
  it('trims whitespace', () => {
    expect(normalizeDisplayNameQuery('  Ziggy  ')).toBe('Ziggy');
  });
});

describe('pickAvailableSeatKey', () => {
  const all = ['sofa-1:0', 'sofa-1:1', 'sofa-1:squeeze:0'];

  it('returns first free regular seat', () => {
    expect(pickAvailableSeatKey(all, new Set(['sofa-1:0']))).toBe('sofa-1:1');
  });

  it('falls back to squeeze when only squeeze is free', () => {
    expect(
      pickAvailableSeatKey(all, new Set(['sofa-1:0', 'sofa-1:1']))
    ).toBe('sofa-1:squeeze:0');
  });

  it('returns null when full', () => {
    expect(pickAvailableSeatKey(all, new Set(all))).toBeNull();
  });
});
