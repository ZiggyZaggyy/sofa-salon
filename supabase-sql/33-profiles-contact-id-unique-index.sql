-- Uniqueness: same display_name + same contact_id cannot exist twice (case-insensitive).
-- Different display names MAY share the same contact_id.
-- Replaces an earlier global-on-contact_id-only index if present.

DROP INDEX IF EXISTS profiles_contact_id_lower_unique;

CREATE UNIQUE INDEX IF NOT EXISTS profiles_display_name_contact_id_unique
  ON profiles (lower(btrim(display_name)), lower(btrim(contact_id)))
  WHERE btrim(contact_id) <> '';
