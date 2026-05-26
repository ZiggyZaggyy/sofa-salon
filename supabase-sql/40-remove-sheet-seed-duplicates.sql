-- Remove duplicate sheet-seed rows after an older 37 run (site row + seed row same film).
-- Keeps the row that was already on the site; deletes is_active = false seed duplicate.
-- Skips seed rows that still have reservations (merge or move those first).
-- Regenerate: node scripts/generate-historical-screenings-sql.mjs

DELETE FROM screenings AS seed
WHERE seed.is_active = false
  AND EXISTS (
    SELECT 1 FROM screenings AS site
    WHERE site.id <> seed.id
      AND (
    (site.screening_at AT TIME ZONE 'America/New_York')::date = (seed.screening_at AT TIME ZONE 'America/New_York')::date
    AND (
      regexp_replace(BTRIM(site.title), '[（(]\d{4}[）)]\s*$', '', 'g') = seed.title
      OR (
        site.year IS NOT DISTINCT FROM seed.year
        AND (
          regexp_replace(BTRIM(site.title), '[（(]\d{4}[）)]\s*$', '', 'g') = seed.title
          OR (LENGTH(regexp_replace(BTRIM(site.title), '[一-龥]', '', 'g')) < LENGTH(BTRIM(site.title)) AND LENGTH(regexp_replace(BTRIM(site.title), '[A-Za-z]', '', 'g')) < LENGTH(BTRIM(site.title)))
        )
        AND (
          NULLIF(BTRIM(site.director), '') IS NOT NULL
          OR NULLIF(BTRIM(site.director_en), '') IS NOT NULL
          OR (LENGTH(regexp_replace(BTRIM(site.title), '[一-龥]', '', 'g')) < LENGTH(BTRIM(site.title)) AND LENGTH(regexp_replace(BTRIM(site.title), '[A-Za-z]', '', 'g')) < LENGTH(BTRIM(site.title)))
        )
      )
    )
  )
  )
  AND NOT EXISTS (
    SELECT 1 FROM reservations r WHERE r.screening_id = seed.id
  );
