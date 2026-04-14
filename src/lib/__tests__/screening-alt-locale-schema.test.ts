import {
  hasNonEmptyAltLocaleScreeningFields,
  isMissingAltLocaleScreeningColumnsError,
  isScreeningAltLocaleTableMissingError,
} from '@/lib/screening-alt-locale-schema';

describe('isMissingAltLocaleScreeningColumnsError', () => {
  it('returns true for schema cache message mentioning director_en', () => {
    expect(
      isMissingAltLocaleScreeningColumnsError(
        "Could not find the 'director_en' column of 'screenings' in the schema cache"
      )
    ).toBe(true);
  });

  it('returns true when title_en is missing from schema', () => {
    expect(
      isMissingAltLocaleScreeningColumnsError("column screenings.title_en does not exist")
    ).toBe(true);
  });

  it('returns false for unrelated errors', () => {
    expect(isMissingAltLocaleScreeningColumnsError('duplicate key value')).toBe(false);
    expect(isMissingAltLocaleScreeningColumnsError('title is required')).toBe(false);
  });
});

describe('isScreeningAltLocaleTableMissingError', () => {
  it('returns true when relation screening_alt_locale does not exist', () => {
    expect(
      isScreeningAltLocaleTableMissingError(
        'relation "public.screening_alt_locale" does not exist'
      )
    ).toBe(true);
  });

  it('returns true for schema cache message', () => {
    expect(
      isScreeningAltLocaleTableMissingError(
        "Could not find the table 'public.screening_alt_locale' in the schema cache"
      )
    ).toBe(true);
  });

  it('returns false for unrelated errors', () => {
    expect(isScreeningAltLocaleTableMissingError('duplicate key value')).toBe(false);
    expect(isScreeningAltLocaleTableMissingError('title is required')).toBe(false);
  });
});

describe('hasNonEmptyAltLocaleScreeningFields', () => {
  it('returns true when either field has non-whitespace content', () => {
    expect(hasNonEmptyAltLocaleScreeningFields('Hello', '')).toBe(true);
    expect(hasNonEmptyAltLocaleScreeningFields(null, '  x  ')).toBe(true);
  });

  it('returns false when both are empty or whitespace', () => {
    expect(hasNonEmptyAltLocaleScreeningFields(null, null)).toBe(false);
    expect(hasNonEmptyAltLocaleScreeningFields('  ', undefined)).toBe(false);
  });
});
