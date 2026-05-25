-- Guest contact: platform (wechat / whatsapp / instagram / discord) + id.
-- Backfill from legacy wechat_id. Run 32 (data) then 33 (unique index) after fixing duplicates.

ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS contact_platform TEXT NOT NULL DEFAULT 'wechat';

ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS contact_id TEXT NOT NULL DEFAULT '';

UPDATE profiles
SET contact_id = btrim(wechat_id)
WHERE btrim(COALESCE(contact_id, '')) = ''
  AND btrim(COALESCE(wechat_id, '')) <> '';

ALTER TABLE profiles DROP CONSTRAINT IF EXISTS profiles_contact_platform_check;
ALTER TABLE profiles
  ADD CONSTRAINT profiles_contact_platform_check
  CHECK (contact_platform IN ('wechat', 'whatsapp', 'instagram', 'discord'));

COMMENT ON COLUMN profiles.contact_platform IS 'wechat | whatsapp | instagram | discord';
COMMENT ON COLUMN profiles.contact_id IS 'Guest contact handle; unique per display_name (see migration 33)';
