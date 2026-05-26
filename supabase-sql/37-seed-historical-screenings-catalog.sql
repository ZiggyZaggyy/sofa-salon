-- =============================================================================
-- 37 — Sheet seed + safe title sync (run once after 36)
-- =============================================================================
-- (A) INSERT sheet rows only when no matching screening already exists on that NY date
--     (same Chinese title, or same year + site director set, or bilingual title in one field).
--     Does NOT insert a second row when only the sheet director differs.
--
-- (B) Patch empty title / title_en on the matching existing row only.
--
-- (C) Split site rows that stored "中文 Foreign title" in title alone → title + title_en.
--
-- Re-run safe. Regenerate: node scripts/generate-historical-screenings-sql.mjs
-- If you already ran an older 37 and see duplicates, run 40-remove-sheet-seed-duplicates.sql first.
-- =============================================================================

-- (A) Sheet seed (skip when site already has this screening)
INSERT INTO screenings (
  id,
  title,
  title_en,
  director,
  director_en,
  year,
  screening_at,
  is_active
)
SELECT
  v.id,
  v.title,
  v.title_en,
  v.director,
  v.director_en,
  v.year,
  v.screening_at,
  v.is_active
FROM (
  VALUES
(
  'f678fc6d-e093-4e64-a344-cf47eac24074'::uuid,
  '笑刃荒途',
  'I Only Rest in the Storm',
  'Pedro Pinho',
  'Pedro Pinho',
  2025,
  ('2026-05-09 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '24a61254-b4fd-4635-8485-cc1790b8bcc3'::uuid,
  '和你在一起',
  'Together',
  '陈凯歌',
  '',
  2002,
  ('2026-05-06 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'f8012e98-b6be-46c8-9f47-68993a15c04e'::uuid,
  '色情酒店',
  'Exotica',
  'Atom Egoyan',
  'Atom Egoyan',
  1994,
  ('2026-05-24 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '9e2c7ab0-9d55-4835-a418-3469e65ba7ba'::uuid,
  '蒙巴纳斯',
  '',
  'Mikhaël Hers',
  'Mikhaël Hers',
  2009,
  ('2026-05-23 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'f1acc183-5eee-4d98-9e2d-fdfc87e3d360'::uuid,
  '报春花冈',
  '',
  'Mikhaël Hers',
  'Mikhaël Hers',
  2007,
  ('2026-05-23 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '688bb515-d375-48fa-ac58-e796ec95726e'::uuid,
  '盗日者',
  'The Man Who Stole the Sun',
  '长谷川和彦',
  '',
  1979,
  ('2026-05-21 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '2b149498-556a-4f1b-82f5-42d140967773'::uuid,
  '花月佳期',
  'Love in the Time of Twilight',
  '徐克',
  '',
  1995,
  ('2026-05-20 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '8353baa3-a562-45bb-be38-679930ada613'::uuid,
  '黑道小狂花',
  'Sisters',
  'Sergei Bodrov Jr.',
  'Sergei Bodrov Jr.',
  2001,
  ('2026-05-14 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '44635d00-0f31-4619-916e-a9e7d235b21c'::uuid,
  '晚安，母亲',
  '''night, Mother',
  'Tom Moore/Martha Norman',
  'Tom Moore/Martha Norman',
  1986,
  ('2026-05-10 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '84615d2e-c39f-4578-a868-db5086db47d0'::uuid,
  '红色之路',
  'Red Road',
  'Andrea Arnold',
  'Andrea Arnold',
  2006,
  ('2026-05-01 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '4b7f635e-a07d-4e67-99cb-d62124e37671'::uuid,
  '肉与灵',
  'On Body and Soul',
  'Ildikó Enyedi',
  'Ildikó Enyedi',
  2017,
  ('2026-04-07 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '5884da3f-53a8-49f5-8716-dafe1c8286fd'::uuid,
  '布拉格之恋',
  'The Unbearable Lightness of Being',
  'Philip Kaufman',
  'Philip Kaufman',
  1988,
  ('2026-04-05 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'ff97cd58-abd8-41d0-b58e-0cb191959641'::uuid,
  '影子部队',
  'Army of Shadows',
  'Jean-Pierre Melville',
  'Jean-Pierre Melville',
  1969,
  ('2026-04-03 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '2350d26c-0104-43f2-b46f-668b7848ca09'::uuid,
  '刀',
  'The Blade',
  '徐克',
  '',
  1995,
  ('2026-04-29 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'f5f0bf14-909b-4720-aff9-60e093f1df70'::uuid,
  '香蕉天堂',
  'Banana Paradise',
  '王童',
  '',
  1989,
  ('2026-04-24 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '43fbb355-a4a1-498d-aeea-83a4d5b88ace'::uuid,
  '上海之夜',
  'Shanghai Blues',
  '徐克',
  '',
  1984,
  ('2026-04-22 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '3e53581f-314c-4dfe-a0fa-103ea283cad6'::uuid,
  '生生长流',
  'Life, and Nothing More…',
  'Abbas Kiarostami',
  'Abbas Kiarostami',
  1992,
  ('2026-04-02 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'fa0b6093-b194-4094-aeac-a0f1f26f5496'::uuid,
  '我记住的歌',
  'A Song I Remember',
  '杉田协士',
  '',
  2011,
  ('2026-04-14 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '366acbb9-7816-4be1-a48a-d760353e271e'::uuid,
  '疯劫',
  'The Secret',
  '许鞍华/陈韵文',
  '',
  1979,
  ('2026-04-13 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '66a23c55-e721-47e2-9e10-7fb209031795'::uuid,
  '谁要杀死杰茜？',
  'Who Wants to Kill Jessie?',
  'Václav Vorlícek',
  'Václav Vorlícek',
  1966,
  ('2026-04-10 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'c1c8ff78-c68a-4c39-8db6-23b4e18e29c6'::uuid,
  '破碎之镜',
  'Broken Mirrors',
  'Marleen Gorris',
  'Marleen Gorris',
  1984,
  ('2026-03-09 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '27afcb76-86d0-488b-ba44-30874054abe8'::uuid,
  '她们的疯狂',
  'Sheer Madness',
  'Margarethe von Trotta',
  'Margarethe von Trotta',
  1983,
  ('2026-03-08 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'ce5fd274-02e8-46e9-b619-7e2a89dbc378'::uuid,
  '夜班时分',
  'Nightshift',
  'Robina Rose',
  'Robina Rose',
  1981,
  ('2026-03-07 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '1315e247-5e6c-4da8-a59c-09273259174d'::uuid,
  '情色剧院',
  'Variety',
  'Bette Gordon',
  'Bette Gordon',
  1983,
  ('2026-03-07 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '68e87862-0288-40d0-8875-53803d37f072'::uuid,
  '真幻之爱',
  'Love on the Ground',
  'Jacques Rivette',
  'Jacques Rivette',
  1984,
  ('2026-03-07 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '833adb7e-337e-4fe3-9a03-f020674ae161'::uuid,
  '谢尔曼的征程',
  'Sherman''s March',
  'Ross McElwee',
  'Ross McElwee',
  1985,
  ('2026-03-06 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'e92a95fc-ec46-4b3f-bf6a-9fc73e659708'::uuid,
  '金都',
  'My Prince Edward',
  '黄绮琳',
  '',
  2019,
  ('2026-03-05 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '374bc4a9-0b7c-41dc-954d-1a12459cf63d'::uuid,
  '女孩们都很好',
  'The Girls Are Alright',
  'Itsaso Arana',
  'Itsaso Arana',
  2023,
  ('2026-03-31 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '70d39c13-ff5e-4344-9dc5-b925aab01abf'::uuid,
  '家书',
  'Letters Home',
  'Chantal Akerman/Rose Leiman Goldemberg',
  'Chantal Akerman/Rose Leiman Goldemberg',
  1986,
  ('2026-03-28 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '7d6f7e38-ac12-40ac-ba40-d013f4f412e0'::uuid,
  '明天我们搬家',
  'Tomorrow We Move',
  'Chantal Akerman',
  'Chantal Akerman',
  2004,
  ('2026-03-27 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'cd1fd2ab-898c-4991-af07-85eeacb15e53'::uuid,
  '名剑',
  'The Sword',
  '谭家明',
  '',
  1980,
  ('2026-03-25 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'ce8e6555-13ad-40de-8648-9867b9c6bab9'::uuid,
  'DB',
  'DB',
  '张帅',
  '',
  2026,
  ('2026-03-22 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'c1fe0593-1c26-47fd-8646-4d3e0a368125'::uuid,
  '唐朝豪放女',
  'An Amorous Woman of Tang Dynasty',
  '方令正',
  '',
  1984,
  ('2026-03-20 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '25e2092f-165f-4640-82f3-3613eb2ff105'::uuid,
  '对她说',
  'Talk to Her',
  'Pedro Almodóvar',
  'Pedro Almodóvar',
  2002,
  ('2026-03-16 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '634401eb-45a6-4f0b-85a6-d62c257796a5'::uuid,
  '曼谷之夜',
  'Bangkok Nites',
  '富田克也',
  '',
  2016,
  ('2026-03-14 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '74e3108f-98b9-4134-9bbd-57d0e28b8097'::uuid,
  '绿行星',
  'La Belle Verte',
  'Coline Serreau',
  'Coline Serreau',
  1996,
  ('2026-03-13 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '158fb949-9b3b-449b-bc35-a328ef62641c'::uuid,
  '是的',
  'Yes',
  'Nadav Lapid',
  'Nadav Lapid',
  2025,
  ('2026-03-11 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '71d92c71-941b-4f35-b9da-2b87b6877450'::uuid,
  '镜的第三乐章',
  'Miroirs No. 3',
  'Christian Petzold',
  'Christian Petzold',
  2025,
  ('2026-02-09 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '466f2df1-fac9-4b6a-baf8-aba52b9cc45e'::uuid,
  '热带小径',
  'Tropical Paths',
  'Joaquim Pedro de Andrade',
  'Joaquim Pedro de Andrade',
  1977,
  ('2026-02-09 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'fc38e887-637d-4f66-9a0b-e9fdf88d47f5'::uuid,
  '梦想的生活',
  'Dream Life',
  'Mireille Dansereau',
  'Mireille Dansereau',
  1972,
  ('2026-02-03 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '7e4fc124-9bb8-49b7-b7b1-b8d36e10b9d4'::uuid,
  '空山灵雨',
  'Raining in the Mountain',
  '胡金铨',
  '',
  1979,
  ('2026-02-28 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '08e59dd4-a56c-494c-b2ff-b33168cc3e38'::uuid,
  '死亡万岁',
  'Long Live Death',
  'Fernando Arrabal',
  'Fernando Arrabal',
  1971,
  ('2026-02-27 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '8218695c-9e33-4c34-9ad0-8c7c2cc290ac'::uuid,
  '破碎太阳之心',
  'A Short Story',
  '毕赣',
  '',
  2022,
  ('2026-02-26 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'f8d18682-a80a-4d34-be8b-6b9e5238541a'::uuid,
  '杀手蝴蝶梦',
  'My Heart Is That Eternal Rose',
  '谭家明',
  '',
  1989,
  ('2026-02-26 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'a0d9b7a6-ca56-45fd-b6f0-7b7461c8cc90'::uuid,
  '时间不确定',
  'Time Indefinite',
  'Ross McElwee',
  'Ross McElwee',
  1993,
  ('2026-02-25 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'fd4e60f3-a89a-4918-b38a-de805032202d'::uuid,
  '卡洛斯',
  'Carlos',
  'Olivier Assayas',
  'Olivier Assayas',
  2010,
  ('2026-02-21 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '2190e7b1-bacb-4006-99e0-4a624488c3da'::uuid,
  '耶里肖',
  'Jerichow',
  'Christian Petzold',
  'Christian Petzold',
  2008,
  ('2026-02-19 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'eb196938-e023-4636-80bd-ba81b0b11aee'::uuid,
  '八仙饭店之人肉叉烧包',
  'The Untold Story',
  '邱礼涛',
  '',
  1993,
  ('2026-02-16 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'dfc2a67e-cb5a-4c63-916b-192e1e093028'::uuid,
  '一只市民阶级犬的自我批评',
  'Self-Criticism of a Bourgeois Dog',
  'Julian Radlmaier',
  'Julian Radlmaier',
  2017,
  ('2026-02-12 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '543818e7-c86b-4bfc-abd7-90d8942a8b6e'::uuid,
  '我的二十世纪',
  'My Twentieth Century',
  'Ildikó Enyedi',
  'Ildikó Enyedi',
  1989,
  ('2026-02-11 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'd3733fab-ce19-45bc-be29-0940bb654425'::uuid,
  '巴黎夏日',
  'That Summer in Paris',
  'Valentine Cadic',
  'Valentine Cadic',
  2025,
  ('2026-01-07 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '20759269-6525-4eb1-b36d-2bd5ee1cf3df'::uuid,
  '夏日假期',
  'The Summer Holidays',
  'Valentine Cadic',
  'Valentine Cadic',
  2022,
  ('2026-01-07 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '426f20a5-860d-4723-8d9f-a3fc3f7b8c5a'::uuid,
  '流氓医生',
  'Doctor Mack',
  '李志毅',
  '',
  1995,
  ('2026-01-03 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'f2ebe714-506b-4fba-bfd3-d09c09f7fc9b'::uuid,
  '猎鹰湖',
  'Falcon Lake',
  'Charlotte Le Bon',
  'Charlotte Le Bon',
  2022,
  ('2026-01-20 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'fc1d86db-240d-4824-babd-5d40832a5cc5'::uuid,
  '光明的未来',
  'Bright Future',
  '黑泽清',
  '',
  2002,
  ('2026-01-02 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'c8b6a371-6211-420a-a8e6-44671f9ecb19'::uuid,
  '电话铃响的时候',
  'When the Phone Rang',
  'Iva Radivojević',
  'Iva Radivojević',
  2025,
  ('2026-01-16 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '7f17d1cd-b09a-4a45-b5ee-1aa8e9fac17e'::uuid,
  '情人',
  'The Lover',
  'Valery Todorovsky',
  'Valery Todorovsky',
  2002,
  ('2026-01-14 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '65c59180-bb30-47ee-a0e4-7ee0f29971bd'::uuid,
  '舍间声响',
  'Neighboring Sounds',
  'Kleber Mendonça Filho',
  'Kleber Mendonça Filho',
  2012,
  ('2026-01-13 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '2fc31e54-2202-4329-9f85-2e8980badf9f'::uuid,
  '无熊之境',
  'No Bears',
  'Jafar Panahi',
  'Jafar Panahi',
  2022,
  ('2025-07-01 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '6aeebbdc-92c8-4dca-89dc-a97bb53e1fae'::uuid,
  '妖怪人',
  'Kummatty',
  'Govindan Aravindan',
  'Govindan Aravindan',
  1979,
  ('2025-06-09 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'fa95729c-5f1c-43af-b431-31d85214a17d'::uuid,
  'Rehearsals for Retirement',
  'Rehearsals for Retirement',
  'Philip S. Solomon',
  'Philip S. Solomon',
  2007,
  ('2025-06-09 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '703f63c6-a6ab-4e43-bc35-8a72bcd33332'::uuid,
  '安然无恙',
  'Safe',
  'Todd Haynes',
  'Todd Haynes',
  1995,
  ('2025-06-08 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'df3b7b35-7fab-44b6-903b-590b4db3bd5f'::uuid,
  '医生',
  'Doctor',
  '钟孟宏',
  '',
  2006,
  ('2025-06-07 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '36f0ebc5-4e0c-43c9-b990-1c3876cbf4e0'::uuid,
  '奥兰多',
  'Orlando',
  'Sally Potter',
  'Sally Potter',
  1992,
  ('2025-06-06 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'c88572bb-6e74-44c6-a398-5e9cd36f0306'::uuid,
  '宽恕',
  'Misericordia',
  'Alain Guiraudie',
  'Alain Guiraudie',
  2024,
  ('2025-06-04 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '5ffb818f-31bc-4d61-ab7c-39f6f9633254'::uuid,
  '日常',
  'Decameron',
  '许雅舒',
  '',
  2021,
  ('2025-06-27 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'fab7177e-58e6-44fb-b8e0-50f066298fa2'::uuid,
  '星球大战',
  'Star Wars',
  'George Lucas',
  'George Lucas',
  1977,
  ('2025-06-24 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'a8d6cd46-e8df-43a4-9607-0224ad071bdd'::uuid,
  '四月物语',
  'April Story',
  '岩井俊二',
  '',
  1998,
  ('2025-06-21 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '7435360b-914c-47a9-8b57-79720c342c32'::uuid,
  '杀羊人',
  'Killer of Sheep',
  'Charles Burnett',
  'Charles Burnett',
  1978,
  ('2025-06-18 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '93ae1548-a159-416a-8cac-07461680fe98'::uuid,
  '恋恋风尘',
  'Dust in the Wind',
  '侯孝贤',
  '',
  1986,
  ('2025-06-15 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'b5850bb2-d733-4add-81a5-00206f497455'::uuid,
  '热天午后',
  'Dog Day Afternoon',
  'Sidney Lumet',
  'Sidney Lumet',
  1975,
  ('2025-06-14 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'f73cbb97-d1bd-46f6-87ef-a98b8af0277a'::uuid,
  '惊世狂花',
  'Bound',
  'Wachowski sisters',
  'Wachowski sisters',
  1996,
  ('2025-06-12 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'a43be5ec-3b2c-4852-8a84-9084ff60580f'::uuid,
  '最佳出价',
  'The Best Offer',
  'Giuseppe Tornatore',
  'Giuseppe Tornatore',
  2013,
  ('2025-06-11 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '4946a8a3-43bc-4b76-b18f-c27d055460d8'::uuid,
  '浴室里的鳄鱼',
  'Crocodile',
  'Kaspar Jancis',
  'Kaspar Jancis',
  2009,
  ('2025-06-11 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'db832e76-620d-4129-ba66-58f16fefaef1'::uuid,
  '罗塞塔',
  'Rosetta',
  'Dardenne brothers',
  'Dardenne brothers',
  1999,
  ('2025-05-07 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '16541667-0178-425e-9036-86572617eca8'::uuid,
  '昨日青春',
  'Happyend',
  '空音央',
  '',
  2024,
  ('2025-05-04 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'f5881954-33e4-4d2e-a6d7-788f1babf051'::uuid,
  '笑林小子',
  'Shaolin Popey',
  '朱延平',
  '',
  1994,
  ('2025-05-31 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'ed5146aa-189a-4dde-8a2a-f90dfa8eb433'::uuid,
  '梦旅人',
  'Picnic',
  '岩井俊二',
  '',
  1996,
  ('2025-05-30 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '1bc0f860-6d35-4141-be8e-e1ca1e9ed2e5'::uuid,
  '侠女',
  'A Touch of Zen',
  '胡金铨',
  '',
  1970,
  ('2025-05-03 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'f0bce4f6-3e24-4875-8319-cb4fe4aa8d3a'::uuid,
  '在黑暗的时代',
  'In the Darkness of Time',
  'Jean-Luc Godard',
  'Jean-Luc Godard',
  2002,
  ('2025-05-28 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '5df22a82-06a8-492d-b026-2f92c926186e'::uuid,
  '纳萨林',
  'Nazarín',
  'Luis Buñuel',
  'Luis Buñuel',
  1959,
  ('2025-05-28 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '6cbd0a90-74d2-4087-adcf-f7d179fef2c5'::uuid,
  '我看见了一只美洲狮',
  'I Could See a Puma',
  'Eduardo Williams',
  'Eduardo Williams',
  2011,
  ('2025-05-28 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '6107fc89-c127-4b27-820c-612e46ccbacd'::uuid,
  '神话',
  'Phenomena',
  'Dario Argento',
  'Dario Argento',
  1985,
  ('2025-05-26 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '51cf69f7-c9ce-4ad7-b2ad-ce3ab11bfc6d'::uuid,
  '惊恐小镇',
  'A Town Called Panic',
  'Stéphane Aubier/Vincent Patar',
  'Stéphane Aubier/Vincent Patar',
  2009,
  ('2025-05-26 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '8a436d0e-896e-445e-9073-237fb1ee7d8b'::uuid,
  '在她们眼中',
  'Le Pupille',
  'Alice Rohrwacher',
  'Alice Rohrwacher',
  2022,
  ('2025-05-26 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '71a97843-232e-4ce5-b440-e17eb1904c40'::uuid,
  '都市寓言',
  'An Urban Allegory',
  'Alice Rohrwacher/JR',
  'Alice Rohrwacher/JR',
  2024,
  ('2025-05-26 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '0571a99d-0fd1-44ca-aa28-92472d2d1d4b'::uuid,
  '有一天皮娜问我',
  'One Day Pina Asked...',
  'Chantal Akerman',
  'Chantal Akerman',
  1989,
  ('2025-05-25 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'b993cb30-3443-4dd9-9789-188fc61d1887'::uuid,
  '20世纪的乡愁',
  '20th Century Nostalgia',
  '原将人',
  '',
  1997,
  ('2025-05-24 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'ca9c2ee0-df03-4855-a868-499358be25e2'::uuid,
  '初缠恋后的2人世界',
  'First Love: The Litter on the Breeze',
  '葛民辉',
  '',
  1997,
  ('2025-05-23 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'c3c7bbe6-070f-40c4-81d5-341fb07f50ec'::uuid,
  '观看《他人之痛》',
  'Watching the Pain of Others',
  'Lého Galibert-Laîné',
  'Lého Galibert-Laîné',
  2018,
  ('2025-05-02 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'ac10d5f1-5369-4e94-a2c5-7815dadc5805'::uuid,
  '他他她他他',
  'Gusto Kita With All My Hypothalamus',
  'Dwein Baltazar',
  'Dwein Baltazar',
  2018,
  ('2025-05-16 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'e5b674e2-7c34-43a9-a56a-afa10aa82a6d'::uuid,
  '公园的沙池',
  'Garden Sandbox',
  '黑川幸则',
  '',
  2022,
  ('2025-05-14 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'f65c1ff5-b54d-4b22-9b70-f90fb514510c'::uuid,
  '非家庭电影',
  'No Home Movie',
  'Chantal Akerman',
  'Chantal Akerman',
  2015,
  ('2025-05-10 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '0ca4b110-6ba0-4a76-85b6-016b7af11f97'::uuid,
  '共同的语言',
  'Universal Language',
  'Matthew Rankin',
  'Matthew Rankin',
  2024,
  ('2025-04-26 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '6c256be5-2f66-4812-abec-5ca4b2f4df50'::uuid,
  '木星的初恋',
  'Mukhsin',
  'Yasmin Ahmad',
  'Yasmin Ahmad',
  2006,
  ('2025-04-18 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '129188b2-8a64-4a12-ba19-cac71c6a1e7f'::uuid,
  '我仍在此',
  'I''m Still Here',
  'Walter Salles',
  'Walter Salles',
  2024,
  ('2025-04-11 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'f9bf571e-870b-4acf-b423-f433c126644c'::uuid,
  '绿光',
  'The Green Ray',
  'Éric Rohmer',
  'Éric Rohmer',
  1986,
  ('2025-03-08 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '3053e5db-c17e-462c-a21c-7678ac9d7a0b'::uuid,
  '午后阴影',
  'Afternoon Clouds',
  'Payal Kapadia',
  'Payal Kapadia',
  2017,
  ('2025-03-08 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'e4cfbe66-664d-4fc6-a19a-1a51e19cbfb4'::uuid,
  '竖笛考试',
  'The Recorder Exam',
  '金宝拉',
  '',
  2011,
  ('2025-03-08 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '18a1fae1-2a5f-41ff-ae71-773f0fc5a3e0'::uuid,
  '82年生的金智英',
  'Kim Ji-young: Born 1982',
  '金度英',
  '',
  2019,
  ('2025-03-08 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '53c0a4e4-4d8e-4c6b-894c-41d71e09683f'::uuid,
  '出走的决心',
  'Like A Rolling Stone',
  '尹丽川',
  '',
  2024,
  ('2025-03-07 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '044aa524-cf27-42a6-9c06-7b00bfb06581'::uuid,
  '花火',
  'Fireworks',
  '北野武',
  '',
  1997,
  ('2025-03-30 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'e8dd48ff-59f8-4cda-9c6c-d043a8eea929'::uuid,
  '海上花',
  'Flowers of Shanghai',
  '侯孝贤',
  '',
  1998,
  ('2025-03-29 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '590cf86c-8d7e-4cfe-befd-237e2f100c14'::uuid,
  '女孩终究是女孩',
  'Girls Will Be Girls',
  'Shuchi Talati',
  'Shuchi Talati',
  2024,
  ('2025-03-28 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '1f22354a-6f5f-47bc-b1d9-013a5e45aef3'::uuid,
  '橘色',
  'Tangerine',
  'Sean Baker',
  'Sean Baker',
  2015,
  ('2025-03-22 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'accf9df2-41ed-43f6-a5bc-83a307c266d7'::uuid,
  '工薪女孩',
  'Working Girls',
  'Lizzie Borden',
  'Lizzie Borden',
  1986,
  ('2025-03-21 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '5e98ca69-36da-44d6-a3fa-a479e8641a94'::uuid,
  '我想聊聊杜拉斯',
  'I Want to Talk About Duras',
  'Claire Simon',
  'Claire Simon',
  2021,
  ('2025-03-02 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '5ce42e33-6c8f-44ad-a150-522748b352e7'::uuid,
  '默文·卡拉',
  'Morvern Callar',
  'Lynne Ramsay',
  'Lynne Ramsay',
  2002,
  ('2025-03-15 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '7dc18fd3-1e91-48e6-bf42-aee0dcb64631'::uuid,
  '德国姊妹',
  'Marianne and Juliane',
  'Margarethe von Trotta',
  'Margarethe von Trotta',
  1981,
  ('2025-03-14 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'f5b25c85-ab8e-44a9-aa0b-d59b91ba49b1'::uuid,
  '秘密与谎言',
  'Secrets & Lies',
  'Mike Leigh',
  'Mike Leigh',
  1996,
  ('2025-02-08 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'c316121b-3863-47d8-acea-8c2a83404aa4'::uuid,
  '密阳',
  'Secret Sunshine',
  '李沧东',
  '',
  2007,
  ('2025-02-07 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'ba72527a-3a97-47e7-95de-20d05d42ddd0'::uuid,
  '鱼缸',
  'Fish Tank',
  'Andrea Arnold',
  'Andrea Arnold',
  2009,
  ('2025-02-28 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'ef2cface-9dbc-4498-a0d5-36d819ae73d4'::uuid,
  '盗信情缘',
  'Postman Blues',
  '萨布',
  '',
  1997,
  ('2025-02-23 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '5e0f581f-de9a-4c2d-94e0-63f892f8ea1e'::uuid,
  '豆芽',
  'Sprout',
  '尹佳恩',
  '',
  2013,
  ('2025-02-23 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'b1cd9670-ae2f-4ff8-bee3-ad154966d01e'::uuid,
  '大只佬',
  'Running on Karma',
  '杜琪峰/韦家辉',
  '',
  2003,
  ('2025-02-16 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'd3502b14-731c-4066-8211-4037b7eb361e'::uuid,
  '柏蒂娜的苦泪',
  'The Bitter Tears of Petra von Kant',
  'Rainer Werner Fassbinder',
  'Rainer Werner Fassbinder',
  1972,
  ('2025-02-14 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '35b45895-b9ee-46cd-a150-acdae0bc3184'::uuid,
  '爱在别乡的季节',
  'Farewell China',
  '罗卓瑶/方令正',
  '',
  1990,
  ('2025-12-05 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'be622b47-595a-4ab7-81cb-7ac565744598'::uuid,
  '主要音调',
  'The Major Tones',
  'Ingrid Pokropek',
  'Ingrid Pokropek',
  2023,
  ('2025-12-04 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '46bc7c72-911a-4aa4-b3b0-8e50d18564c6'::uuid,
  '妙想天开',
  'Brazil',
  'Terry Gilliam',
  'Terry Gilliam',
  1985,
  ('2025-12-27 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'acc6a50b-c6a7-47dd-a0f4-1dbdc2a23bc1'::uuid,
  '桃色公寓',
  'The Apartment',
  'Billy Wilder',
  'Billy Wilder',
  1960,
  ('2025-12-27 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'a6e8e895-0e35-4521-91b2-edd584476920'::uuid,
  '流砂幻爱',
  'Like Grains of Sand',
  '桥口亮辅',
  '',
  1995,
  ('2025-12-27 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '1b1da355-db66-4892-9b2e-fa4fd9fc1f50'::uuid,
  '潘金莲之前世今生',
  'The Reincarnation of Golden Lotus',
  '罗卓瑶/李碧华',
  '',
  1989,
  ('2025-12-26 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'a3462cc6-58ef-4f4e-9537-9ef859fb22f2'::uuid,
  '迷雾中的小刺猬',
  'Hedgehog in the Fog',
  'Yuriy Norshteyn/Sergei Kozlov',
  'Yuriy Norshteyn/Sergei Kozlov',
  1975,
  ('2025-12-24 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'ed0664a3-68ee-4730-b353-3119fefba080'::uuid,
  '电子管',
  'The Tube with a Hat',
  'Radu Jude',
  'Radu Jude',
  2007,
  ('2025-12-24 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'efd8970d-eb14-4d9c-a385-b1f9b931b0bc'::uuid,
  '捷克惊魂夜',
  'One Night in One City',
  'Jan Balej',
  'Jan Balej',
  2007,
  ('2025-12-24 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'f2eea136-765e-45bc-a22f-391f973839ad'::uuid,
  '积少成多',
  'Little by Little',
  'Jean Rouch',
  'Jean Rouch',
  1970,
  ('2025-12-21 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '5ebd3132-bbc4-42f7-8438-aee804ef8013'::uuid,
  '千面珍宝金',
  'Jane B. by Agnès V.',
  'Agnès Varda',
  'Agnès Varda',
  1988,
  ('2025-12-21 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '928dbf16-541e-4608-abaa-bc72c9859daa'::uuid,
  '普通事故',
  'It Was Just an Accident',
  'Jafar Panahi',
  'Jafar Panahi',
  2025,
  ('2025-12-20 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'c35fdd00-43de-4e97-a721-8dce844fa03e'::uuid,
  'The Invention of the Other',
  'The Invention of the Other',
  'Bruno Jorge',
  'Bruno Jorge',
  2022,
  ('2025-12-19 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '9423d42c-dc53-4b0c-a3d1-24cce33229e1'::uuid,
  '且唱且珍惜',
  'The Klezmer Project',
  'Leandro Koch/Paloma Schachmann',
  'Leandro Koch/Paloma Schachmann',
  2023,
  ('2025-12-11 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'ff8c0388-06df-43da-b45c-1ffdf5e8653b'::uuid,
  '秋天的童话',
  'An Autumn''s Tale',
  '张婉婷/罗启锐',
  '',
  1987,
  ('2025-12-10 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'd4e4a445-f59e-4082-b609-203b9e35c7d7'::uuid,
  '茶之味',
  'The Taste of Tea',
  '石井克人',
  '',
  2004,
  ('2025-11-28 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'be1bd2b9-5035-4fa2-9fb4-16a693867994'::uuid,
  '诱僧',
  'Temptation of a Monk',
  '罗卓瑶/方令正/李碧华',
  '',
  1993,
  ('2025-11-26 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '093e57c5-97cb-4124-a446-879c07b170fc'::uuid,
  '夕阳天使',
  'So Close',
  '元奎/刘镇伟',
  '',
  2002,
  ('2025-11-26 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '0cf0aab1-0ebf-4e70-8ec2-0f5c06a56251'::uuid,
  '外星奇遇',
  'Kin-dza-dza!',
  'Georgi Daneliya',
  'Georgi Daneliya',
  1986,
  ('2025-11-21 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '4cf41a6b-a8d4-47b9-864e-fbed42fd0e05'::uuid,
  '不要太期待世界末日',
  'Do Not Expect Too Much from the End of the World',
  'Radu Jude',
  'Radu Jude',
  2023,
  ('2025-11-17 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '9115e955-fce3-4c87-af16-592a0822f272'::uuid,
  '季风婚宴',
  'Monsoon Wedding',
  'Mira Nair/Sabrina Dhawan',
  'Mira Nair/Sabrina Dhawan',
  2001,
  ('2025-11-16 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '3d2e82ba-945f-4dc7-ba05-6471a5af71aa'::uuid,
  '事情原来是这样的……',
  'What Happened Was...',
  'Tom Noonan',
  'Tom Noonan',
  1994,
  ('2025-11-15 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'b9f0a9db-edd4-4f34-bae0-1c3ff132d218'::uuid,
  '非快速眼动之窗',
  'ノンレムの窓 2022・秋',
  '笨蛋节奏等',
  '',
  2022,
  ('2025-11-15 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '32e16e36-7e3b-4411-9d4f-32e1aed70a11'::uuid,
  '爱情与无政府',
  'Love and Anarchy',
  'Lina Wertmüller',
  'Lina Wertmüller',
  1973,
  ('2025-01-31 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'b95978bf-3a61-4a91-b76c-c42c9ff6d8e4'::uuid,
  '爱情来了',
  'Love Go Go',
  '陈玉勋',
  '',
  1998,
  ('2025-01-28 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '9ef00bca-4bb7-4b0f-9002-f68270ad955d'::uuid,
  '豆满江',
  'Dooman River',
  '张律',
  '',
  2010,
  ('2025-01-25 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'fc1da911-55a3-4291-a7ab-0a250fc2ccdc'::uuid,
  '红颜',
  'Dam Street',
  '李玉',
  '',
  2005,
  ('2025-01-24 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'f86b5912-0d30-4584-aec8-8165f8c76e04'::uuid,
  '姐姐',
  'Older Sister',
  '李玉',
  '',
  1996,
  ('2025-01-24 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '692b2a9e-bb6a-43d3-8251-5eaa6bedca78'::uuid,
  'Łukasz i Lotta',
  'Łukasz i Lotta',
  'Renata Gąsiorowska',
  'Renata Gąsiorowska',
  2012,
  ('2025-01-18 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '42b519e0-8964-43cc-a46f-f19aa9ab7b43'::uuid,
  '涩谷24小时',
  'Bounce Ko Gals',
  '原田真人',
  '',
  1997,
  ('2025-01-18 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '2d3ee02c-0857-4356-98f3-afaf1ab50e1a'::uuid,
  '陌生人为伴',
  'The Company of Strangers',
  'Cynthia Scott',
  'Cynthia Scott',
  1990,
  ('2025-01-17 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '44bd073a-c33d-4585-b6aa-b465da99d083'::uuid,
  '绿色唱片',
  'Green Vinyl',
  'Kleber Mendonça Filho',
  'Kleber Mendonça Filho',
  2004,
  ('2024-09-08 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '6aef6e94-0e8c-4092-b339-f8466315bce3'::uuid,
  '帕乌利什塔的手',
  'The Hand of Paulișta',
  'Cristian Mungiu',
  'Cristian Mungiu',
  1998,
  ('2024-09-08 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'dbc839f5-ebb4-4243-870f-3a09d562f963'::uuid,
  '身体记着世间何时崩裂',
  'The Body Remembers When the World Broke Open',
  'Kathleen Hepburn/Elle-Máijá Tailfeathers',
  'Kathleen Hepburn/Elle-Máijá Tailfeathers',
  2019,
  ('2024-09-08 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'cfab3a54-494c-4fb7-a0fa-df592fcf07e2'::uuid,
  'X圣治',
  'Cure',
  '黑泽清',
  '',
  1997,
  ('2024-09-08 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '377acfbe-dd68-47de-937e-939de9b727d2'::uuid,
  '天涯沦落女',
  'Vagabond',
  'Agnès Varda',
  'Agnès Varda',
  1985,
  ('2024-09-29 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '0a0358e9-5b17-4eaa-82cd-9c763e9cc8f1'::uuid,
  '鬼怪屋',
  'House',
  '大林宣彦',
  '',
  1977,
  ('2024-09-27 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'faabb984-e3b8-4533-b815-0de935190888'::uuid,
  '修罗雪姬',
  'Lady Snowblood',
  '藤田敏八/小池一夫',
  '',
  1973,
  ('2024-09-22 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '92763b0c-3431-40dc-a029-972363f3ed00'::uuid,
  '被嫌弃的松子的一生',
  'Memories of Matsuko',
  '中岛哲也',
  '',
  2006,
  ('2024-09-22 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '552ed5de-3fc1-4e7b-a4be-c20ff4ab92d8'::uuid,
  '花与爱丽丝',
  'Hana & Alice',
  '岩井俊二',
  '',
  2004,
  ('2024-09-02 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'd543b4b3-1401-435d-b441-f6df561d650d'::uuid,
  '独自生活的人们',
  'Aloners',
  '洪性恩',
  '',
  2021,
  ('2024-09-15 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'c9be1413-38c4-4360-901d-aea40a21cff7'::uuid,
  '青春祭',
  'Sacrificed Youth',
  '张暖忻',
  '',
  1985,
  ('2024-09-14 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '063217e6-2797-49cc-8899-a302b7a0dc3d'::uuid,
  'Contretemps',
  'Contretemps',
  'Various Artists',
  'Various Artists',
  2021,
  ('2024-09-13 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'aadbd1ba-662b-4488-95d3-8784d161ab5e'::uuid,
  'Pussy (Cipka)',
  'Pussy',
  'Renata Gąsiorowska',
  'Renata Gąsiorowska',
  2016,
  ('2024-09-13 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'a986b4d4-7e22-4b23-984a-e3e24cdca963'::uuid,
  '怪谈',
  'Kwaidan',
  '小林正树/小泉八云',
  '',
  1964,
  ('2024-09-13 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '2e0edf71-8af0-45d1-a943-6763b836245e'::uuid,
  '欢乐街',
  'Joy Street',
  'Suzan Pitt',
  'Suzan Pitt',
  1995,
  ('2024-09-01 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'e0fec7b9-fa0a-432d-8622-1dda7b784dc9'::uuid,
  '芦笋',
  'Asparagus',
  'Suzan Pitt',
  'Suzan Pitt',
  1979,
  ('2024-09-01 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '1e05d168-d2fb-42dd-9cab-e6ec61148b69'::uuid,
  '硝烟中诞生',
  'Born in Flames',
  'Lizzie Borden',
  'Lizzie Borden',
  1983,
  ('2024-09-01 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '395be526-ddbe-43dd-90fd-254b5e5411aa'::uuid,
  '东京金盏花',
  'Tokyo Marigold',
  '市川准',
  '',
  2001,
  ('2024-08-31 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'be8ed76f-a853-402e-9cdb-f73e6de27411'::uuid,
  '自梳',
  'Intimates',
  '张之亮/小唐',
  '',
  1997,
  ('2024-08-29 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'e1467fbb-55d6-44ca-ad5f-10c9a7317c74'::uuid,
  '爱与时尚',
  'Love & Pop',
  '庵野秀明',
  '',
  1998,
  ('2024-08-28 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '107292c5-b200-4df3-8604-cae81290eb2c'::uuid,
  '妓院里的回忆',
  'House of Tolerance',
  'Bertrand Bonello',
  'Bertrand Bonello',
  2011,
  ('2024-08-25 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '04280a40-a9a5-4efa-8ce3-fd52ea1f3c56'::uuid,
  '人鱼传说',
  'Mermaid Legend',
  '池田敏春',
  '',
  1984,
  ('2024-08-22 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'fc011e29-03bf-43f3-bee5-5f72db9cd6bd'::uuid,
  '三女性',
  '3 Women',
  'Robert Altman',
  'Robert Altman',
  1977,
  ('2024-08-21 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '6cecb6bb-ec1d-44a2-9e96-030d79a55ae7'::uuid,
  '夏日感悟',
  'This Summer Feeling',
  'Mikhaël Hers',
  'Mikhaël Hers',
  2015,
  ('2024-08-20 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '009b4f0e-c2e1-470c-96b2-957ef8840e3a'::uuid,
  '巴黎夜旅人',
  'The Passengers of the Night',
  'Mikhaël Hers',
  'Mikhaël Hers',
  2022,
  ('2024-08-17 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '0a679a70-28fc-4d25-82e4-6c346a046952'::uuid,
  '丛林怪兽',
  'Macunaima',
  'Joaquim Pedro de Andrade',
  'Joaquim Pedro de Andrade',
  1969,
  ('2024-08-10 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'c3956cfa-6fd6-43d1-a011-1828e3c0db4e'::uuid,
  '唐皇游地府',
  'Emperor Visits the Hell',
  '李珞',
  '',
  2012,
  ('2024-07-07 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '0d00baa8-dbed-4f44-8e73-d25e36d087bb'::uuid,
  '清洁',
  'Clean',
  'Olivier Assayas',
  'Olivier Assayas',
  2004,
  ('2024-07-07 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '641f4d01-b67b-4525-b7fd-d72f848fc788'::uuid,
  '贫穷的吸血鬼',
  'The Vampires of Poverty',
  'Carlos Mayolo/Luis Ospina',
  'Carlos Mayolo/Luis Ospina',
  1978,
  ('2024-07-28 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'ddc3a32c-9fec-41e7-a79f-53e4081e4302'::uuid,
  '我的狗狗王子',
  'Love on a Leash',
  '田芬',
  '',
  2011,
  ('2024-07-27 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '9a8e1de7-fbc0-4c19-9fd3-59f05d4d41fd'::uuid,
  'My house walk-through',
  'My House Walk-Through',
  'PiroPito（nana825763）',
  'PiroPito（nana825763）',
  2016,
  ('2024-07-27 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'b67b79dd-29c0-406c-9d71-14009cbb9d9f'::uuid,
  '放大',
  'Blow-Up',
  'Michelangelo Antonioni',
  'Michelangelo Antonioni',
  1966,
  ('2024-07-25 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '9e43b706-97bd-4a90-a02e-5cd9951f2550'::uuid,
  '琳达！琳达！琳达！',
  'Linda Linda Linda',
  '山下敦弘',
  '',
  2005,
  ('2024-07-21 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '464f51c6-af92-4750-8de1-ecdf3951a6af'::uuid,
  '李文漫游东湖',
  'Li Wen at East Lake',
  '李珞',
  '',
  2015,
  ('2024-07-21 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'a23e9e29-ebbd-499e-990c-ecf04c7caf0d'::uuid,
  '交通意外',
  'Trafic',
  'Jacques Tati',
  'Jacques Tati',
  1971,
  ('2024-07-11 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '6aa9182a-d6e2-4d15-9de1-8a5b4632d7a3'::uuid,
  '杀手烙印',
  'Branded to Kill',
  '铃木清顺',
  '',
  1967,
  ('2024-07-11 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'b67b5a7c-b9d2-4e1a-94f5-2af95d78a644'::uuid,
  '钟声',
  'Chime',
  '黑泽清',
  '',
  2024,
  ('2024-07-11 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '551776f5-2c47-4b72-8d9e-c01d9ddad5f0'::uuid,
  '还有明天',
  'There''s Still Tomorrow',
  'Paola Cortellesi',
  'Paola Cortellesi',
  2023,
  ('2024-06-09 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '0dd885ec-5cba-439d-a21d-4e8a3b3a93de'::uuid,
  '金甲虫',
  'The Gold Bug',
  'Alejo Moguillansky/Mariano Llinás',
  'Alejo Moguillansky/Mariano Llinás',
  2014,
  ('2024-06-04 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'a888a3f1-eaac-4908-acfb-c963798ad8bb'::uuid,
  '哈哈笑',
  'Funny Ha Ha',
  'Andrew Bujalski',
  'Andrew Bujalski',
  2002,
  ('2024-06-29 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '6a8b9f89-df26-4a94-b23c-0ce61d2bc792'::uuid,
  '猫样少女',
  'Take Care of My Cat',
  '郑在恩',
  '',
  2001,
  ('2024-06-29 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'c12997f9-0d7e-429e-9be0-020d45b54910'::uuid,
  '八美图',
  '8 Women',
  'François Ozon',
  'François Ozon',
  2002,
  ('2024-06-27 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '067ecbaa-013e-4746-9c96-89e0b591080b'::uuid,
  '投奔怒海',
  'Boat People',
  '许鞍华/邱刚健',
  '',
  1982,
  ('2024-06-23 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'f27c94e0-67d2-47ff-967f-68e16ed58ce2'::uuid,
  '黑暗',
  'Tenebre',
  'Dario Argento',
  'Dario Argento',
  1982,
  ('2024-06-02 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'd6aa0751-f9ed-49b5-b1b4-1f9971b345ec'::uuid,
  '寻找西瓜女',
  'The Watermelon Woman',
  'Cheryl Dunye',
  'Cheryl Dunye',
  1996,
  ('2024-06-19 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'cefe98c8-c96b-4cb1-a55a-fadda7c1e796'::uuid,
  '女朋友',
  'Girlfriends',
  'Claudia Weill',
  'Claudia Weill',
  1978,
  ('2024-06-16 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '69bd552d-4fc5-4723-90fd-f7b2a1f61c6a'::uuid,
  '战争花园',
  'Garden of War',
  'Neville de Almeida',
  'Neville de Almeida',
  1969,
  ('2024-05-04 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'e15c67ad-004e-484e-9c2b-b4f1ebc2b92d'::uuid,
  '甜蜜的东方',
  'The Sweet East',
  'Sean Price Williams',
  'Sean Price Williams',
  2023,
  ('2024-05-28 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '61d1d8fe-febc-48db-a5a6-dea3b2369a23'::uuid,
  '火之谜',
  'Riddle of Fire',
  'Weston Razooli',
  'Weston Razooli',
  2023,
  ('2024-05-26 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '35a79536-ccce-471d-8dc4-9a8fb7eeb0cf'::uuid,
  '悲情城市',
  'A City of Sadness',
  '侯孝贤',
  '',
  1989,
  ('2024-05-18 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '6a662084-0a56-4794-9a45-8d7b867a66b5'::uuid,
  '我们天上见',
  'We''ll Meet in Heaven',
  '蒋雯丽',
  '',
  2009,
  ('2024-05-10 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'ab1d1b05-ad52-4a1c-adfd-997dae687705'::uuid,
  '安东尼娅家族',
  'Antonia''s Line',
  'Marleen Gorris',
  'Marleen Gorris',
  1995,
  ('2024-04-07 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '46012b92-622b-4b46-b15a-7fda09d97789'::uuid,
  '草迷宫',
  'Grass Labyrinth',
  '寺山修司',
  '',
  1979,
  ('2024-04-06 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'fb438927-acde-4157-ba70-177c72afe377'::uuid,
  '女囚701号-蝎子',
  'Female Prisoner #701: Scorpion',
  '伊藤俊也/篠原とおる',
  '',
  1972,
  ('2024-04-06 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'e7d315b7-ab45-49be-9eae-ce5e0938f7c6'::uuid,
  '天国还很遥远',
  'Heaven Is Still Far Away',
  '滨口龙介',
  '',
  2016,
  ('2024-04-29 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '37cba50d-d4a9-4a21-a178-6f05b0925e67'::uuid,
  '巴黎浮世绘',
  'Code Unknown',
  'Michael Haneke',
  'Michael Haneke',
  2000,
  ('2024-04-20 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'de55a1e6-19fc-4958-9e7f-0b8ad7b7d62f'::uuid,
  '赤裸童年',
  'Naked Childhood',
  'Maurice Pialat',
  'Maurice Pialat',
  1968,
  ('2024-04-20 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'd121d27b-d437-4729-8bb0-d34b7109cad1'::uuid,
  '蔷薇的葬礼',
  'Funeral Parade of Roses',
  '松本俊夫',
  '',
  1969,
  ('2024-04-12 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '64bd7951-d601-4320-b550-45f141dcdc78'::uuid,
  '东方三侠',
  'The Heroic Trio',
  '杜琪峰/邵丽琼',
  '',
  1993,
  ('2024-04-12 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'd6f92c07-03bb-4821-a7ae-12b515a5b28d'::uuid,
  '漫画家之路',
  'Forklift Driver Klaus: The First Day on the Job',
  'Tom Green',
  'Tom Green',
  2001,
  ('2024-03-08 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'fbb989cd-ac9b-4654-b4fd-53f1df2d368f'::uuid,
  '铲车司机克劳斯—第一个工作日',
  'Freddy Got Fingered',
  'Stefan Prehn/Jörg Wagner',
  'Stefan Prehn/Jörg Wagner',
  2000,
  ('2024-03-08 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'df6f3866-20c1-444c-b8cb-f7c876b82d89'::uuid,
  '顺流逆流',
  'Time and Tide',
  '徐克',
  '',
  2000,
  ('2024-03-31 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'fb5d47e1-c0b3-4ee7-b8f3-224c0c860e85'::uuid,
  '机器人之梦',
  'Robot Dreams',
  'Pablo Berger',
  'Pablo Berger',
  2023,
  ('2024-03-29 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '878bd254-5361-4e45-ae21-4eb59c8d1eb5'::uuid,
  '女伶们',
  'The Girls',
  'Mai Zetterling',
  'Mai Zetterling',
  1968,
  ('2024-03-28 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '8f310b77-1e0a-438d-b47c-ef63d35f2a92'::uuid,
  '潘神的迷宫',
  'Pan''s Labyrinth',
  'Guillermo del Toro',
  'Guillermo del Toro',
  2006,
  ('2024-03-23 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'aa9a4984-11b6-441d-ae10-a90040d03f38'::uuid,
  '梁祝',
  'The Lovers',
  '徐克',
  '',
  1994,
  ('2024-03-02 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'f951acd8-f9ec-429c-9004-3c02b2f19f76'::uuid,
  '野玫瑰之恋',
  'The Wild, Wild Rose',
  '王天林/秦羽',
  '',
  1960,
  ('2024-03-02 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '3f9da05b-4c5c-47f9-aa2d-abc99685c2f5'::uuid,
  '四月三周两天',
  '4 Months, 3 Weeks and 2 Days',
  'Cristian Mungiu',
  'Cristian Mungiu',
  2007,
  ('2024-03-02 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '9b53fb86-d243-49c2-a53e-baa8406587b6'::uuid,
  '特沃塔和我',
  'Travolta and Me',
  'Patricia Mazuy',
  'Patricia Mazuy',
  1993,
  ('2024-03-17 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'bed4d262-e18f-44fb-ab76-5688654117da'::uuid,
  '活死人之夜',
  'Night of the Living Dead',
  'George A. Romero',
  'George A. Romero',
  1968,
  ('2024-02-02 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '56a7fb2d-7824-45a6-bc9c-02dc5ce9d34a'::uuid,
  '东黑斯廷斯药房',
  'East Hastings Pharmacy',
  'Antoine Bourges',
  'Antoine Bourges',
  2012,
  ('2024-02-14 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '6e803456-370a-4c0a-a2e3-370496e5b56a'::uuid,
  '恐怖歌剧',
  'Opera',
  'Dario Argento',
  'Dario Argento',
  1987,
  ('2024-02-14 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'a3d37723-c05f-417c-b65d-849f0c7f7dfc'::uuid,
  '一个唱，一个不唱',
  'One Sings, the Other Doesn''t',
  'Agnès Varda',
  'Agnès Varda',
  1977,
  ('2024-02-01 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '21863c24-419c-4282-828f-fb61e9abbb65'::uuid,
  '三粒粗盐',
  'Three Grains of Coarse Salt',
  'Ingrid Chikhaoui',
  'Ingrid Chikhaoui',
  2022,
  ('2024-12-06 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'a7374260-4a9e-406d-afd2-01a0386328fa'::uuid,
  '爱',
  'Amour',
  'Michael Haneke',
  'Michael Haneke',
  2012,
  ('2024-12-06 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'd3faaafb-98d9-4238-83b1-29fda493a1b2'::uuid,
  '黄蜂',
  'Wasp',
  'Andrea Arnold',
  'Andrea Arnold',
  2003,
  ('2024-12-29 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'e0d59112-2730-4f8c-a92d-42972ec91857'::uuid,
  '鱼的故事',
  'Fish Story',
  '中村义洋/伊坂幸太郎',
  '',
  2009,
  ('2024-12-29 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'ce3093ba-d5ee-46b1-9f99-3c346444635f'::uuid,
  '猫皮',
  'Cat Skin',
  'Joaquim Pedro de Andrade',
  'Joaquim Pedro de Andrade',
  1962,
  ('2024-12-27 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '1c0a3764-c5b8-4efa-a93b-3016c4f8cee8'::uuid,
  '小奏鸣曲',
  'Sonatine',
  'Micheline Lanctôt',
  'Micheline Lanctôt',
  1984,
  ('2024-12-27 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '02629f49-1e18-49fb-af3e-aa91a58415b1'::uuid,
  '逃家',
  'Taking Off',
  'Miloš Forman',
  'Miloš Forman',
  1971,
  ('2024-12-20 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '5c15a248-3f2c-4429-b512-edab6bb91670'::uuid,
  '鬼汤',
  'Ghost Soup',
  '岩井俊二',
  '',
  1995,
  ('2024-12-01 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'f9466f31-6506-4b86-8ac9-521b013883a6'::uuid,
  '烟花',
  'Fireworks, Should We See It from the Side or the Bottom?',
  '岩井俊二',
  '',
  1995,
  ('2024-12-01 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'ed1a71b6-469c-47f9-a774-304300367c16'::uuid,
  '蓦然回首',
  'Look Back',
  '押山清高',
  '',
  2024,
  ('2024-12-01 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'b0087621-e37c-4b68-ac58-fae201d9e04e'::uuid,
  '肮脏的爱情',
  'Troubling Love',
  'Mario Martone/Elena Ferrante',
  'Mario Martone/Elena Ferrante',
  1995,
  ('2024-11-08 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '9f66ec47-1751-4bb8-a0c3-da505f31c22c'::uuid,
  '再见，杰罗姆！',
  'Goodbye Jerome!',
  'Chloé Farr/Adam Sillard/Gabrielle Selnet',
  'Chloé Farr/Adam Sillard/Gabrielle Selnet',
  2022,
  ('2024-11-03 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '20d81956-78c1-4950-ab31-969b150601c8'::uuid,
  '花与爱丽丝杀人事件',
  'The Case of Hana & Alice',
  '岩井俊二',
  '',
  2015,
  ('2024-11-03 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'cfbd838d-7ced-4451-ab38-ba1c4ed9d269'::uuid,
  '传说在下午,有时会遇到吸血鬼',
  'Emotion',
  '大林宣彦',
  '',
  1966,
  ('2024-11-29 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '2fa375ee-e2bd-41b6-b33e-fbcc33a8c0ef'::uuid,
  '为吾子寄信吾母',
  'Letter to My Mother for My Son',
  'Carla Simón',
  'Carla Simón',
  2022,
  ('2024-11-29 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '2c0273fb-639b-41f7-909b-03688ddb95fe'::uuid,
  '下妻物语',
  'Kamikaze Girls',
  '中岛哲也',
  '',
  2004,
  ('2024-11-29 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '4cd4253b-34ab-4a31-82db-0a030782f045'::uuid,
  '美国甜心',
  'American Honey',
  'Andrea Arnold',
  'Andrea Arnold',
  2016,
  ('2024-11-23 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'f60742d6-9f9d-44e9-ac73-de93b63b40ef'::uuid,
  '电话谋杀案',
  'Dial M for Murder',
  'Alfred Hitchcock',
  'Alfred Hitchcock',
  1954,
  ('2024-11-23 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '3b2b14de-723c-4f3d-84ed-4b6e6fc32692'::uuid,
  '太阳狗',
  'Sun Dog',
  'Dorian Jespers',
  'Dorian Jespers',
  2019,
  ('2024-11-22 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'e8462d86-192c-47c9-836c-3af1348d7dea'::uuid,
  '夜幕降临上海',
  'Nightfall in Shanghai',
  'Chantal Akerman',
  'Chantal Akerman',
  2007,
  ('2024-11-22 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'd6dc9738-2488-4961-a90b-cc5a05eec2d8'::uuid,
  '秘密花园',
  'My Secret Cache',
  '矢口史靖',
  '',
  1997,
  ('2024-11-22 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '8388fca0-0aa8-4f3b-ad52-d179c4795fe1'::uuid,
  'Examen d’entrée INSAS',
  'Examen d''entrée INSAS',
  'Chantal Akerman',
  'Chantal Akerman',
  1967,
  ('2024-11-22 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '2f2997c0-9ec7-49c0-b9db-17ce4abb6d14'::uuid,
  '怠惰女子的肖像',
  'Portrait of a Lazy Woman',
  'Chantal Akerman',
  'Chantal Akerman',
  1986,
  ('2024-11-22 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'c7b9d597-8b4c-4ba2-a9fd-74f24b7e41a0'::uuid,
  '噪音如是说',
  'Thus a Noise Speaks',
  '小田香',
  '',
  2010,
  ('2024-11-22 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '9a84f614-3145-4964-b8c0-dce8e724d83e'::uuid,
  '入侵',
  'Invasion',
  'Hugo Santiago',
  'Hugo Santiago',
  1969,
  ('2024-11-16 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '37fb8cb1-85fe-4a5c-99d2-de5dd7921353'::uuid,
  '东京家族',
  'Tokyo Family',
  '山田洋次',
  '',
  2013,
  ('2024-11-15 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '4fd727a3-229d-47c6-aaf2-1101bdcfbc9f'::uuid,
  '观影室',
  'The Viewing Booth',
  'Ra''anan Alexandrowicz',
  'Ra''anan Alexandrowicz',
  2020,
  ('2024-10-08 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'efe3c0f2-558d-4698-b413-f70f7abb20fb'::uuid,
  '你妈妈也一样',
  'Y Tu Mamá También',
  'Alfonso Cuarón',
  'Alfonso Cuarón',
  2001,
  ('2024-10-06 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '9ff02517-adcb-4c6a-aa1a-cdbc6a0138dd'::uuid,
  '热带鱼',
  'Tropical Fish',
  '陈玉勋',
  '',
  1995,
  ('2024-10-25 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '1ad53189-c838-4009-b73a-529ed9b57525'::uuid,
  '最后大浪',
  'The Last Wave',
  'Peter Weir',
  'Peter Weir',
  1977,
  ('2024-10-20 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '7e769801-205c-4d17-adc8-851f9a62c970'::uuid,
  '然后我们跳了舞',
  'And Then We Danced',
  'Levan Akin',
  'Levan Akin',
  1996,
  ('2024-10-18 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '286abd21-485c-47e9-b6bb-08059f2d02cd'::uuid,
  '国王的电影',
  'A King and His Movie',
  'Carlos Sorín',
  'Carlos Sorín',
  1986,
  ('2024-10-13 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '81e6c47c-ad17-4653-a57f-2450d5a607f6'::uuid,
  '人·鬼·情',
  'Woman Demon Human',
  '黄蜀芹',
  '',
  1987,
  ('2024-10-11 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '46d9a0df-1ef7-495d-b3d9-a3155b5047ad'::uuid,
  '饲养乌鸦',
  'Cria!',
  'Carlos Saura',
  'Carlos Saura',
  1976,
  ('2024-01-03 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'ee6093f1-6504-4bfe-932a-dd2d51a3559f'::uuid,
  '崩溃边缘的女人',
  'Women on the Verge of a Nervous Breakdown',
  'Pedro Almodóvar',
  'Pedro Almodóvar',
  1988,
  ('2024-01-26 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'c0971881-7d54-46c2-99e1-41f016bf0482'::uuid,
  '银河铁道之夜',
  'Night on the Galactic Railroad',
  '杉井仪三郎/宫泽贤治',
  '',
  1985,
  ('2024-01-26 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '6693bd6b-bb42-473a-9a5a-4b3dfba84833'::uuid,
  '他的摩托，她的岛',
  'His Motorbike, Her Island',
  '大林宣彦',
  '',
  1986,
  ('2024-01-21 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '7fbc5156-51ba-4caf-bd3f-34f8d7dc7cac'::uuid,
  '青蛇',
  'Green Snake',
  '徐克',
  '',
  1993,
  ('2024-01-20 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '2e8d7b10-08b6-4de8-8689-efec48a8de08'::uuid,
  '刀马旦',
  'Peking Opera Blues',
  '徐克',
  '',
  1986,
  ('2024-01-20 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '21f8714d-dad5-4a9e-956c-f8ef8c535eba'::uuid,
  '致胜法门',
  'Theory of Achievement',
  'Hal Hartley',
  'Hal Hartley',
  1991,
  ('2024-01-20 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '909f7382-52d2-4ef7-b001-e5973cc78248'::uuid,
  '快盗鲁比',
  'Kaito Ruby',
  '和田诚',
  '',
  1988,
  ('2024-01-20 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '4ce62dbe-01bc-487f-bf66-d059f5fad81e'::uuid,
  '梦幻银河',
  'Labyrinth of Dreams',
  '石井岳龙',
  '',
  1997,
  ('2024-01-01 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'a09f3890-51f5-4fea-95da-918a54872888'::uuid,
  '对不起，我们错过了你',
  'Sorry We Missed You',
  'Ken Loach/Paul Laverty',
  'Ken Loach/Paul Laverty',
  2019,
  ('2024-01-01 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '269d2a68-4a9f-4143-ba8e-380d6a413707'::uuid,
  '迷雾中的她（上）',
  '',
  'Laura Citarella',
  'Laura Citarella',
  2022,
  ('2023-09-24 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '2c63bf58-5cb1-435c-824f-e6fcbe3e54d0'::uuid,
  '惠子，凝视',
  'Small, Slow But Steady',
  '三宅唱',
  '',
  2022,
  ('2023-08-28 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'd3c3fc4f-2dac-4c33-bf83-a40389ec536b'::uuid,
  '水中八月',
  'August in the Water',
  '石井岳龙',
  '',
  1995,
  ('2023-08-13 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '0aa7d419-f4ea-42a6-b16a-25bf0181fb4a'::uuid,
  '脑髓地狱',
  'Dogra Magra',
  '松本俊夫',
  '',
  1988,
  ('2023-12-28 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '527bd499-bc11-44b7-8ed2-77b0f17791e6'::uuid,
  '史楚锡流浪记',
  'Stroszek',
  'Werner Herzog',
  'Werner Herzog',
  1977,
  ('2023-12-23 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'b818e3a8-4b5c-43a7-9abf-6c2e2741afd1'::uuid,
  '冰血暴',
  'Fargo',
  'Coen brothers',
  'Coen brothers',
  1996,
  ('2023-12-10 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  '25831875-574f-4be7-b630-092a009ab1dd'::uuid,
  '夏天 Лето',
  'Summer',
  'Vadim Kostrov',
  'Vadim Kostrov',
  2021,
  ('2023-11-07 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'ea4e55c5-24be-47f0-b24b-6e1fcba40e16'::uuid,
  '神呀神！你为何离弃我？',
  'My God, My God, Why Hast Thou Forsaken Me?',
  '青山真治',
  '',
  2005,
  ('2023-11-21 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'bfff74e6-eebd-438b-9bf2-79cd41a4f270'::uuid,
  '鲜杀',
  'Fresh Kill',
  'Shu Lea Cheang/Jessica Hagedorn',
  'Shu Lea Cheang/Jessica Hagedorn',
  1994,
  ('2023-11-19 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
),
(
  'ce2b0cd2-c27d-46a8-873e-661c1d9ec8cf'::uuid,
  '式日',
  'Ritual',
  '庵野秀明',
  '',
  2000,
  ('2023-10-07 19:30'::timestamp AT TIME ZONE 'America/New_York'),
  false
)
) AS v(id, title, title_en, director, director_en, year, screening_at, is_active)
WHERE NOT EXISTS (
  SELECT 1 FROM screenings s
  WHERE (
    (s.screening_at AT TIME ZONE 'America/New_York')::date = (v.screening_at AT TIME ZONE 'America/New_York')::date
    AND (
      regexp_replace(BTRIM(s.title), '[（(]\d{4}[）)]\s*$', '', 'g') = v.title
      OR (
        s.year IS NOT DISTINCT FROM v.year
        AND (
          regexp_replace(BTRIM(s.title), '[（(]\d{4}[）)]\s*$', '', 'g') = v.title
          OR (LENGTH(regexp_replace(BTRIM(s.title), '[一-龥]', '', 'g')) < LENGTH(BTRIM(s.title)) AND LENGTH(regexp_replace(BTRIM(s.title), '[A-Za-z]', '', 'g')) < LENGTH(BTRIM(s.title)))
        )
        AND (
          NULLIF(BTRIM(s.director), '') IS NOT NULL
          OR NULLIF(BTRIM(s.director_en), '') IS NOT NULL
          OR (LENGTH(regexp_replace(BTRIM(s.title), '[一-龥]', '', 'g')) < LENGTH(BTRIM(s.title)) AND LENGTH(regexp_replace(BTRIM(s.title), '[A-Za-z]', '', 'g')) < LENGTH(BTRIM(s.title)))
        )
      )
    )
  )
)
ON CONFLICT (id) DO UPDATE SET
  title = CASE
    WHEN NULLIF(BTRIM(screenings.title), '') IS NOT NULL
      AND NULLIF(BTRIM(screenings.title_en), '') IS NOT NULL
    THEN screenings.title
    ELSE COALESCE(NULLIF(BTRIM(EXCLUDED.title), ''), screenings.title)
  END,
  title_en = CASE
    WHEN NULLIF(BTRIM(screenings.title), '') IS NOT NULL
      AND NULLIF(BTRIM(screenings.title_en), '') IS NOT NULL
    THEN screenings.title_en
    ELSE COALESCE(NULLIF(BTRIM(EXCLUDED.title_en), ''), screenings.title_en)
  END,
  director = CASE
    WHEN NULLIF(BTRIM(screenings.director), '') IS NOT NULL THEN screenings.director
    ELSE EXCLUDED.director
  END,
  director_en = CASE
    WHEN NULLIF(BTRIM(screenings.director_en), '') IS NOT NULL THEN screenings.director_en
    ELSE EXCLUDED.director_en
  END,
  year = EXCLUDED.year,
  screening_at = EXCLUDED.screening_at,
  is_active = false;

-- (B) Matching site rows: fill empty title / title_en only
UPDATE screenings AS s
SET
  title = CASE
    WHEN NULLIF(BTRIM(s.title), '') IS NULL THEN patch.sheet_title
    ELSE s.title
  END,
  title_en = CASE
    WHEN NULLIF(BTRIM(s.title_en), '') IS NULL THEN NULLIF(BTRIM(patch.sheet_title_en), '')
    ELSE s.title_en
  END
FROM (
  VALUES
  ('2026-05-09'::date, 2025, '笑刃荒途', 'I Only Rest in the Storm', ('2026-05-09 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-05-06'::date, 2002, '和你在一起', 'Together', ('2026-05-06 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-05-24'::date, 1994, '色情酒店', 'Exotica', ('2026-05-24 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-05-23'::date, 2009, '蒙巴纳斯', '', ('2026-05-23 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-05-23'::date, 2007, '报春花冈', '', ('2026-05-23 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-05-21'::date, 1979, '盗日者', 'The Man Who Stole the Sun', ('2026-05-21 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-05-20'::date, 1995, '花月佳期', 'Love in the Time of Twilight', ('2026-05-20 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-05-14'::date, 2001, '黑道小狂花', 'Sisters', ('2026-05-14 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-05-10'::date, 1986, '晚安，母亲', '''night, Mother', ('2026-05-10 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-05-01'::date, 2006, '红色之路', 'Red Road', ('2026-05-01 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-04-07'::date, 2017, '肉与灵', 'On Body and Soul', ('2026-04-07 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-04-05'::date, 1988, '布拉格之恋', 'The Unbearable Lightness of Being', ('2026-04-05 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-04-03'::date, 1969, '影子部队', 'Army of Shadows', ('2026-04-03 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-04-29'::date, 1995, '刀', 'The Blade', ('2026-04-29 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-04-24'::date, 1989, '香蕉天堂', 'Banana Paradise', ('2026-04-24 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-04-22'::date, 1984, '上海之夜', 'Shanghai Blues', ('2026-04-22 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-04-02'::date, 1992, '生生长流', 'Life, and Nothing More…', ('2026-04-02 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-04-14'::date, 2011, '我记住的歌', 'A Song I Remember', ('2026-04-14 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-04-13'::date, 1979, '疯劫', 'The Secret', ('2026-04-13 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-04-10'::date, 1966, '谁要杀死杰茜？', 'Who Wants to Kill Jessie?', ('2026-04-10 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-03-09'::date, 1984, '破碎之镜', 'Broken Mirrors', ('2026-03-09 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-03-08'::date, 1983, '她们的疯狂', 'Sheer Madness', ('2026-03-08 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-03-07'::date, 1981, '夜班时分', 'Nightshift', ('2026-03-07 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-03-07'::date, 1983, '情色剧院', 'Variety', ('2026-03-07 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-03-07'::date, 1984, '真幻之爱', 'Love on the Ground', ('2026-03-07 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-03-06'::date, 1985, '谢尔曼的征程', 'Sherman''s March', ('2026-03-06 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-03-05'::date, 2019, '金都', 'My Prince Edward', ('2026-03-05 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-03-31'::date, 2023, '女孩们都很好', 'The Girls Are Alright', ('2026-03-31 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-03-28'::date, 1986, '家书', 'Letters Home', ('2026-03-28 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-03-27'::date, 2004, '明天我们搬家', 'Tomorrow We Move', ('2026-03-27 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-03-25'::date, 1980, '名剑', 'The Sword', ('2026-03-25 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-03-22'::date, 2026, 'DB', 'DB', ('2026-03-22 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-03-20'::date, 1984, '唐朝豪放女', 'An Amorous Woman of Tang Dynasty', ('2026-03-20 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-03-16'::date, 2002, '对她说', 'Talk to Her', ('2026-03-16 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-03-14'::date, 2016, '曼谷之夜', 'Bangkok Nites', ('2026-03-14 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-03-13'::date, 1996, '绿行星', 'La Belle Verte', ('2026-03-13 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-03-11'::date, 2025, '是的', 'Yes', ('2026-03-11 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-02-09'::date, 2025, '镜的第三乐章', 'Miroirs No. 3', ('2026-02-09 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-02-09'::date, 1977, '热带小径', 'Tropical Paths', ('2026-02-09 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-02-03'::date, 1972, '梦想的生活', 'Dream Life', ('2026-02-03 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-02-28'::date, 1979, '空山灵雨', 'Raining in the Mountain', ('2026-02-28 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-02-27'::date, 1971, '死亡万岁', 'Long Live Death', ('2026-02-27 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-02-26'::date, 2022, '破碎太阳之心', 'A Short Story', ('2026-02-26 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-02-26'::date, 1989, '杀手蝴蝶梦', 'My Heart Is That Eternal Rose', ('2026-02-26 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-02-25'::date, 1993, '时间不确定', 'Time Indefinite', ('2026-02-25 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-02-21'::date, 2010, '卡洛斯', 'Carlos', ('2026-02-21 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-02-19'::date, 2008, '耶里肖', 'Jerichow', ('2026-02-19 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-02-16'::date, 1993, '八仙饭店之人肉叉烧包', 'The Untold Story', ('2026-02-16 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-02-12'::date, 2017, '一只市民阶级犬的自我批评', 'Self-Criticism of a Bourgeois Dog', ('2026-02-12 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-02-11'::date, 1989, '我的二十世纪', 'My Twentieth Century', ('2026-02-11 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-01-07'::date, 2025, '巴黎夏日', 'That Summer in Paris', ('2026-01-07 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-01-07'::date, 2022, '夏日假期', 'The Summer Holidays', ('2026-01-07 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-01-03'::date, 1995, '流氓医生', 'Doctor Mack', ('2026-01-03 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-01-20'::date, 2022, '猎鹰湖', 'Falcon Lake', ('2026-01-20 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-01-02'::date, 2002, '光明的未来', 'Bright Future', ('2026-01-02 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-01-16'::date, 2025, '电话铃响的时候', 'When the Phone Rang', ('2026-01-16 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-01-14'::date, 2002, '情人', 'The Lover', ('2026-01-14 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2026-01-13'::date, 2012, '舍间声响', 'Neighboring Sounds', ('2026-01-13 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-07-01'::date, 2022, '无熊之境', 'No Bears', ('2025-07-01 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-06-09'::date, 1979, '妖怪人', 'Kummatty', ('2025-06-09 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-06-09'::date, 2007, 'Rehearsals for Retirement', 'Rehearsals for Retirement', ('2025-06-09 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-06-08'::date, 1995, '安然无恙', 'Safe', ('2025-06-08 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-06-07'::date, 2006, '医生', 'Doctor', ('2025-06-07 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-06-06'::date, 1992, '奥兰多', 'Orlando', ('2025-06-06 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-06-04'::date, 2024, '宽恕', 'Misericordia', ('2025-06-04 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-06-27'::date, 2021, '日常', 'Decameron', ('2025-06-27 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-06-24'::date, 1977, '星球大战', 'Star Wars', ('2025-06-24 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-06-21'::date, 1998, '四月物语', 'April Story', ('2025-06-21 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-06-18'::date, 1978, '杀羊人', 'Killer of Sheep', ('2025-06-18 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-06-15'::date, 1986, '恋恋风尘', 'Dust in the Wind', ('2025-06-15 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-06-14'::date, 1975, '热天午后', 'Dog Day Afternoon', ('2025-06-14 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-06-12'::date, 1996, '惊世狂花', 'Bound', ('2025-06-12 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-06-11'::date, 2013, '最佳出价', 'The Best Offer', ('2025-06-11 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-06-11'::date, 2009, '浴室里的鳄鱼', 'Crocodile', ('2025-06-11 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-05-07'::date, 1999, '罗塞塔', 'Rosetta', ('2025-05-07 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-05-04'::date, 2024, '昨日青春', 'Happyend', ('2025-05-04 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-05-31'::date, 1994, '笑林小子', 'Shaolin Popey', ('2025-05-31 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-05-30'::date, 1996, '梦旅人', 'Picnic', ('2025-05-30 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-05-03'::date, 1970, '侠女', 'A Touch of Zen', ('2025-05-03 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-05-28'::date, 2002, '在黑暗的时代', 'In the Darkness of Time', ('2025-05-28 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-05-28'::date, 1959, '纳萨林', 'Nazarín', ('2025-05-28 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-05-28'::date, 2011, '我看见了一只美洲狮', 'I Could See a Puma', ('2025-05-28 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-05-26'::date, 1985, '神话', 'Phenomena', ('2025-05-26 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-05-26'::date, 2009, '惊恐小镇', 'A Town Called Panic', ('2025-05-26 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-05-26'::date, 2022, '在她们眼中', 'Le Pupille', ('2025-05-26 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-05-26'::date, 2024, '都市寓言', 'An Urban Allegory', ('2025-05-26 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-05-25'::date, 1989, '有一天皮娜问我', 'One Day Pina Asked...', ('2025-05-25 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-05-24'::date, 1997, '20世纪的乡愁', '20th Century Nostalgia', ('2025-05-24 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-05-23'::date, 1997, '初缠恋后的2人世界', 'First Love: The Litter on the Breeze', ('2025-05-23 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-05-02'::date, 2018, '观看《他人之痛》', 'Watching the Pain of Others', ('2025-05-02 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-05-16'::date, 2018, '他他她他他', 'Gusto Kita With All My Hypothalamus', ('2025-05-16 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-05-14'::date, 2022, '公园的沙池', 'Garden Sandbox', ('2025-05-14 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-05-10'::date, 2015, '非家庭电影', 'No Home Movie', ('2025-05-10 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-04-26'::date, 2024, '共同的语言', 'Universal Language', ('2025-04-26 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-04-18'::date, 2006, '木星的初恋', 'Mukhsin', ('2025-04-18 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-04-11'::date, 2024, '我仍在此', 'I''m Still Here', ('2025-04-11 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-03-08'::date, 1986, '绿光', 'The Green Ray', ('2025-03-08 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-03-08'::date, 2017, '午后阴影', 'Afternoon Clouds', ('2025-03-08 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-03-08'::date, 2011, '竖笛考试', 'The Recorder Exam', ('2025-03-08 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-03-08'::date, 2019, '82年生的金智英', 'Kim Ji-young: Born 1982', ('2025-03-08 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-03-07'::date, 2024, '出走的决心', 'Like A Rolling Stone', ('2025-03-07 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-03-30'::date, 1997, '花火', 'Fireworks', ('2025-03-30 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-03-29'::date, 1998, '海上花', 'Flowers of Shanghai', ('2025-03-29 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-03-28'::date, 2024, '女孩终究是女孩', 'Girls Will Be Girls', ('2025-03-28 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-03-22'::date, 2015, '橘色', 'Tangerine', ('2025-03-22 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-03-21'::date, 1986, '工薪女孩', 'Working Girls', ('2025-03-21 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-03-02'::date, 2021, '我想聊聊杜拉斯', 'I Want to Talk About Duras', ('2025-03-02 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-03-15'::date, 2002, '默文·卡拉', 'Morvern Callar', ('2025-03-15 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-03-14'::date, 1981, '德国姊妹', 'Marianne and Juliane', ('2025-03-14 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-02-08'::date, 1996, '秘密与谎言', 'Secrets & Lies', ('2025-02-08 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-02-07'::date, 2007, '密阳', 'Secret Sunshine', ('2025-02-07 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-02-28'::date, 2009, '鱼缸', 'Fish Tank', ('2025-02-28 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-02-23'::date, 1997, '盗信情缘', 'Postman Blues', ('2025-02-23 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-02-23'::date, 2013, '豆芽', 'Sprout', ('2025-02-23 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-02-16'::date, 2003, '大只佬', 'Running on Karma', ('2025-02-16 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-02-14'::date, 1972, '柏蒂娜的苦泪', 'The Bitter Tears of Petra von Kant', ('2025-02-14 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-12-05'::date, 1990, '爱在别乡的季节', 'Farewell China', ('2025-12-05 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-12-04'::date, 2023, '主要音调', 'The Major Tones', ('2025-12-04 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-12-27'::date, 1985, '妙想天开', 'Brazil', ('2025-12-27 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-12-27'::date, 1960, '桃色公寓', 'The Apartment', ('2025-12-27 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-12-27'::date, 1995, '流砂幻爱', 'Like Grains of Sand', ('2025-12-27 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-12-26'::date, 1989, '潘金莲之前世今生', 'The Reincarnation of Golden Lotus', ('2025-12-26 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-12-24'::date, 1975, '迷雾中的小刺猬', 'Hedgehog in the Fog', ('2025-12-24 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-12-24'::date, 2007, '电子管', 'The Tube with a Hat', ('2025-12-24 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-12-24'::date, 2007, '捷克惊魂夜', 'One Night in One City', ('2025-12-24 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-12-21'::date, 1970, '积少成多', 'Little by Little', ('2025-12-21 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-12-21'::date, 1988, '千面珍宝金', 'Jane B. by Agnès V.', ('2025-12-21 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-12-20'::date, 2025, '普通事故', 'It Was Just an Accident', ('2025-12-20 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-12-19'::date, 2022, 'The Invention of the Other', 'The Invention of the Other', ('2025-12-19 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-12-11'::date, 2023, '且唱且珍惜', 'The Klezmer Project', ('2025-12-11 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-12-10'::date, 1987, '秋天的童话', 'An Autumn''s Tale', ('2025-12-10 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-11-28'::date, 2004, '茶之味', 'The Taste of Tea', ('2025-11-28 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-11-26'::date, 1993, '诱僧', 'Temptation of a Monk', ('2025-11-26 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-11-26'::date, 2002, '夕阳天使', 'So Close', ('2025-11-26 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-11-21'::date, 1986, '外星奇遇', 'Kin-dza-dza!', ('2025-11-21 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-11-17'::date, 2023, '不要太期待世界末日', 'Do Not Expect Too Much from the End of the World', ('2025-11-17 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-11-16'::date, 2001, '季风婚宴', 'Monsoon Wedding', ('2025-11-16 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-11-15'::date, 1994, '事情原来是这样的……', 'What Happened Was...', ('2025-11-15 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-11-15'::date, 2022, '非快速眼动之窗', 'ノンレムの窓 2022・秋', ('2025-11-15 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-01-31'::date, 1973, '爱情与无政府', 'Love and Anarchy', ('2025-01-31 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-01-28'::date, 1998, '爱情来了', 'Love Go Go', ('2025-01-28 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-01-25'::date, 2010, '豆满江', 'Dooman River', ('2025-01-25 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-01-24'::date, 2005, '红颜', 'Dam Street', ('2025-01-24 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-01-24'::date, 1996, '姐姐', 'Older Sister', ('2025-01-24 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-01-18'::date, 2012, 'Łukasz i Lotta', 'Łukasz i Lotta', ('2025-01-18 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-01-18'::date, 1997, '涩谷24小时', 'Bounce Ko Gals', ('2025-01-18 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2025-01-17'::date, 1990, '陌生人为伴', 'The Company of Strangers', ('2025-01-17 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-09-08'::date, 2004, '绿色唱片', 'Green Vinyl', ('2024-09-08 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-09-08'::date, 1998, '帕乌利什塔的手', 'The Hand of Paulișta', ('2024-09-08 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-09-08'::date, 2019, '身体记着世间何时崩裂', 'The Body Remembers When the World Broke Open', ('2024-09-08 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-09-08'::date, 1997, 'X圣治', 'Cure', ('2024-09-08 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-09-29'::date, 1985, '天涯沦落女', 'Vagabond', ('2024-09-29 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-09-27'::date, 1977, '鬼怪屋', 'House', ('2024-09-27 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-09-22'::date, 1973, '修罗雪姬', 'Lady Snowblood', ('2024-09-22 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-09-22'::date, 2006, '被嫌弃的松子的一生', 'Memories of Matsuko', ('2024-09-22 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-09-02'::date, 2004, '花与爱丽丝', 'Hana & Alice', ('2024-09-02 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-09-15'::date, 2021, '独自生活的人们', 'Aloners', ('2024-09-15 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-09-14'::date, 1985, '青春祭', 'Sacrificed Youth', ('2024-09-14 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-09-13'::date, 2021, 'Contretemps', 'Contretemps', ('2024-09-13 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-09-13'::date, 2016, 'Pussy (Cipka)', 'Pussy', ('2024-09-13 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-09-13'::date, 1964, '怪谈', 'Kwaidan', ('2024-09-13 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-09-01'::date, 1995, '欢乐街', 'Joy Street', ('2024-09-01 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-09-01'::date, 1979, '芦笋', 'Asparagus', ('2024-09-01 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-09-01'::date, 1983, '硝烟中诞生', 'Born in Flames', ('2024-09-01 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-08-31'::date, 2001, '东京金盏花', 'Tokyo Marigold', ('2024-08-31 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-08-29'::date, 1997, '自梳', 'Intimates', ('2024-08-29 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-08-28'::date, 1998, '爱与时尚', 'Love & Pop', ('2024-08-28 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-08-25'::date, 2011, '妓院里的回忆', 'House of Tolerance', ('2024-08-25 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-08-22'::date, 1984, '人鱼传说', 'Mermaid Legend', ('2024-08-22 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-08-21'::date, 1977, '三女性', '3 Women', ('2024-08-21 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-08-20'::date, 2015, '夏日感悟', 'This Summer Feeling', ('2024-08-20 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-08-17'::date, 2022, '巴黎夜旅人', 'The Passengers of the Night', ('2024-08-17 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-08-10'::date, 1969, '丛林怪兽', 'Macunaima', ('2024-08-10 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-07-07'::date, 2012, '唐皇游地府', 'Emperor Visits the Hell', ('2024-07-07 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-07-07'::date, 2004, '清洁', 'Clean', ('2024-07-07 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-07-28'::date, 1978, '贫穷的吸血鬼', 'The Vampires of Poverty', ('2024-07-28 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-07-27'::date, 2011, '我的狗狗王子', 'Love on a Leash', ('2024-07-27 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-07-27'::date, 2016, 'My house walk-through', 'My House Walk-Through', ('2024-07-27 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-07-25'::date, 1966, '放大', 'Blow-Up', ('2024-07-25 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-07-21'::date, 2005, '琳达！琳达！琳达！', 'Linda Linda Linda', ('2024-07-21 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-07-21'::date, 2015, '李文漫游东湖', 'Li Wen at East Lake', ('2024-07-21 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-07-11'::date, 1971, '交通意外', 'Trafic', ('2024-07-11 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-07-11'::date, 1967, '杀手烙印', 'Branded to Kill', ('2024-07-11 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-07-11'::date, 2024, '钟声', 'Chime', ('2024-07-11 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-06-09'::date, 2023, '还有明天', 'There''s Still Tomorrow', ('2024-06-09 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-06-04'::date, 2014, '金甲虫', 'The Gold Bug', ('2024-06-04 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-06-29'::date, 2002, '哈哈笑', 'Funny Ha Ha', ('2024-06-29 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-06-29'::date, 2001, '猫样少女', 'Take Care of My Cat', ('2024-06-29 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-06-27'::date, 2002, '八美图', '8 Women', ('2024-06-27 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-06-23'::date, 1982, '投奔怒海', 'Boat People', ('2024-06-23 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-06-02'::date, 1982, '黑暗', 'Tenebre', ('2024-06-02 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-06-19'::date, 1996, '寻找西瓜女', 'The Watermelon Woman', ('2024-06-19 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-06-16'::date, 1978, '女朋友', 'Girlfriends', ('2024-06-16 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-05-04'::date, 1969, '战争花园', 'Garden of War', ('2024-05-04 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-05-28'::date, 2023, '甜蜜的东方', 'The Sweet East', ('2024-05-28 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-05-26'::date, 2023, '火之谜', 'Riddle of Fire', ('2024-05-26 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-05-18'::date, 1989, '悲情城市', 'A City of Sadness', ('2024-05-18 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-05-10'::date, 2009, '我们天上见', 'We''ll Meet in Heaven', ('2024-05-10 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-04-07'::date, 1995, '安东尼娅家族', 'Antonia''s Line', ('2024-04-07 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-04-06'::date, 1979, '草迷宫', 'Grass Labyrinth', ('2024-04-06 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-04-06'::date, 1972, '女囚701号-蝎子', 'Female Prisoner #701: Scorpion', ('2024-04-06 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-04-29'::date, 2016, '天国还很遥远', 'Heaven Is Still Far Away', ('2024-04-29 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-04-20'::date, 2000, '巴黎浮世绘', 'Code Unknown', ('2024-04-20 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-04-20'::date, 1968, '赤裸童年', 'Naked Childhood', ('2024-04-20 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-04-12'::date, 1969, '蔷薇的葬礼', 'Funeral Parade of Roses', ('2024-04-12 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-04-12'::date, 1993, '东方三侠', 'The Heroic Trio', ('2024-04-12 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-03-08'::date, 2001, '漫画家之路', 'Forklift Driver Klaus: The First Day on the Job', ('2024-03-08 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-03-08'::date, 2000, '铲车司机克劳斯—第一个工作日', 'Freddy Got Fingered', ('2024-03-08 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-03-31'::date, 2000, '顺流逆流', 'Time and Tide', ('2024-03-31 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-03-29'::date, 2023, '机器人之梦', 'Robot Dreams', ('2024-03-29 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-03-28'::date, 1968, '女伶们', 'The Girls', ('2024-03-28 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-03-23'::date, 2006, '潘神的迷宫', 'Pan''s Labyrinth', ('2024-03-23 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-03-02'::date, 1994, '梁祝', 'The Lovers', ('2024-03-02 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-03-02'::date, 1960, '野玫瑰之恋', 'The Wild, Wild Rose', ('2024-03-02 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-03-02'::date, 2007, '四月三周两天', '4 Months, 3 Weeks and 2 Days', ('2024-03-02 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-03-17'::date, 1993, '特沃塔和我', 'Travolta and Me', ('2024-03-17 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-02-02'::date, 1968, '活死人之夜', 'Night of the Living Dead', ('2024-02-02 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-02-14'::date, 2012, '东黑斯廷斯药房', 'East Hastings Pharmacy', ('2024-02-14 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-02-14'::date, 1987, '恐怖歌剧', 'Opera', ('2024-02-14 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-02-01'::date, 1977, '一个唱，一个不唱', 'One Sings, the Other Doesn''t', ('2024-02-01 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-12-06'::date, 2022, '三粒粗盐', 'Three Grains of Coarse Salt', ('2024-12-06 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-12-06'::date, 2012, '爱', 'Amour', ('2024-12-06 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-12-29'::date, 2003, '黄蜂', 'Wasp', ('2024-12-29 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-12-29'::date, 2009, '鱼的故事', 'Fish Story', ('2024-12-29 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-12-27'::date, 1962, '猫皮', 'Cat Skin', ('2024-12-27 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-12-27'::date, 1984, '小奏鸣曲', 'Sonatine', ('2024-12-27 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-12-20'::date, 1971, '逃家', 'Taking Off', ('2024-12-20 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-12-01'::date, 1995, '鬼汤', 'Ghost Soup', ('2024-12-01 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-12-01'::date, 1995, '烟花', 'Fireworks, Should We See It from the Side or the Bottom?', ('2024-12-01 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-12-01'::date, 2024, '蓦然回首', 'Look Back', ('2024-12-01 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-11-08'::date, 1995, '肮脏的爱情', 'Troubling Love', ('2024-11-08 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-11-03'::date, 2022, '再见，杰罗姆！', 'Goodbye Jerome!', ('2024-11-03 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-11-03'::date, 2015, '花与爱丽丝杀人事件', 'The Case of Hana & Alice', ('2024-11-03 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-11-29'::date, 1966, '传说在下午,有时会遇到吸血鬼', 'Emotion', ('2024-11-29 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-11-29'::date, 2022, '为吾子寄信吾母', 'Letter to My Mother for My Son', ('2024-11-29 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-11-29'::date, 2004, '下妻物语', 'Kamikaze Girls', ('2024-11-29 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-11-23'::date, 2016, '美国甜心', 'American Honey', ('2024-11-23 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-11-23'::date, 1954, '电话谋杀案', 'Dial M for Murder', ('2024-11-23 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-11-22'::date, 2019, '太阳狗', 'Sun Dog', ('2024-11-22 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-11-22'::date, 2007, '夜幕降临上海', 'Nightfall in Shanghai', ('2024-11-22 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-11-22'::date, 1997, '秘密花园', 'My Secret Cache', ('2024-11-22 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-11-22'::date, 1967, 'Examen d’entrée INSAS', 'Examen d''entrée INSAS', ('2024-11-22 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-11-22'::date, 1986, '怠惰女子的肖像', 'Portrait of a Lazy Woman', ('2024-11-22 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-11-22'::date, 2010, '噪音如是说', 'Thus a Noise Speaks', ('2024-11-22 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-11-16'::date, 1969, '入侵', 'Invasion', ('2024-11-16 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-11-15'::date, 2013, '东京家族', 'Tokyo Family', ('2024-11-15 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-10-08'::date, 2020, '观影室', 'The Viewing Booth', ('2024-10-08 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-10-06'::date, 2001, '你妈妈也一样', 'Y Tu Mamá También', ('2024-10-06 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-10-25'::date, 1995, '热带鱼', 'Tropical Fish', ('2024-10-25 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-10-20'::date, 1977, '最后大浪', 'The Last Wave', ('2024-10-20 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-10-18'::date, 1996, '然后我们跳了舞', 'And Then We Danced', ('2024-10-18 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-10-13'::date, 1986, '国王的电影', 'A King and His Movie', ('2024-10-13 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-10-11'::date, 1987, '人·鬼·情', 'Woman Demon Human', ('2024-10-11 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-01-03'::date, 1976, '饲养乌鸦', 'Cria!', ('2024-01-03 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-01-26'::date, 1988, '崩溃边缘的女人', 'Women on the Verge of a Nervous Breakdown', ('2024-01-26 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-01-26'::date, 1985, '银河铁道之夜', 'Night on the Galactic Railroad', ('2024-01-26 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-01-21'::date, 1986, '他的摩托，她的岛', 'His Motorbike, Her Island', ('2024-01-21 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-01-20'::date, 1993, '青蛇', 'Green Snake', ('2024-01-20 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-01-20'::date, 1986, '刀马旦', 'Peking Opera Blues', ('2024-01-20 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-01-20'::date, 1991, '致胜法门', 'Theory of Achievement', ('2024-01-20 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-01-20'::date, 1988, '快盗鲁比', 'Kaito Ruby', ('2024-01-20 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-01-01'::date, 1997, '梦幻银河', 'Labyrinth of Dreams', ('2024-01-01 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2024-01-01'::date, 2019, '对不起，我们错过了你', 'Sorry We Missed You', ('2024-01-01 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2023-09-24'::date, 2022, '迷雾中的她（上）', '', ('2023-09-24 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2023-08-28'::date, 2022, '惠子，凝视', 'Small, Slow But Steady', ('2023-08-28 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2023-08-13'::date, 1995, '水中八月', 'August in the Water', ('2023-08-13 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2023-12-28'::date, 1988, '脑髓地狱', 'Dogra Magra', ('2023-12-28 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2023-12-23'::date, 1977, '史楚锡流浪记', 'Stroszek', ('2023-12-23 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2023-12-10'::date, 1996, '冰血暴', 'Fargo', ('2023-12-10 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2023-11-07'::date, 2021, '夏天 Лето', 'Summer', ('2023-11-07 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2023-11-21'::date, 2005, '神呀神！你为何离弃我？', 'My God, My God, Why Hast Thou Forsaken Me?', ('2023-11-21 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2023-11-19'::date, 1994, '鲜杀', 'Fresh Kill', ('2023-11-19 19:30'::timestamp AT TIME ZONE 'America/New_York')),
  ('2023-10-07'::date, 2000, '式日', 'Ritual', ('2023-10-07 19:30'::timestamp AT TIME ZONE 'America/New_York'))
) AS patch(screening_date, release_year, sheet_title, sheet_title_en, screening_at)
WHERE (
    (s.screening_at AT TIME ZONE 'America/New_York')::date = (patch.screening_at AT TIME ZONE 'America/New_York')::date
    AND (
      regexp_replace(BTRIM(s.title), '[（(]\d{4}[）)]\s*$', '', 'g') = patch.sheet_title
      OR (
        s.year IS NOT DISTINCT FROM patch.release_year
        AND (
          regexp_replace(BTRIM(s.title), '[（(]\d{4}[）)]\s*$', '', 'g') = patch.sheet_title
          OR (LENGTH(regexp_replace(BTRIM(s.title), '[一-龥]', '', 'g')) < LENGTH(BTRIM(s.title)) AND LENGTH(regexp_replace(BTRIM(s.title), '[A-Za-z]', '', 'g')) < LENGTH(BTRIM(s.title)))
        )
        AND (
          NULLIF(BTRIM(s.director), '') IS NOT NULL
          OR NULLIF(BTRIM(s.director_en), '') IS NOT NULL
          OR (LENGTH(regexp_replace(BTRIM(s.title), '[一-龥]', '', 'g')) < LENGTH(BTRIM(s.title)) AND LENGTH(regexp_replace(BTRIM(s.title), '[A-Za-z]', '', 'g')) < LENGTH(BTRIM(s.title)))
        )
      )
    )
  )
  AND (
    NULLIF(BTRIM(s.title), '') IS NULL
    OR NULLIF(BTRIM(s.title_en), '') IS NULL
  )
  AND NOT (
    NULLIF(BTRIM(s.title), '') IS NOT NULL
    AND NULLIF(BTRIM(s.title_en), '') IS NOT NULL
  );

-- (C) Bilingual combined title → Chinese in title, Latin suffix in title_en
UPDATE screenings AS s
SET
  title = split.zh,
  title_en = split.latin
FROM (
  SELECT
    id,
    (regexp_match(
      BTRIM(title),
      '^([一-鿿　-〿＀-￯s，、。！？；：""''（）【】《》—…·]+?)\s+(.+)$'
    ))[1] AS zh,
    (regexp_match(
      BTRIM(title),
      '^([一-鿿　-〿＀-￯s，、。！？；：""''（）【】《》—…·]+?)\s+(.+)$'
    ))[2] AS latin
  FROM screenings
  WHERE title ~ '[一-鿿]'
    AND title ~ '[A-Za-z]'
) AS split
WHERE s.id = split.id
  AND split.zh IS NOT NULL
  AND split.latin IS NOT NULL;
