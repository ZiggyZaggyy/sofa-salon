-- Admins may UPDATE reservations (attended / no-show marks).
-- Without this, only SELECT/INSERT/DELETE policies apply — admin attendance API
-- updates 0 rows with no error when using the user JWT client.
--
-- Requires: 03-profiles-admin-read-wechat.sql (function public.current_user_is_admin).

DROP POLICY IF EXISTS "Admin update reservations" ON reservations;
CREATE POLICY "Admin update reservations" ON reservations
  FOR UPDATE
  USING (public.current_user_is_admin())
  WITH CHECK (public.current_user_is_admin());
