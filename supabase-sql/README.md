# Supabase 额外 SQL（按需运行）

主建表与策略的完整 SQL 在 **`_plans/BUILD_COMPLETE.md`** 里，需要先跑那一整段。

本文件夹里是**之后新增的、单独要跑的内容**：每出现一个新需求或修复，就**新增一个文件**，不会改旧文件。  
这样你可以清楚知道：**这次只要新跑哪个文件**。

## 文件列表

| 文件 | 用途 | 何时跑 |
|------|------|--------|
| `01-profiles-rls-allow-insert.sql` | 允许用户插入自己的 profile 行（修复 “new row violates row-level security policy”） | 出现该 RLS 报错时跑一次 |
| `02-screenings-year-director-duration.sql` | screenings 表增加 year, director, duration_minutes（卡片显示 “1994 · Wong Kar-wai · 98 min”） | 需要卡片显示年份/导演/时长时跑一次 |
| `03-profiles-admin-read-wechat.sql` | 管理员可读所有 profiles 的 wechat_id（座位图点击观众详情） | 需要管理员查看观众微信号时跑一次 |
| `04-ratings-and-ticker.sql` | screening_ratings（用户对影片质量 1–5 星）、ticker_custom、ticker_config（跑马灯管理） | 需要观看历史评分与跑马灯管理时跑一次 |
| `05-reservations-allow-ghost-multi.sql` | 允许同一场次多个幽灵座（同一 admin user_id）；部分唯一索引仅限制非幽灵 | 幽灵座“duplicate key”报错时跑一次 |
| `06-reservations-multi-seat-per-user.sql` | 允许同一用户同一场次多座（带朋友占座）；唯一改为 (screening_id, seat_key) | 需要多座选座功能时跑一次（在 05 之后） |
| `07-reservations-attended.sql` | reservations 增加 attended（出席/鸽了），用于管理员标记与鸽子恢复 | 需要出席记录与放鸽子机制时跑一次 |
| `08-profiles-no-show-badge.sql` | profiles 增加 no_show_count、consecutive_attendances、attendance_count（血条/鸽子/徽章） | 需要血条与徽章时跑一次 |
| `09-ticker-user-messages.sql` | 用户弹幕表 ticker_user_messages（3:1 与管理员内容穿插） | 需要用户弹幕时跑一次 |
| `10-config-cancel-no-show-hours.sql` | ticker_config 默认 cancel_no_show_hours=24（开演前多少小时内取消算鸽了） | 可选，后台设置页可覆盖 |
| `11-reservations-drop-screening-user-unique.sql` | 删除 (screening_id, user_id) 唯一约束的正确名称，修复 Add ghost 报 duplicate key | 出现该报错时跑一次 |
| `12-reservations-friend-avatar.sql` | reservations 增加 friend_avatar（朋友座随机样子，本人座无血条） | 需要“再占一座”显示朋友样式时跑一次 |
| `15-ticker-custom-created-by.sql` | ticker_custom 增加 created_by（管理员发的跑马灯显示「放映人 名字：内容」） | 需要跑马灯显示管理员署名时跑一次 |
| `16-ticker-system-events.sql` | ticker_system_events（活动取消/改期系统通知，约 3 天有效）+ ticker_config 默认 show_reschedule_cancel_ticker | 需要管理员删除/改期活动并显示跑马灯通知时跑一次 |

在 Supabase 控制台 → **SQL Editor** 里打开对应文件，复制内容执行即可。
