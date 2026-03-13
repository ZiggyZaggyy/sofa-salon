-- Allow multiple ghost seats per screening (same admin user_id).
-- Drop the unique on (screening_id, user_id) and add a partial unique index
-- so only non-ghost reservations are unique per (screening, user).
-- Run in Supabase SQL Editor once.

ALTER TABLE reservations DROP CONSTRAINT IF EXISTS reservation_screening_id_user_id_key;

CREATE UNIQUE INDEX reservation_screening_id_user_id_non_ghost_key
  ON reservations (screening_id, user_id)
  WHERE (is_ghost IS NOT TRUE);
