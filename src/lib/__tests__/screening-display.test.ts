import { screeningDisplayDirector, screeningDisplayTitle } from '@/lib/screening-display';

describe('screeningDisplayTitle', () => {
  it('uses title_en when locale is English and title_en is non-empty', () => {
    expect(screeningDisplayTitle('en', '重庆森林', 'Chungking Express')).toBe('Chungking Express');
  });

  it('falls back to title when English locale and title_en is blank', () => {
    expect(screeningDisplayTitle('en', '重庆森林', '')).toBe('重庆森林');
    expect(screeningDisplayTitle('en', '重庆森林', null)).toBe('重庆森林');
    expect(screeningDisplayTitle('en', '重庆森林', '   ')).toBe('重庆森林');
  });

  it('always uses main title for Chinese locale', () => {
    expect(screeningDisplayTitle('zh', '重庆森林', 'Chungking Express')).toBe('重庆森林');
  });
});

describe('screeningDisplayDirector', () => {
  it('uses director_en when locale is English and set', () => {
    expect(screeningDisplayDirector('en', '王家卫', 'Wong Kar-wai')).toBe('Wong Kar-wai');
  });

  it('falls back for English when director_en empty', () => {
    expect(screeningDisplayDirector('en', '王家卫', '')).toBe('王家卫');
  });

  it('uses main director for Chinese locale', () => {
    expect(screeningDisplayDirector('zh', '王家卫', 'Wong Kar-wai')).toBe('王家卫');
  });
});
