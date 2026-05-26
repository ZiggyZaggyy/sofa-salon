import {
  catalogSeatKeyForUser,
  escapeIlikePrefix,
  postgrestUuidInList,
} from '../historical-catalog';

describe('catalogSeatKeyForUser', () => {
  it('is stable and uses catalog prefix', () => {
    const uid = 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee';
    expect(catalogSeatKeyForUser(uid)).toBe('catalog-aaaaaaaabbbb');
    expect(catalogSeatKeyForUser(uid)).toBe(catalogSeatKeyForUser(uid));
  });
});

describe('escapeIlikePrefix', () => {
  it('escapes ilike metacharacters', () => {
    expect(escapeIlikePrefix('100%')).toBe('100\\%');
    expect(escapeIlikePrefix('a_b')).toBe('a\\_b');
  });
});

describe('postgrestUuidInList', () => {
  it('formats UUIDs without quotes for PostgREST not.in', () => {
    const a = 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee';
    const b = '11111111-2222-4333-8444-555555555555';
    expect(postgrestUuidInList([a, b])).toBe(`(${a},${b})`);
    expect(postgrestUuidInList([a, b])).not.toContain('"');
  });
});
