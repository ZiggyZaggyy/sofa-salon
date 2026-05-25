-- Duplicate (display_name, contact_id) pairs — fix before running 33.
-- Same contact_id on different display names is allowed and will not appear here.

SELECT
  lower(btrim(display_name)) AS display_name_normalized,
  lower(btrim(contact_id)) AS contact_id_normalized,
  count(*) AS profile_count,
  array_agg(id ORDER BY created_at) AS user_ids,
  array_agg(display_name ORDER BY created_at) AS display_names,
  array_agg(contact_platform ORDER BY created_at) AS platforms,
  array_agg(contact_id ORDER BY created_at) AS contact_ids
FROM profiles
WHERE btrim(contact_id) <> ''
GROUP BY lower(btrim(display_name)), lower(btrim(contact_id))
HAVING count(*) > 1
ORDER BY profile_count DESC, display_name_normalized;
