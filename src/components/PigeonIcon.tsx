'use client';

/**
 * Pixel-art pigeon SVG (鸽子), side view. Blocky retro style — a slightly chubby pigeon.
 * Palette: slate body, light grey highlight, dark purple-grey outline, yellow-gold eye/feet.
 */
const PIXEL = 1;
const VB_W = 24;
const VB_H = 26;

const COL = {
  body: '#8B9EA8',
  light: '#D8DEE1',
  dark: '#5D637D',
  gold: '#E0B050',
  pupil: '#3B3D4D',
};

export default function PigeonIcon({
  size = 24,
  className,
  title = 'Pigeon',
}: {
  size?: number;
  className?: string;
  title?: string;
}) {
  const h = Math.round((size * VB_H) / VB_W);
  return (
    <svg
      width={size}
      height={h}
      viewBox={`0 0 ${VB_W} ${VB_H}`}
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      className={className}
      aria-hidden="true"
    >
      <title>{title}</title>
      {/* Pixel grid: each rect is 1x1. Pigeon faces right; x increases to the right, y down. */}

      {/* Tail (dark) — shifted down +3 */}
      <rect x={2} y={13} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={3} y={13} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={4} y={13} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={2} y={14} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={3} y={14} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={4} y={14} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={3} y={15} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={4} y={15} width={PIXEL} height={PIXEL} fill={COL.dark} />

      {/* Body outline / wing shadow (dark) — fatter body outline */}
      <rect x={5} y={12} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={6} y={12} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={7} y={12} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={5} y={17} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={6} y={17} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={7} y={17} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={17} y={17} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={18} y={17} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={19} y={17} width={PIXEL} height={PIXEL} fill={COL.dark} />

      {/* Body main — chubbier: more rows + wider belly */}
      <rect x={6} y={13} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={7} y={13} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={8} y={13} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={9} y={13} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={10} y={13} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={11} y={13} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={12} y={13} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={13} y={13} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={14} y={13} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={15} y={13} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={16} y={13} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={17} y={13} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={18} y={13} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={5} y={14} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={6} y={14} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={7} y={14} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={8} y={14} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={9} y={14} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={10} y={14} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={11} y={14} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={12} y={14} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={13} y={14} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={14} y={14} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={15} y={14} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={16} y={14} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={17} y={14} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={18} y={14} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={19} y={14} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={6} y={15} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={7} y={15} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={8} y={15} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={9} y={15} width={PIXEL} height={PIXEL} fill={COL.light} />
      <rect x={10} y={15} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={11} y={15} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={12} y={15} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={13} y={15} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={14} y={15} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={15} y={15} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={16} y={15} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={17} y={15} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={18} y={15} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={19} y={15} width={PIXEL} height={PIXEL} fill={COL.body} />
      {/* Extra belly row — chubby */}
      <rect x={5} y={16} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={6} y={16} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={7} y={16} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={8} y={16} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={9} y={16} width={PIXEL} height={PIXEL} fill={COL.light} />
      <rect x={10} y={16} width={PIXEL} height={PIXEL} fill={COL.light} />
      <rect x={11} y={16} width={PIXEL} height={PIXEL} fill={COL.light} />
      <rect x={12} y={16} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={13} y={16} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={14} y={16} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={15} y={16} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={16} y={16} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={17} y={16} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={18} y={16} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={19} y={16} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={7} y={17} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={8} y={17} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={9} y={17} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={10} y={17} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={11} y={17} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={12} y={17} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={13} y={17} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={14} y={17} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={15} y={17} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={16} y={17} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={17} y={17} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={18} y={17} width={PIXEL} height={PIXEL} fill={COL.body} />

      {/* Head (rounded) — shifted down +3 */}
      <rect x={16} y={10} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={17} y={10} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={18} y={10} width={PIXEL} height={PIXEL} fill={COL.light} />
      <rect x={19} y={10} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={20} y={10} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={17} y={11} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={18} y={11} width={PIXEL} height={PIXEL} fill={COL.gold} />
      <rect x={19} y={11} width={PIXEL} height={PIXEL} fill={COL.pupil} />
      <rect x={20} y={11} width={PIXEL} height={PIXEL} fill={COL.gold} />
      <rect x={21} y={11} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={18} y={12} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={19} y={12} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={20} y={12} width={PIXEL} height={PIXEL} fill={COL.gold} />
      <rect x={21} y={12} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={22} y={12} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={19} y={13} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={20} y={13} width={PIXEL} height={PIXEL} fill={COL.body} />
      <rect x={21} y={13} width={PIXEL} height={PIXEL} fill={COL.dark} />

      {/* Beak tip */}
      <rect x={22} y={13} width={PIXEL} height={PIXEL} fill={COL.dark} />

      {/* Legs (dark) — shifted down +3 */}
      <rect x={10} y={18} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={11} y={18} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={13} y={18} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={14} y={18} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={10} y={19} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={11} y={19} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={13} y={19} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={14} y={19} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={10} y={20} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={11} y={20} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={13} y={20} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={14} y={20} width={PIXEL} height={PIXEL} fill={COL.dark} />

      {/* Feet (gold) — shifted down +3 */}
      <rect x={9} y={21} width={PIXEL} height={PIXEL} fill={COL.dark} />
      <rect x={10} y={21} width={PIXEL} height={PIXEL} fill={COL.gold} />
      <rect x={11} y={21} width={PIXEL} height={PIXEL} fill={COL.gold} />
      <rect x={12} y={21} width={PIXEL} height={PIXEL} fill={COL.gold} />
      <rect x={13} y={21} width={PIXEL} height={PIXEL} fill={COL.gold} />
      <rect x={14} y={21} width={PIXEL} height={PIXEL} fill={COL.gold} />
      <rect x={15} y={21} width={PIXEL} height={PIXEL} fill={COL.gold} />
      <rect x={16} y={21} width={PIXEL} height={PIXEL} fill={COL.dark} />
    </svg>
  );
}
