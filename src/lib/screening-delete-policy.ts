/**
 * When deleting a screening, past events should not trigger cancellation emails
 * or a “cancelled” ticker line (only meaningful for upcoming screenings).
 */
export function screeningDeleteSkipsCancellationNotify(
  screeningAtIso: string,
  nowMs: number = Date.now()
): boolean {
  const t = new Date(screeningAtIso).getTime();
  if (Number.isNaN(t)) return false;
  return t < nowMs;
}
