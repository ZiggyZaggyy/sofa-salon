export function parseSheetDate(dateStr) {
  const [y, m, d] = dateStr.trim().split('.');
  return `${Number(y)}-${String(Number(m)).padStart(2, '0')}-${String(Number(d)).padStart(2, '0')}`;
}

export function extractFilmYear(title) {
  const m = title.match(/[（(](\d{4})[）)]/);
  return m ? Number(m[1]) : null;
}

/** Sheet titles include trailing （YYYY）; DB Chinese title should not. */
export function stripTitleYearSuffix(title) {
  return title.trim().replace(/[（(]\d{4}[）)]\s*$/, '').trim();
}

export function parseCsvLine(line) {
  const out = [];
  let cur = '';
  let inQ = false;
  for (let i = 0; i < line.length; i++) {
    const c = line[i];
    if (c === '"') {
      inQ = !inQ;
      continue;
    }
    if (c === ',' && !inQ) {
      out.push(cur);
      cur = '';
      continue;
    }
    cur += c;
  }
  out.push(cur);
  return out;
}
