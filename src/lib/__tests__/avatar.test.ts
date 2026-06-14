/**
 * Unit tests for lib/avatar.ts - avatar config generation and JSON parsing.
 */
import {
  avatarConfigFromSeed,
  HAIR_STYLE_COUNT,
  jsonToConfig,
  randomAvatarConfig,
  TOP_STYLE_COUNT,
} from '../avatar';

const VALID_ACCESSORIES = [
  'none',
  'round-glasses',
  'baseball-cap',
  'beanie',
  'headphones',
];
const VALID_BOTTOM_STYLES = ['jeans', 'shorts', 'skirt', 'wide-leg'];

describe('avatarConfigFromSeed', () => {
  it('returns the same config for the same seed', () => {
    const a = avatarConfigFromSeed('user-1');
    const b = avatarConfigFromSeed('user-1');
    expect(a).toEqual(b);
  });

  it('returns a different config for a different seed', () => {
    const a = avatarConfigFromSeed('user-1');
    const b = avatarConfigFromSeed('user-2');
    expect(a).not.toEqual(b);
  });

  it('returns values from every supported style range', () => {
    const config = avatarConfigFromSeed('any');
    expect(config.hairStyle).toBeGreaterThanOrEqual(1);
    expect(config.hairStyle).toBeLessThanOrEqual(HAIR_STYLE_COUNT);
    expect(config.topStyle).toBeGreaterThanOrEqual(1);
    expect(config.topStyle).toBeLessThanOrEqual(TOP_STYLE_COUNT);
    expect(['happy', 'sleepy', 'excited', 'neutral']).toContain(
      config.eyeExpression
    );
    expect(VALID_ACCESSORIES).toContain(config.accessory);
    expect(VALID_BOTTOM_STYLES).toContain(config.bottomStyle);
    expect(config.bottomColor).toMatch(/^#[0-9a-f]{6}$/i);
  });
});

describe('randomAvatarConfig', () => {
  it('returns a complete renderable config', () => {
    const config = randomAvatarConfig();
    expect(config.hairStyle).toBeGreaterThanOrEqual(1);
    expect(config.hairStyle).toBeLessThanOrEqual(HAIR_STYLE_COUNT);
    expect(config.topStyle).toBeGreaterThanOrEqual(1);
    expect(config.topStyle).toBeLessThanOrEqual(TOP_STYLE_COUNT);
    expect(VALID_ACCESSORIES).toContain(config.accessory);
    expect(VALID_BOTTOM_STYLES).toContain(config.bottomStyle);
    expect(config.bottomColor).toBeDefined();
  });
});

describe('jsonToConfig', () => {
  it('parses a valid object to AvatarConfig', () => {
    const json = {
      skinTone: '#aabbcc',
      hairStyle: 9,
      hairColor: '#111111',
      topStyle: 2,
      topColor: '#2a4fd6',
      bottomStyle: 'wide-leg',
      bottomColor: '#27364f',
      eyeExpression: 'happy',
      accessory: 'headphones',
    };
    const config = jsonToConfig(json);
    expect(config).toEqual(json);
  });

  it('uses defaults for missing or invalid fields', () => {
    const config = jsonToConfig({
      hairStyle: 99,
      topStyle: 0,
      bottomStyle: 'invalid',
    });
    expect(config.skinTone).toBe('#f5c5a0');
    expect(config.hairStyle).toBe(1);
    expect(config.topStyle).toBe(1);
    expect(config.bottomStyle).toBe('jeans');
    expect(config.bottomColor).toBe('#315b96');
    expect(config.eyeExpression).toBe('neutral');
    expect(config.accessory).toBe('none');
  });

  it('maps legacy accessories and fills the new bottom fields', () => {
    const glasses = jsonToConfig({ accessory: 'glasses' });
    const hat = jsonToConfig({ accessory: 'hat' });

    expect(glasses.accessory).toBe('round-glasses');
    expect(hat.accessory).toBe('baseball-cap');
    expect(glasses.bottomStyle).toBe('jeans');
    expect(glasses.bottomColor).toBe('#315b96');
  });

  it('rejects an invalid eyeExpression and falls back to neutral', () => {
    const config = jsonToConfig({ eyeExpression: 'invalid' });
    expect(config.eyeExpression).toBe('neutral');
  });

  it('returns a complete config for non-object input', () => {
    const config = jsonToConfig(null);
    expect(config.skinTone).toBeDefined();
    expect(config.bottomStyle).toBeDefined();
    expect(config.bottomColor).toBeDefined();
  });
});
