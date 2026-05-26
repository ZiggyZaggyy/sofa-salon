/**
 * Split "中文 English or Spanish title" stored in a single title field.
 */
export function splitBilingualTitle(title) {
  const raw = (title ?? '').trim();
  if (!raw) return null;

  const hasCjk = /[\u4e00-\u9fff]/.test(raw);
  const hasLatin = /[A-Za-z]/.test(raw);
  if (!hasCjk || !hasLatin) return null;

  const m = raw.match(
    /^([\u4e00-\u9fff\u3000-\u303f\uff00-\uffef\s，、。！？；：""''（）【】《》—…·]+?)\s+(.+)$/
  );
  if (!m) return null;

  const zh = m[1].trim();
  const latin = m[2].trim();
  if (!zh || !latin || !/[\u4e00-\u9fff]/.test(zh) || !/[A-Za-z]/.test(latin)) {
    return null;
  }

  return { zh, latin };
}
