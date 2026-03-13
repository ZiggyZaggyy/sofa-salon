export interface AvatarConfig {
  skinTone: string;
  hairStyle: number;
  hairColor: string;
  topStyle: number;
  topColor: string;
  eyeExpression: 'happy' | 'sleepy' | 'excited' | 'neutral';
  accessory: 'none' | 'glasses' | 'hat';
}

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
const EXPRESSIONS: AvatarConfig['eyeExpression'][] = [
  'happy',
  'sleepy',
  'excited',
  'neutral',
];
const ACCESSORIES: AvatarConfig['accessory'][] = [
  'none',
  'none',
  'none',
  'glasses',
  'hat',
];

function pick<T>(arr: T[]): T {
  return arr[Math.floor(Math.random() * arr.length)];
}

/** Simple numeric hash of a string for deterministic picks. */
function hashSeed(seed: string): number {
  let h = 0;
  for (let i = 0; i < seed.length; i++) h = (h * 31 + seed.charCodeAt(i)) >>> 0;
  return h;
}

function pickAt<T>(arr: T[], seed: number): T {
  return arr[seed % arr.length];
}

/** Deterministic avatar config from a seed (e.g. reservation id). Use for friend fallback so friend never looks like user. */
export function avatarConfigFromSeed(seed: string): AvatarConfig {
  const h = hashSeed(seed);
  return {
    skinTone: pickAt(SKIN_TONES, h),
    hairStyle: (h % 6) + 1,
    hairColor: pickAt(HAIR_COLORS, h >>> 4),
    topStyle: (h >>> 8) % 4 + 1,
    topColor: pickAt(TOP_COLORS, h >>> 12),
    eyeExpression: pickAt(EXPRESSIONS, h >>> 16),
    accessory: pickAt(ACCESSORIES, h >>> 20),
  };
}

export function randomAvatarConfig(): AvatarConfig {
  return {
    skinTone: pick(SKIN_TONES),
    hairStyle: Math.floor(Math.random() * 6) + 1,
    hairColor: pick(HAIR_COLORS),
    topStyle: Math.floor(Math.random() * 4) + 1,
    topColor: pick(TOP_COLORS),
    eyeExpression: pick(EXPRESSIONS),
    accessory: pick(ACCESSORIES),
  };
}

export function jsonToConfig(json: unknown): AvatarConfig {
  if (json && typeof json === 'object' && !Array.isArray(json)) {
    const o = json as Record<string, unknown>;
    return {
      skinTone: typeof o.skinTone === 'string' ? o.skinTone : '#f5c5a0',
      hairStyle: typeof o.hairStyle === 'number' ? o.hairStyle : 1,
      hairColor: typeof o.hairColor === 'string' ? o.hairColor : '#111',
      topStyle: typeof o.topStyle === 'number' ? o.topStyle : 1,
      topColor: typeof o.topColor === 'string' ? o.topColor : '#2a4fd6',
      eyeExpression: EXPRESSIONS.includes(o.eyeExpression as AvatarConfig['eyeExpression'])
        ? (o.eyeExpression as AvatarConfig['eyeExpression'])
        : 'neutral',
      accessory: ACCESSORIES.includes(o.accessory as AvatarConfig['accessory'])
        ? (o.accessory as AvatarConfig['accessory'])
        : 'none',
    };
  }
  return randomAvatarConfig();
}
