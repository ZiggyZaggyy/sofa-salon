-- Admin-configurable: hours before screening within which a user cancel counts as "no-show" (鸽了).
-- Default 24. Admins can change this in Admin → Settings.
-- Run in Supabase SQL Editor once (optional; app defaults to 24 if missing).

INSERT INTO ticker_config (key, value) VALUES ('cancel_no_show_hours', '24')
  ON CONFLICT (key) DO NOTHING;
