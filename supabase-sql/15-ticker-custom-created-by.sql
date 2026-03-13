-- Store who added each custom ticker line so we can show "放映人 Name: content".
-- Run in Supabase SQL Editor once.

ALTER TABLE ticker_custom
  ADD COLUMN IF NOT EXISTS created_by UUID REFERENCES profiles(id) ON DELETE SET NULL;

COMMENT ON COLUMN ticker_custom.created_by IS 'Admin who added this line; shown as Host/放映人 in ticker.';
