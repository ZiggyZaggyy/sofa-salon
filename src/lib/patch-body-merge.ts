/**
 * For PATCH JSON bodies: `JSON.stringify` drops keys whose values are `undefined`.
 * If a field is omitted, keep the previous DB value instead of treating it as empty.
 */
export function textFieldFromPatchOrPreserve(
  incoming: unknown,
  previous: string | null | undefined
): string {
  if (incoming !== undefined) return String(incoming ?? '');
  if (previous == null) return '';
  return String(previous);
}
