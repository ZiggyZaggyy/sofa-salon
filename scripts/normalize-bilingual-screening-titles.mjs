/**
 * Fix screenings where title = "中文 Latin title" in one field.
 * Sets title = Chinese only; fills title_en only when empty (Latin suffix or keep existing).
 *
 * Run: node scripts/normalize-bilingual-screening-titles.mjs
 */
import { createClient } from '@supabase/supabase-js';
import { readFileSync } from 'fs';
import { dirname, join } from 'path';
import { fileURLToPath } from 'url';
import { splitBilingualTitle } from './lib/split-bilingual-title.mjs';

const __dirname = dirname(fileURLToPath(import.meta.url));

function loadEnvLocal() {
  const env = {};
  try {
    const raw = readFileSync(join(__dirname, '../.env.local'), 'utf8');
    for (const line of raw.split('\n')) {
      const m = line.match(/^([A-Za-z_][A-Za-z0-9_]*)=(.*)$/);
      if (!m) continue;
      let v = m[2].trim();
      if ((v.startsWith('"') && v.endsWith('"')) || (v.startsWith("'") && v.endsWith("'"))) {
        v = v.slice(1, -1);
      }
      env[m[1]] = v;
    }
  } catch {
    /* optional */
  }
  return env;
}

async function main() {
  const env = loadEnvLocal();
  const url = env.NEXT_PUBLIC_SUPABASE_URL;
  const key = env.SUPABASE_SERVICE_ROLE_KEY;
  if (!url || !key) {
    console.error('Need NEXT_PUBLIC_SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY in .env.local');
    process.exit(1);
  }

  const supabase = createClient(url, key);
  const { data: rows, error } = await supabase
    .from('screenings')
    .select('id, title, title_en');

  if (error) {
    console.error(error.message);
    process.exit(1);
  }

  let updated = 0;
  for (const row of rows ?? []) {
    const split = splitBilingualTitle(row.title);
    if (!split) continue;

    // Site rows often store "中文 Foreign title" in one field — Latin belongs in title_en.
    const patch = { title: split.zh, title_en: split.latin };

    const { error: upErr } = await supabase.from('screenings').update(patch).eq('id', row.id);
    if (upErr) {
      console.error(row.id, upErr.message);
      continue;
    }
    updated++;
    console.log(`${row.id}: "${row.title}" → title="${split.zh}" title_en="${patch.title_en ?? row.title_en}"`);
  }

  console.log(`Updated ${updated} screening(s).`);
}

main();
