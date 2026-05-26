import { splitBilingualTitle } from '../../../scripts/lib/split-bilingual-title.mjs';

describe('splitBilingualTitle', () => {
  it('splits Chinese + Spanish/English in one title field', () => {
    expect(splitBilingualTitle('女孩们都很好 Las chicas están bien')).toEqual({
      zh: '女孩们都很好',
      latin: 'Las chicas están bien',
    });
  });

  it('returns null for Chinese-only title', () => {
    expect(splitBilingualTitle('女孩们都很好')).toBeNull();
  });

  it('returns null for English-only title', () => {
    expect(splitBilingualTitle('The Girls Are Alright')).toBeNull();
  });
});
