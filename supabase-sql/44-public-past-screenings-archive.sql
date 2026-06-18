-- =============================================================================
-- 44 — Public past screenings archive
-- =============================================================================
-- Lets anonymous and signed-in visitors browse completed screenings.
-- Admin write policies are unchanged. Future inactive screenings remain private.
-- =============================================================================

DROP POLICY IF EXISTS "Authenticated read past screenings" ON screenings;
DROP POLICY IF EXISTS "Public read past screenings" ON screenings;

CREATE POLICY "Public read past screenings" ON screenings
  FOR SELECT
  TO anon, authenticated
  USING (screening_at < now());
