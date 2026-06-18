export type AvatarAccessory =
  | 'none'
  | 'round-glasses'
  | 'baseball-cap'
  | 'beanie'
  | 'headphones';

export type AvatarBottomStyle = 'jeans' | 'shorts' | 'skirt' | 'wide-leg';

export interface AvatarConfig {
  skinTone: string;
  hairStyle: number;
  hairColor: string;
  topStyle: number;
  topColor: string;
  bottomStyle: AvatarBottomStyle;
  bottomColor: string;
  eyeExpression: 'happy' | 'sleepy' | 'excited' | 'neutral';
  accessory: AvatarAccessory;
}

export const HAIR_STYLE_COUNT = 14;
export const TOP_STYLE_COUNT = 4;

const SKIN_TONES = [
  '#f5c5a0',
  '#d4a574',
  '#c8a880',
  '#a0724a',
  '#7d4e2d',
  '#f5deb3',
];
const HAIR_COLORS = [
  '#111111',
  '#3a1a00',
  '#8B4513',
  '#DAA520',
  '#FF6B6B',
  '#4169E1',
  '#9370DB',
];
const TOP_COLORS = [
  '#2a4fd6',
  '#e87cb5',
  '#3ab87a',
  '#e8c84a',
  '#7c3ad6',
  '#d63a2f',
  '#e8824a',
];
const BOTTOM_COLORS = [
  '#315b96',
  '#27364f',
  '#4d4f58',
  '#63734a',
  '#7a3f54',
  '#92724f',
];
const EXPRESSIONS: AvatarConfig['eyeExpression'][] = [
  'happy',
  'sleepy',
  'excited',
  'neutral',
];
const ACCESSORIES: AvatarConfig['accessory'][] = [
  'none',
  'none',
  'round-glasses',
  'baseball-cap',
  'beanie',
  'headphones',
];
const BOTTOM_STYLES: AvatarBottomStyle[] = [
  'jeans',
  'shorts',
  'skirt',
  'wide-leg',
];

function pick<T>(arr: readonly T[]): T {
  return arr[Math.floor(Math.random() * arr.length)];
}

/** Simple numeric hash of a string for deterministic picks. */
function hashSeed(seed: string): number {
  let h = 0;
  for (let i = 0; i < seed.length; i++) h = (h * 31 + seed.charCodeAt(i)) >>> 0;
  return h;
}

function pickAt<T>(arr: readonly T[], seed: number): T {
  return arr[seed % arr.length];
}

/** Deterministic avatar config from a seed (e.g. reservation id). Use for friend fallback so friend never looks like user. */
export function avatarConfigFromSeed(seed: string): AvatarConfig {
  const h = hashSeed(seed);
  return {
    skinTone: pickAt(SKIN_TONES, h),
    hairStyle: ((h >>> 3) % HAIR_STYLE_COUNT) + 1,
    hairColor: pickAt(HAIR_COLORS, h >>> 7),
    topStyle: ((h >>> 11) % TOP_STYLE_COUNT) + 1,
    topColor: pickAt(TOP_COLORS, h >>> 13),
    bottomStyle: pickAt(BOTTOM_STYLES, h >>> 17),
    bottomColor: pickAt(BOTTOM_COLORS, h >>> 19),
    eyeExpression: pickAt(EXPRESSIONS, h >>> 23),
    accessory: pickAt(ACCESSORIES, h >>> 27),
  };
}

export function randomAvatarConfig(): AvatarConfig {
  return {
    skinTone: pick(SKIN_TONES),
    hairStyle: Math.floor(Math.random() * HAIR_STYLE_COUNT) + 1,
    hairColor: pick(HAIR_COLORS),
    topStyle: Math.floor(Math.random() * TOP_STYLE_COUNT) + 1,
    topColor: pick(TOP_COLORS),
    bottomStyle: pick(BOTTOM_STYLES),
    bottomColor: pick(BOTTOM_COLORS),
    eyeExpression: pick(EXPRESSIONS),
    accessory: pick(ACCESSORIES),
  };
}

function numberInRange(value: unknown, min: number, max: number, fallback: number): number {
  return typeof value === 'number' &&
    Number.isInteger(value) &&
    value >= min &&
    value <= max
    ? value
    : fallback;
}

function normalizeAccessory(value: unknown): AvatarAccessory {
  if (value === 'glasses') return 'round-glasses';
  if (value === 'hat') return 'baseball-cap';
  return ACCESSORIES.includes(value as AvatarAccessory)
    ? (value as AvatarAccessory)
    : 'none';
}

export function jsonToConfig(json: unknown): AvatarConfig {
  if (json && typeof json === 'object' && !Array.isArray(json)) {
    const o = json as Record<string, unknown>;
    return {
      skinTone: typeof o.skinTone === 'string' ? o.skinTone : '#f5c5a0',
      hairStyle: numberInRange(o.hairStyle, 1, HAIR_STYLE_COUNT, 1),
      hairColor: typeof o.hairColor === 'string' ? o.hairColor : '#111',
      topStyle: numberInRange(o.topStyle, 1, TOP_STYLE_COUNT, 1),
      topColor: typeof o.topColor === 'string' ? o.topColor : '#2a4fd6',
      bottomStyle: BOTTOM_STYLES.includes(o.bottomStyle as AvatarBottomStyle)
        ? (o.bottomStyle as AvatarBottomStyle)
        : 'jeans',
      bottomColor: typeof o.bottomColor === 'string' ? o.bottomColor : '#315b96',
      eyeExpression: EXPRESSIONS.includes(o.eyeExpression as AvatarConfig['eyeExpression'])
        ? (o.eyeExpression as AvatarConfig['eyeExpression'])
        : 'neutral',
      accessory: normalizeAccessory(o.accessory),
    };
  }
  return randomAvatarConfig();
}
