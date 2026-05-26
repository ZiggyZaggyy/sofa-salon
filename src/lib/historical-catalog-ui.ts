/** In EN locale, show Chinese title in subtitle when it differs from the English display title. */
export function shouldShowChineseTitleInEnSubtitle(title: string, titleEn: string): boolean {
  const zh = title.trim();
  const en = titleEn.trim();
  return zh.length > 0 && en.length > 0 && en !== zh;
}
