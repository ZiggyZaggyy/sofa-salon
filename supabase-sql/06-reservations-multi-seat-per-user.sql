-- Allow one user to have multiple seats per screening (e.g. bring friends).
-- Drop the partial unique on (screening_id, user_id) and enforce only
-- one reservation per seat per screening.
-- Run after 05-reservations-allow-ghost-multi.sql. Run in Supabase SQL Editor once.

DROP INDEX IF EXISTS reservation_screening_id_user_id_non_ghost_key;

CREATE UNIQUE INDEX IF NOT EXISTS reservation_screening_id_seat_key_key
  ON reservations (screening_id, seat_key);
