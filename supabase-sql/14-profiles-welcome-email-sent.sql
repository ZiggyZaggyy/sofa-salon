-- Track whether we've sent the post-signup welcome email (so we only send once).
-- Run in Supabase SQL Editor once.

ALTER TABLE profiles ADD COLUMN IF NOT EXISTS welcome_email_sent_at timestamptz DEFAULT null;

COMMENT ON COLUMN profiles.welcome_email_sent_at IS 'When we sent the welcome/reminder email after signup (once per user)';
