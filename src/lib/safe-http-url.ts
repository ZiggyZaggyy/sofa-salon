function normalizeExternalUrlInput(raw: string): string {
  const firstLine =
    String(raw)
      .replace(/\u00a0/g, ' ')
      .replace(/[\u200b-\u200d\ufeff]/g, '')
      .split(/\r?\n/)
      .map((l) => l.trim())
      .find(Boolean) ?? '';
  return firstLine.trim();
}

function tryParseHttpUrl(candidate: string): string | null {
  const withScheme = /^https?:\/\//i.test(candidate)
    ? candidate
    : `https://${candidate.replace(/^\/+/, '')}`;
  try {
    const u = new URL(withScheme);
    if (u.protocol !== 'http:' && u.protocol !== 'https:') return null;
    return u.href;
  } catch {
    return null;
  }
}

/**
 * Normalizes user-entered URLs for safe use in href. Only http/https are returned.
 * Prepends https:// when the scheme is missing. Tolerates zero-width chars, NBSP,
 * leading newlines, and a pasted line that contains an http(s) URL as a substring.
 */
export function safeHttpUrl(raw: string | null | undefined): string | null {
  const s = normalizeExternalUrlInput(String(raw ?? ''));
  if (!s) return null;
  const lowered = s.toLowerCase();
  if (
    lowered.startsWith('javascript:') ||
    lowered.startsWith('data:') ||
    lowered.startsWith('vbscript:')
  ) {
    return null;
  }

  const direct = tryParseHttpUrl(s);
  if (direct) return direct;

  const embedded = s.match(/https?:\/\/[^\s"'<>()[\]{}]+/i);
  if (embedded?.[0]) {
    return tryParseHttpUrl(embedded[0]);
  }

  return null;
}
