import { screeningDeleteSkipsCancellationNotify } from '@/lib/screening-delete-policy';

describe('screeningDeleteSkipsCancellationNotify', () => {
  it('returns true when screening time is before now', () => {
    const now = new Date('2026-04-12T12:00:00Z').getTime();
    expect(screeningDeleteSkipsCancellationNotify('2026-04-11T20:00:00Z', now)).toBe(true);
  });

  it('returns false when screening time is at or after now', () => {
    const now = new Date('2026-04-12T12:00:00Z').getTime();
    expect(screeningDeleteSkipsCancellationNotify('2026-04-12T12:00:00Z', now)).toBe(false);
    expect(screeningDeleteSkipsCancellationNotify('2026-04-13T20:00:00Z', now)).toBe(false);
  });

  it('returns false for invalid date string', () => {
    expect(screeningDeleteSkipsCancellationNotify('not-a-date', Date.now())).toBe(false);
  });
});
