-- 手动把「已标记为 promoted 但当时没有真正写入 reservations」的候补补进预约表
-- Run in Supabase SQL Editor.
--
-- Step 1: 先跑下面的「查询」，得到 screening_id、user_id、display_name
-- Step 2: 确定该场次的一个空座位 seat_key（在首页或管理员座位图里看哪个座是空的，例如 sofa-0:0 或 sofa-0:squeeze:0）
-- Step 3: 把下面「执行」里的三处占位符换成实际值，再执行

-- ========== 查询：找出被误标 promoted 但没有预约的人 ==========
SELECT w.id AS waitlist_id, w.screening_id, w.user_id, w.status, w.position,
       p.display_name,
       (SELECT COUNT(*) FROM reservations r WHERE r.screening_id = w.screening_id AND r.user_id = w.user_id) AS reservation_count
FROM waitlist w
LEFT JOIN profiles p ON p.id = w.user_id
WHERE w.status = 'promoted'
  AND NOT EXISTS (
    SELECT 1 FROM reservations r
    WHERE r.screening_id = w.screening_id AND r.user_id = w.user_id
  )
ORDER BY w.screening_id, w.position;

-- ========== 执行：把上面查到的 screening_id、user_id 和你要给的 seat_key 填进去后整段执行 ==========
/*
INSERT INTO reservations (screening_id, user_id, seat_key, is_squeezed)
VALUES (
  '这里填 screening_id'::uuid,
  '这里填 user_id'::uuid,
  '这里填空座 seat_key，如 sofa-0:0',
  false
);

UPDATE waitlist SET status = 'promoted'
WHERE screening_id = '这里填 screening_id'::uuid AND user_id = '这里填 user_id'::uuid;

SELECT reorder_waitlist('这里填 screening_id'::uuid);
*/
