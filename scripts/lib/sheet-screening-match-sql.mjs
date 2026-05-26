/**
 * SQL fragment: existing screenings row matches a sheet row (same NY date, same film).
 * Used to skip duplicate INSERTs and to scope title-only patches.
 */
export function matchExistingScreeningSql(sAlias, v) {
  const stripTitle = `regexp_replace(BTRIM(${sAlias}.title), '[（(]\\d{4}[）)]\\s*$', '', 'g')`;
  const hasCjk = `LENGTH(regexp_replace(BTRIM(${sAlias}.title), '[一-龥]', '', 'g')) < LENGTH(BTRIM(${sAlias}.title))`;
  const hasLatin = `LENGTH(regexp_replace(BTRIM(${sAlias}.title), '[A-Za-z]', '', 'g')) < LENGTH(BTRIM(${sAlias}.title))`;
  const bilingual = `(${hasCjk} AND ${hasLatin})`;

  return `(
    (${sAlias}.screening_at AT TIME ZONE 'America/New_York')::date = (${v.screeningAt} AT TIME ZONE 'America/New_York')::date
    AND (
      ${stripTitle} = ${v.title}
      OR (
        ${sAlias}.year IS NOT DISTINCT FROM ${v.year}
        AND (
          ${stripTitle} = ${v.title}
          OR ${bilingual}
        )
        AND (
          NULLIF(BTRIM(${sAlias}.director), '') IS NOT NULL
          OR NULLIF(BTRIM(${sAlias}.director_en), '') IS NOT NULL
          OR ${bilingual}
        )
      )
    )
  )`;
}
