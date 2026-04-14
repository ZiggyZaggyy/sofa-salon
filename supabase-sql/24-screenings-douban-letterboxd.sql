-- Optional external links for a screening (Douban, Letterboxd).
-- Run once in Supabase SQL Editor if these columns are not present yet.

ALTER TABLE screenings ADD COLUMN IF NOT EXISTS douban_url TEXT DEFAULT '';
ALTER TABLE screenings ADD COLUMN IF NOT EXISTS letterboxd_url TEXT DEFAULT '';
