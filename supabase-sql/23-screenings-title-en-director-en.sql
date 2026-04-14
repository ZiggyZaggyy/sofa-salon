-- English display fields: used when site locale is English (optional fallbacks to main title/director).
-- Run in Supabase SQL Editor once (after 02-screenings-year-director-duration.sql).

ALTER TABLE screenings ADD COLUMN IF NOT EXISTS title_en TEXT DEFAULT '';
ALTER TABLE screenings ADD COLUMN IF NOT EXISTS director_en TEXT DEFAULT '';
