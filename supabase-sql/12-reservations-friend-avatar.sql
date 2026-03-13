-- Friend seat avatar: when a user books 2nd+ seat (for a friend), we store a random
-- avatar config so the friend seat shows a different appearance and no blood bar.
-- Run in Supabase SQL Editor once.

ALTER TABLE reservations
  ADD COLUMN IF NOT EXISTS friend_avatar JSONB;

COMMENT ON COLUMN reservations.friend_avatar IS 'Avatar config for "friend" seats (2nd+ seat same user); null for own seat.';
