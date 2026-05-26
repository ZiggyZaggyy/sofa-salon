import { createHash } from 'crypto';

/** Deterministic UUID from sheet date + title (same as migration 37 seed). */
export function stableScreeningId(sheetDateDot, title) {
  const hex = createHash('sha256').update(`ziggygraph-catalog|${sheetDateDot}|${title}`).digest('hex');
  return [
    hex.slice(0, 8),
    hex.slice(8, 12),
    '4' + hex.slice(13, 16),
    ((parseInt(hex.slice(16, 18), 16) & 0x3f) | 0x80).toString(16).padStart(2, '0') + hex.slice(18, 20),
    hex.slice(20, 32),
  ].join('-');
}
