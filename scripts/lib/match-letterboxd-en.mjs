/**
 * Match Ziggygraph Letterboxd diary rows (Tags contains ziggygraph) to Chinese sheet rows by
 * screening date (Watched Date) + release year, with ±1 day fallback when needed.
 */
import { readFileSync } from 'fs';
import { parseCsvLine, parseSheetDate, extractFilmYear } from './parse-screening-csv.mjs';

function addDays(isoDate, delta) {
  const d = new Date(`${isoDate}T12:00:00Z`);
  d.setUTCDate(d.getUTCDate() + delta);
  return d.toISOString().slice(0, 10);
}

function isMostlyLatin(s) {
  if (!s?.trim()) return false;
  const latin = (s.match(/[A-Za-z0-9]/g) || []).length;
  const cjk = (s.match(/[\u4e00-\u9fff]/g) || []).length;
  return latin > 0 && cjk === 0;
}

/** @param {Array<{date:string,title:string,year:number|null}>} zhList */
/** @param {Array<{name:string,year:number}>} lbList */
function matchOnDate(zhList, lbList) {
  const zhIdx = zhList.map((_, i) => i);
  const lbIdx = lbList.map((_, i) => i);
  /** @type {Array<[number,number]>} */
  const pairs = [];

  const take = (zi, li) => {
    pairs.push([zi, li]);
    const zPos = zhIdx.indexOf(zi);
    const lPos = lbIdx.indexOf(li);
    if (zPos >= 0) zhIdx.splice(zPos, 1);
    if (lPos >= 0) lbIdx.splice(lPos, 1);
  };

  // Pass 1: unique year match
  for (const zi of [...zhIdx]) {
    const z = zhList[zi];
    if (z.year == null) continue;
    const lbSameYear = lbIdx.filter((li) => lbList[li].year === z.year);
    const zhSameYear = zhIdx.filter((i) => zhList[i].year === z.year);
    if (lbSameYear.length === 1 && zhSameYear.length === 1) {
      take(zi, lbSameYear[0]);
    }
  }

  // Pass 2: equal counts → pair by sorted year
  if (zhIdx.length > 0 && zhIdx.length === lbIdx.length) {
    const zSorted = [...zhIdx].sort((a, b) => (zhList[a].year ?? 0) - (zhList[b].year ?? 0));
    const lSorted = [...lbIdx].sort((a, b) => (lbList[a].year ?? 0) - (lbList[b].year ?? 0));
    for (let i = 0; i < zSorted.length; i++) {
      take(zSorted[i], lSorted[i]);
    }
  }

  // Pass 3: lone leftover
  if (zhIdx.length === 1 && lbIdx.length === 1) {
    take(zhIdx[0], lbIdx[0]);
  }

  // Pass 4: unique year among remaining rows on this date
  let changed = true;
  while (changed) {
    changed = false;
    const years = new Set(zhIdx.map((i) => zhList[i].year).filter((y) => y != null));
    for (const yr of years) {
      const zs = zhIdx.filter((i) => zhList[i].year === yr);
      const ls = lbIdx.filter((i) => lbList[i].year === yr);
      if (zs.length === 1 && ls.length === 1) {
        take(zs[0], ls[0]);
        changed = true;
      }
    }
  }

  return pairs;
}

/**
 * @returns {Map<string, string>} key `${date}|${title}` → English title
 */
export function buildTitleEnMap(zhCsvPath, diaryCsvPath) {
  /** @type {Map<string, Array<{name:string,year:number}>>} */
  const lbByDate = new Map();
  const diaryRaw = readFileSync(diaryCsvPath, 'utf8').trim();
  const diaryLines = diaryRaw.split(/\r?\n/);
  const header = parseCsvLine(diaryLines[0]);
  const tagsCol = header.indexOf('Tags');
  const nameCol = header.indexOf('Name');
  const yearCol = header.indexOf('Year');
  const watchedCol = header.indexOf('Watched Date');

  for (let i = 1; i < diaryLines.length; i++) {
    const cols = parseCsvLine(diaryLines[i]);
    if (cols.length < header.length) continue;
    const tags = cols[tagsCol] ?? '';
    if (!tags.toLowerCase().includes('ziggygraph')) continue;
    const wd = (cols[watchedCol] ?? '').trim();
    if (!wd) continue;
    const entry = {
      name: (cols[nameCol] ?? '').trim(),
      year: Number(cols[yearCol]) || null,
    };
    if (!lbByDate.has(wd)) lbByDate.set(wd, []);
    lbByDate.get(wd).push(entry);
  }

  /** @type {Array<{date:string,title:string,year:number|null}>} */
  const zhRows = [];
  const zhRaw = readFileSync(zhCsvPath, 'utf8').trim();
  for (const line of zhRaw.split(/\r?\n/)) {
    if (!line.trim()) continue;
    const [date, title] = parseCsvLine(line);
    if (!date?.match(/^\d{4}\.\d{1,2}\.\d{1,2}$/)) continue;
    zhRows.push({
      date: parseSheetDate(date),
      title: title.trim(),
      year: extractFilmYear(title),
    });
  }

  /** @type {Map<string, string>} */
  const map = new Map();
  /** @type {Map<string, Set<number>>} */
  const usedLbByDate = new Map();

  const markLbUsed = (date, index) => {
    if (!usedLbByDate.has(date)) usedLbByDate.set(date, new Set());
    usedLbByDate.get(date).add(index);
  };

  const dates = [...new Set(zhRows.map((r) => r.date))];
  for (const date of dates) {
    const zhList = zhRows.filter((r) => r.date === date);
    const lbList = lbByDate.get(date) ?? [];

    const pairs = matchOnDate(zhList, lbList);
    for (const [zi, li] of pairs) {
      markLbUsed(date, li);
      const z = zhList[zi];
      map.set(`${date}|${z.title}`, lbList[li].name);
    }
  }

  // ±1 Watched Date when sheet night has no same-day match but adjacent day has one ziggygraph row with same year
  for (const z of zhRows) {
    const key = `${z.date}|${z.title}`;
    if (map.has(key)) continue;
    if (z.year == null) continue;

    for (const delta of [-1, 1]) {
      const adj = addDays(z.date, delta);
      const lbList = lbByDate.get(adj) ?? [];
      const used = usedLbByDate.get(adj) ?? new Set();
      const cands = lbList
        .map((l, i) => ({ ...l, i }))
        .filter((l) => l.year === z.year && !used.has(l.i));
      if (cands.length === 1) {
        markLbUsed(adj, cands[0].i);
        map.set(key, cands[0].name);
        break;
      }
    }
  }

  // Latin-only titles from sheet when still no Letterboxd match
  for (const z of zhRows) {
    const key = `${z.date}|${z.title}`;
    if (!map.has(key) && isMostlyLatin(z.title)) {
      map.set(key, z.title);
    }
  }

  return map;
}

export function titleEnForRow(map, date, title) {
  return map.get(`${date}|${title}`) ?? '';
}
