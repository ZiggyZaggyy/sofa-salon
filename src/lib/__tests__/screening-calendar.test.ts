import {
  DEFAULT_SCREENING_DURATION_MIN,
  buildGoogleCalendarTemplateUrl,
  buildScreeningIcs,
  escapeIcsText,
  formatGoogleCalendarUtc,
  screeningCalendarUid,
  screeningEndUtc,
} from '../screening-calendar';

describe('formatGoogleCalendarUtc', () => {
  it('formats as compact UTC for Google dates=', () => {
    const d = new Date('2026-03-15T19:00:00.000Z');
    expect(formatGoogleCalendarUtc(d)).toBe('20260315T190000Z');
  });
});

describe('screeningEndUtc', () => {
  it('uses default duration when minutes missing', () => {
    const start = new Date('2026-01-01T10:00:00.000Z');
    const end = screeningEndUtc(start, null);
    expect(end.getTime() - start.getTime()).toBe(DEFAULT_SCREENING_DURATION_MIN * 60 * 1000);
  });

  it('respects positive duration_minutes', () => {
    const start = new Date('2026-01-01T10:00:00.000Z');
    const end = screeningEndUtc(start, 45);
    expect(end.getTime() - start.getTime()).toBe(45 * 60 * 1000);
  });
});

describe('buildGoogleCalendarTemplateUrl', () => {
  it('includes action=TEMPLATE and unencoded slash in dates', () => {
    const start = new Date('2026-06-01T12:00:00.000Z');
    const end = new Date('2026-06-01T14:00:00.000Z');
    const url = buildGoogleCalendarTemplateUrl({
      title: 'Film Night',
      start,
      end,
      details: 'Line1\nLine2',
    });
    expect(url).toContain('action=TEMPLATE');
    expect(url).toContain('20260601T120000Z/20260601T140000Z');
    expect(url).toContain(encodeURIComponent('Film Night'));
  });
});

describe('escapeIcsText', () => {
  it('escapes backslash, newline, semicolon, comma', () => {
    expect(escapeIcsText('a\\b\nc,d;')).toBe('a\\\\b\\nc\\,d\\;');
  });
});

describe('buildScreeningIcs', () => {
  it('returns CRLF VCALENDAR with DTSTART/DTEND', () => {
    const ics = buildScreeningIcs({
      uid: 'evt@test.example',
      title: 'My Event',
      description: 'Details here',
      start: new Date('2026-05-10T18:30:00.000Z'),
      end: new Date('2026-05-10T21:00:00.000Z'),
      url: 'https://example.com/s/1',
    });
    expect(ics).toContain('\r\n');
    expect(ics).toContain('BEGIN:VCALENDAR');
    expect(ics).toContain('BEGIN:VEVENT');
    expect(ics).toContain('DTSTART:20260510T183000Z');
    expect(ics).toContain('DTEND:20260510T210000Z');
    expect(ics).toContain('END:VEVENT');
    expect(ics).toContain('END:VCALENDAR');
    expect(ics).toContain('UID:evt@test.example');
  });
});

describe('screeningCalendarUid', () => {
  it('suffixes host from CUSTOMER_SITE_ORIGIN', () => {
    expect(screeningCalendarUid('abc')).toMatch(/^abc@/);
  });
});
