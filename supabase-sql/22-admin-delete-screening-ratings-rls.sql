-- Admins may delete any rating row for a screening so that removing an event
-- (and CASCADE from screenings) succeeds under RLS. CASCADE runs as the invoker.
-- Run in Supabase SQL Editor once (after 04-ratings-and-ticker.sql).

CREATE POLICY "Admin delete screening_ratings" ON screening_ratings
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = TRUE)
  );
