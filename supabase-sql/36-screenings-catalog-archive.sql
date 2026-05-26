-- =============================================================================
-- 36 — Past screening read access (run before 37)
-- =============================================================================
-- Adds one RLS policy: signed-in users can SELECT any screening with screening_at < now().
-- Needed for /profile/history (search + claim past screenings).
-- Does not add columns or tables. Home page unchanged (still is_active + upcoming only).
-- =============================================================================

DROP POLICY IF EXISTS "Public read catalog archive screenings" ON screenings;
DROP POLICY IF EXISTS "Authenticated read past screenings" ON screenings;

CREATE POLICY "Authenticated read past screenings" ON screenings
  FOR SELECT
  TO authenticated
  USING (screening_at < now());
