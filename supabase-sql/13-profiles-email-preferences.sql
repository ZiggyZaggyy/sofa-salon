-- Email notification preferences (Resend). User can choose to receive:
-- 1) Event reminder (活动提示), 2) Waitlist promotion (升级提醒), 3) Post-event rating reminder (活动结束后打分提醒).
-- Default true so existing users keep receiving until they opt out.
-- Run in Supabase SQL Editor once.

ALTER TABLE profiles ADD COLUMN IF NOT EXISTS email_event_reminder boolean DEFAULT true;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS email_waitlist_promotion boolean DEFAULT true;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS email_post_event_rating boolean DEFAULT true;

COMMENT ON COLUMN profiles.email_event_reminder IS 'Receive reminder email before screening (活动提示)';
COMMENT ON COLUMN profiles.email_waitlist_promotion IS 'Receive email when promoted from waitlist (升级提醒)';
COMMENT ON COLUMN profiles.email_post_event_rating IS 'Receive email after screening to rate the film (活动结束后打分提醒)';
