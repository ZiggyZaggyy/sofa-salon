-- Remove mistaken duplicate screening「东邪西毒之东邪西毒」and all attendance tied to it.
-- Reservations / waitlist / ratings CASCADE from screenings delete.
-- Badge counts drop automatically (present = reservations where attended IS DISTINCT FROM false).
--
-- Run in Supabase SQL Editor. Review step 1–2, then run step 3.

-- ========== 1. Screening row(s) to delete ==========
SELECT id AS screening_id, title, title_en, director, screening_at, is_active, created_at
FROM screenings
WHERE title ILIKE '%东邪西毒之东邪西毒%'
   OR title = '东邪西毒之东邪西毒'
ORDER BY screening_at DESC;

-- ========== 2. Reservations that will be removed (attendance) ==========
SELECT
  r.id AS reservation_id,
  r.user_id,
  p.display_name,
  r.seat_key,
  r.attended,
  r.is_ghost,
  r.created_at,
  s.title,
  s.screening_at
FROM reservations r
JOIN screenings s ON s.id = r.screening_id
JOIN profiles p ON p.id = r.user_id
WHERE s.title ILIKE '%东邪西毒之东邪西毒%'
   OR s.title = '东邪西毒之东邪西毒'
ORDER BY p.display_name, r.created_at;

-- ========== 3. Delete (only when step 1–2 look correct) ==========
DELETE FROM screenings
WHERE title ILIKE '%东邪西毒之东邪西毒%'
   OR title = '东邪西毒之东邪西毒';
