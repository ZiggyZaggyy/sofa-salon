import { shouldShowChineseTitleInEnSubtitle } from '../historical-catalog-ui';

describe('shouldShowChineseTitleInEnSubtitle', () => {
  it('returns false when titles match after trim', () => {
    expect(shouldShowChineseTitleInEnSubtitle(' Taxi Driver ', 'Taxi Driver')).toBe(false);
  });

  it('returns true when Chinese differs from English', () => {
    expect(shouldShowChineseTitleInEnSubtitle('出租车司机', 'Taxi Driver')).toBe(true);
  });
});
