'use client';

import React from 'react';
import type {
  AvatarAccessory,
  AvatarBottomStyle,
  AvatarConfig,
} from '@/lib/avatar';

type RectShape = [number, number, number, number];

interface HairStyle {
  back?: RectShape[];
  front: RectShape[];
}

const TOP_STYLE_NAMES: Record<number, string> = {
  1: 't-shirt',
  2: 'hoodie',
  3: 'shirt',
  4: 'sweater',
};

const HAIR_STYLE_NAMES: Record<number, string> = {
  1: 'classic-short',
  2: 'long-straight',
  3: 'side-swept',
  4: 'bob',
  5: 'short-crop',
  6: 'layered',
  7: 'short-curly',
  8: 'long-wavy',
  9: 'ponytail',
  10: 'bun',
  11: 'buzz-cut',
  12: 'afro',
  13: 'pigtails',
  14: 'undercut',
};

const HAIR_STYLES: Record<number, HairStyle> = {
  1: {
    front: [
      [12, 6, 20, 7],
      [10, 9, 4, 8],
      [30, 9, 4, 8],
    ],
  },
  2: {
    back: [
      [8, 8, 6, 24],
      [30, 8, 6, 24],
    ],
    front: [[11, 5, 22, 8]],
  },
  3: {
    front: [
      [10, 5, 24, 7],
      [10, 10, 8, 6],
      [17, 9, 15, 4],
    ],
  },
  4: {
    back: [
      [8, 7, 6, 22],
      [30, 7, 6, 22],
    ],
    front: [[10, 4, 24, 10]],
  },
  5: {
    front: [
      [12, 6, 20, 6],
      [10, 9, 6, 5],
      [28, 9, 6, 5],
    ],
  },
  6: {
    back: [
      [9, 8, 5, 18],
      [30, 8, 5, 18],
    ],
    front: [
      [12, 5, 20, 8],
      [9, 11, 7, 5],
    ],
  },
  7: {
    front: [
      [10, 7, 7, 7],
      [14, 3, 8, 8],
      [21, 2, 8, 8],
      [27, 5, 8, 8],
      [9, 12, 5, 6],
      [30, 11, 5, 7],
    ],
  },
  8: {
    back: [
      [7, 8, 7, 24],
      [30, 8, 7, 24],
      [9, 26, 7, 7],
      [28, 25, 7, 8],
    ],
    front: [
      [11, 4, 22, 8],
      [9, 10, 6, 7],
      [29, 9, 6, 7],
    ],
  },
  9: {
    back: [
      [31, 8, 8, 9],
      [34, 14, 7, 14],
      [36, 25, 5, 7],
    ],
    front: [
      [11, 5, 22, 8],
      [10, 10, 5, 7],
    ],
  },
  10: {
    back: [
      [16, 0, 12, 8],
      [13, 2, 18, 6],
    ],
    front: [
      [11, 6, 22, 8],
      [9, 10, 6, 6],
      [29, 10, 6, 6],
    ],
  },
  11: {
    front: [
      [12, 7, 20, 5],
      [10, 10, 4, 5],
      [30, 10, 4, 5],
    ],
  },
  12: {
    back: [
      [7, 4, 8, 14],
      [12, 0, 10, 11],
      [21, 0, 11, 11],
      [29, 4, 8, 14],
      [8, 14, 5, 8],
      [31, 14, 5, 8],
    ],
    front: [
      [11, 5, 22, 7],
      [9, 9, 6, 6],
      [29, 9, 6, 6],
    ],
  },
  13: {
    back: [
      [5, 9, 7, 9],
      [3, 16, 8, 10],
      [32, 9, 7, 9],
      [34, 16, 8, 10],
    ],
    front: [[11, 5, 22, 8]],
  },
  14: {
    front: [
      [12, 5, 20, 6],
      [12, 10, 14, 4],
      [28, 10, 4, 4],
      [10, 12, 4, 4],
    ],
  },
};

const EYES: Record<string, JSX.Element> = {
  happy: (
    <>
      <rect x="17" y="15" width="3" height="3" fill="#111" />
      <rect x="24" y="15" width="3" height="3" fill="#111" />
      <rect x="18" y="21" width="8" height="2" fill="#c44" />
    </>
  ),
  sleepy: (
    <>
      <rect x="17" y="16" width="3" height="2" fill="#111" />
      <rect x="24" y="16" width="3" height="2" fill="#111" />
      <rect x="19" y="21" width="6" height="1" fill="#888" />
    </>
  ),
  excited: (
    <>
      <rect x="16" y="14" width="4" height="4" fill="#111" />
      <rect x="24" y="14" width="4" height="4" fill="#111" />
      <rect x="17" y="22" width="10" height="2" fill="#c44" />
    </>
  ),
  neutral: (
    <>
      <rect x="17" y="15" width="3" height="3" fill="#111" />
      <rect x="24" y="15" width="3" height="3" fill="#111" />
      <rect x="18" y="21" width="8" height="1" fill="#888" />
    </>
  ),
};

interface Props {
  config: AvatarConfig;
  size?: number;
  pose?: 'stand' | 'sit';
  className?: string;
}

function adjustColor(hex: string, amount: number): string {
  const raw = hex.replace('#', '');
  const expanded =
    raw.length === 3
      ? raw
          .split('')
          .map((char) => `${char}${char}`)
          .join('')
      : raw;
  if (!/^[0-9a-f]{6}$/i.test(expanded)) return '#555555';

  const value = parseInt(expanded, 16);
  const channels = [value >> 16, (value >> 8) & 0xff, value & 0xff];
  return `#${channels
    .map((channel) =>
      Math.min(255, Math.max(0, channel + amount))
        .toString(16)
        .padStart(2, '0')
    )
    .join('')}`;
}

function renderRects(rects: RectShape[] | undefined, color: string) {
  return rects?.map(([x, y, width, height], index) => (
    <rect
      key={`${x}-${y}-${index}`}
      x={x}
      y={y}
      width={width}
      height={height}
      fill={color}
    />
  ));
}

function BottomLayer({
  pose,
  style,
  color,
  skinTone,
}: {
  pose: 'stand' | 'sit';
  style: AvatarBottomStyle;
  color: string;
  skinTone: string;
}) {
  const dark = adjustColor(color, -34);
  const light = adjustColor(color, 28);

  if (pose === 'sit') {
    return (
      <g data-bottom-style={style}>
        {style === 'jeans' && (
          <>
            <rect x="9" y="38" width="12" height="8" fill={color} />
            <rect x="23" y="38" width="12" height="8" fill={color} />
            <rect x="19" y="38" width="2" height="8" fill={dark} />
            <rect x="23" y="38" width="2" height="8" fill={dark} />
          </>
        )}
        {style === 'shorts' && (
          <>
            <rect x="9" y="38" width="12" height="5" fill={color} />
            <rect x="23" y="38" width="12" height="5" fill={color} />
            <rect x="12" y="43" width="8" height="4" fill={skinTone} />
            <rect x="24" y="43" width="8" height="4" fill={skinTone} />
          </>
        )}
        {style === 'skirt' && (
          <>
            <polygon points="11,37 33,37 36,45 8,45" fill={color} />
            <rect x="12" y="44" width="8" height="3" fill={skinTone} />
            <rect x="24" y="44" width="8" height="3" fill={skinTone} />
          </>
        )}
        {style === 'wide-leg' && (
          <>
            <rect x="7" y="37" width="14" height="10" fill={color} />
            <rect x="23" y="37" width="14" height="10" fill={color} />
            <rect x="8" y="38" width="2" height="8" fill={light} />
            <rect x="34" y="38" width="2" height="8" fill={dark} />
          </>
        )}
      </g>
    );
  }

  return (
    <g data-bottom-style={style}>
      {style === 'jeans' && (
        <>
          <rect x="12" y="43" width="10" height="14" fill={color} />
          <rect x="22" y="43" width="10" height="14" fill={color} />
          <rect x="20" y="46" width="2" height="11" fill={dark} />
          <rect x="24" y="45" width="2" height="10" fill={light} />
        </>
      )}
      {style === 'shorts' && (
        <>
          <rect x="11" y="43" width="11" height="8" fill={color} />
          <rect x="22" y="43" width="11" height="8" fill={color} />
          <rect x="14" y="51" width="7" height="6" fill={skinTone} />
          <rect x="23" y="51" width="7" height="6" fill={skinTone} />
        </>
      )}
      {style === 'skirt' && (
        <>
          <polygon points="12,42 32,42 35,52 9,52" fill={color} />
          <rect x="14" y="52" width="7" height="5" fill={skinTone} />
          <rect x="23" y="52" width="7" height="5" fill={skinTone} />
        </>
      )}
      {style === 'wide-leg' && (
        <>
          <rect x="9" y="43" width="13" height="15" fill={color} />
          <rect x="22" y="43" width="13" height="15" fill={color} />
          <rect x="10" y="44" width="2" height="13" fill={light} />
          <rect x="32" y="44" width="2" height="13" fill={dark} />
        </>
      )}
      <rect x="11" y="56" width="10" height="4" fill="#222" />
      <rect x="23" y="56" width="10" height="4" fill="#222" />
    </g>
  );
}

function TopLayer({
  pose,
  style,
  color,
  skinTone,
}: {
  pose: 'stand' | 'sit';
  style: number;
  color: string;
  skinTone: string;
}) {
  const normalizedStyle = TOP_STYLE_NAMES[style] ? style : 1;
  const styleName = TOP_STYLE_NAMES[normalizedStyle];
  const dark = adjustColor(color, -36);
  const light = adjustColor(color, 34);

  if (pose === 'sit') {
    return (
      <g data-top-style={styleName}>
        {normalizedStyle === 1 && (
          <>
            <rect x="14" y="28" width="16" height="14" fill={color} />
            <rect x="8" y="30" width="6" height="6" fill={color} />
            <rect x="30" y="30" width="6" height="6" fill={color} />
            <rect x="9" y="36" width="5" height="5" fill={skinTone} />
            <rect x="30" y="36" width="5" height="5" fill={skinTone} />
            <rect x="20" y="28" width="4" height="2" fill={skinTone} />
          </>
        )}
        {normalizedStyle === 2 && (
          <>
            <rect x="12" y="26" width="20" height="8" fill={dark} />
            <rect x="13" y="29" width="18" height="14" fill={color} />
            <rect x="7" y="30" width="7" height="12" fill={color} />
            <rect x="30" y="30" width="7" height="12" fill={color} />
            <rect x="17" y="37" width="10" height="4" fill={dark} />
            <rect x="19" y="29" width="1" height="5" fill={light} />
            <rect x="24" y="29" width="1" height="5" fill={light} />
          </>
        )}
        {normalizedStyle === 3 && (
          <>
            <rect x="14" y="28" width="16" height="14" fill={color} />
            <rect x="8" y="30" width="6" height="10" fill={color} />
            <rect x="30" y="30" width="6" height="10" fill={color} />
            <polygon points="17,28 21,28 21,34" fill={light} />
            <polygon points="27,28 23,28 23,34" fill={light} />
            <rect x="21" y="31" width="2" height="11" fill={dark} />
            <rect x="24" y="34" width="2" height="2" fill={light} />
            <rect x="24" y="39" width="2" height="2" fill={light} />
          </>
        )}
        {normalizedStyle === 4 && (
          <>
            <rect x="13" y="28" width="18" height="15" fill={color} />
            <rect x="7" y="30" width="7" height="12" fill={color} />
            <rect x="30" y="30" width="7" height="12" fill={color} />
            <rect x="8" y="39" width="6" height="3" fill={dark} />
            <rect x="30" y="39" width="6" height="3" fill={dark} />
            <rect x="14" y="39" width="16" height="4" fill={dark} />
            <rect x="16" y="31" width="12" height="2" fill={light} />
          </>
        )}
        <rect x="19" y="24" width="6" height="6" fill={skinTone} />
      </g>
    );
  }

  return (
    <g data-top-style={styleName}>
      {normalizedStyle === 1 && (
        <>
          <rect x="12" y="28" width="20" height="18" fill={color} />
          <rect x="7" y="29" width="7" height="8" fill={color} />
          <rect x="30" y="29" width="7" height="8" fill={color} />
          <rect x="8" y="37" width="5" height="7" fill={skinTone} />
          <rect x="31" y="37" width="5" height="7" fill={skinTone} />
          <rect x="19" y="28" width="6" height="3" fill={skinTone} />
        </>
      )}
      {normalizedStyle === 2 && (
        <>
          <rect x="11" y="25" width="22" height="10" fill={dark} />
          <rect x="12" y="29" width="20" height="18" fill={color} />
          <rect x="6" y="30" width="7" height="14" fill={color} />
          <rect x="31" y="30" width="7" height="14" fill={color} />
          <rect x="17" y="39" width="10" height="5" fill={dark} />
          <rect x="19" y="29" width="1" height="7" fill={light} />
          <rect x="24" y="29" width="1" height="7" fill={light} />
        </>
      )}
      {normalizedStyle === 3 && (
        <>
          <rect x="12" y="28" width="20" height="18" fill={color} />
          <rect x="6" y="30" width="7" height="14" fill={color} />
          <rect x="31" y="30" width="7" height="14" fill={color} />
          <polygon points="16,28 21,28 21,35" fill={light} />
          <polygon points="28,28 23,28 23,35" fill={light} />
          <rect x="21" y="32" width="2" height="14" fill={dark} />
          <rect x="25" y="36" width="2" height="2" fill={light} />
          <rect x="25" y="41" width="2" height="2" fill={light} />
        </>
      )}
      {normalizedStyle === 4 && (
        <>
          <rect x="11" y="28" width="22" height="19" fill={color} />
          <rect x="6" y="30" width="7" height="14" fill={color} />
          <rect x="31" y="30" width="7" height="14" fill={color} />
          <rect x="7" y="41" width="6" height="3" fill={dark} />
          <rect x="31" y="41" width="6" height="3" fill={dark} />
          <rect x="12" y="43" width="20" height="4" fill={dark} />
          <rect x="15" y="32" width="14" height="2" fill={light} />
        </>
      )}
      <rect x="19" y="24" width="6" height="6" fill={skinTone} />
    </g>
  );
}

function AccessoryLayer({
  accessory,
  color,
}: {
  accessory: AvatarAccessory;
  color: string;
}) {
  const dark = adjustColor(color, -44);
  const light = adjustColor(color, 42);

  return (
    <g data-accessory={accessory}>
      {accessory === 'round-glasses' && (
        <>
          <circle cx="19" cy="17" r="4" fill="none" stroke="#333" strokeWidth="1.5" />
          <circle cx="26" cy="17" r="4" fill="none" stroke="#333" strokeWidth="1.5" />
          <rect x="22" y="16" width="2" height="1" fill="#333" />
        </>
      )}
      {accessory === 'baseball-cap' && (
        <>
          <rect x="12" y="4" width="21" height="8" fill={color} />
          <rect x="15" y="2" width="15" height="4" fill={light} />
          <rect x="29" y="10" width="8" height="3" fill={dark} />
        </>
      )}
      {accessory === 'beanie' && (
        <>
          <rect x="13" y="3" width="18" height="9" fill={color} />
          <rect x="12" y="9" width="20" height="4" fill={dark} />
          <rect x="20" y="0" width="5" height="4" fill={light} />
        </>
      )}
      {accessory === 'headphones' && (
        <>
          <rect x="13" y="4" width="18" height="3" fill="#333" />
          <rect x="10" y="6" width="4" height="13" fill="#333" />
          <rect x="30" y="6" width="4" height="13" fill="#333" />
          <rect x="8" y="14" width="6" height="8" fill={color} />
          <rect x="30" y="14" width="6" height="8" fill={color} />
          <rect x="9" y="16" width="3" height="4" fill={light} />
          <rect x="32" y="16" width="3" height="4" fill={dark} />
        </>
      )}
    </g>
  );
}

function AvatarSVG({
  config,
  size = 44,
  pose = 'stand',
  className = '',
}: Props) {
  const {
    skinTone,
    hairStyle,
    hairColor,
    topStyle,
    topColor,
    bottomStyle,
    bottomColor,
    eyeExpression,
    accessory,
  } = config;
  const normalizedHairStyle = HAIR_STYLES[hairStyle] ? hairStyle : 1;
  const hair = HAIR_STYLES[normalizedHairStyle];
  const eyes = EYES[eyeExpression] ?? EYES.neutral;
  const viewHeight = pose === 'sit' ? 50 : 60;

  return (
    <svg
      viewBox={`0 0 44 ${viewHeight}`}
      width={size}
      height={Math.round((size * viewHeight) / 44)}
      className={`pixel ${className}`}
      style={{ display: 'block' }}
      aria-hidden="true"
    >
      <BottomLayer
        pose={pose}
        style={bottomStyle}
        color={bottomColor}
        skinTone={skinTone}
      />
      <TopLayer
        pose={pose}
        style={topStyle}
        color={topColor}
        skinTone={skinTone}
      />
      <g
        data-hair-style={HAIR_STYLE_NAMES[normalizedHairStyle]}
        data-hair-style-id={normalizedHairStyle}
      >
        {renderRects(hair.back, hairColor)}
      </g>
      <rect
        x={pose === 'sit' ? 14 : 12}
        y={pose === 'sit' ? 10 : 9}
        width={pose === 'sit' ? 16 : 20}
        height={pose === 'sit' ? 16 : 18}
        fill={skinTone}
      />
      <g
        data-hair-front={HAIR_STYLE_NAMES[normalizedHairStyle]}
        data-hair-style-id={normalizedHairStyle}
      >
        {renderRects(hair.front, hairColor)}
      </g>
      {eyes}
      <AccessoryLayer accessory={accessory} color={topColor} />
    </svg>
  );
}

export default React.memo(AvatarSVG);
