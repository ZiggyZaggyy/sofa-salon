-- Fix "duplicate key value violates unique constraint reservations_screening_id_user_id_key"
-- when adding multiple ghost seats. The DB may use reservations_screening_id_user_id_key
-- (with 's'); 05 drops reservation_screening_id_user_id_key (no 's'). Drop both names.
-- Run in Supabase SQL Editor once.

ALTER TABLE reservations DROP CONSTRAINT IF EXISTS reservations_screening_id_user_id_key;
ALTER TABLE reservations DROP CONSTRAINT IF EXISTS reservation_screening_id_user_id_key;
