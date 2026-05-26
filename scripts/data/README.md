# Historical screening data

- `ziggygraph-screenings-zh.csv` — exported from [Ziggygraph Google Sheet](https://docs.google.com/spreadsheets/d/1lrEE5G72IrhtxurPoYcLOJP2YKwGXGduKA44nYsjQ-M/). Source for migration **37**.
- `letterboxd-diary.csv` — Letterboxd diary export. Rows whose **Tags** contain `ziggygraph` (case-insensitive) supply English **Name** values, matched to sheet rows by **Watched Date** + release year in the Chinese title `（YYYY）`.

Regenerate SQL after editing either file:

```bash
node scripts/generate-historical-screenings-sql.mjs
```

Outputs:

| File | Purpose |
|------|---------|
| `supabase-sql/37-seed-historical-screenings-catalog.sql` | Sheet seed + patch empty names on existing same-night rows (see supabase-sql/README.md) |
| `historical-title-en-map.json` | Matched Chinese → English titles |
| `historical-title-en-unmatched.json` | Rows with no Letterboxd match (fill manually on site) |

Matching rules (see `scripts/lib/match-letterboxd-en.mjs`): same screening date + year; unique-year pairing on multi-film nights; ±1 **Watched Date** when no same-day match and exactly one unused ziggygraph row on the adjacent day with the same release year.
