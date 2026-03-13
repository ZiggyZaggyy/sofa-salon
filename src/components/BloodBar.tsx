'use client';

const SEGMENTS = 3;
const RED_FULL = '#dc2626';
const BORDER_EMPTY = '#444';

export default function BloodBar({
  noShowCount,
  segmentClassName = 'w-2 h-2.5',
  className,
  ariaLabel,
}: {
  noShowCount: number;
  segmentClassName?: string;
  className?: string;
  /** Localized name for the bar (e.g. "Blood bar" / "血条") for aria-label and screen readers */
  ariaLabel?: string;
}) {
  const full = SEGMENTS - Math.min(noShowCount, SEGMENTS);
  const label = ariaLabel ?? 'Blood bar';
  return (
    <div className={`flex gap-0.5 justify-center ${className ?? ''}`} aria-label={`${label} ${full}/${SEGMENTS}`}>
      {Array.from({ length: SEGMENTS }).map((_, i) => (
        <span
          key={i}
          className={`inline-block border ${segmentClassName}`}
          style={{
            borderRadius: 0,
            backgroundColor: i < full ? RED_FULL : 'transparent',
            borderColor: i < full ? RED_FULL : BORDER_EMPTY,
          }}
        />
      ))}
    </div>
  );
}
