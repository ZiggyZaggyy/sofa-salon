import { render } from '@testing-library/react';
import AvatarSVG from '../AvatarSVG';
import type { AvatarConfig } from '@/lib/avatar';

const BASE_CONFIG: AvatarConfig = {
  skinTone: '#d4a574',
  hairStyle: 1,
  hairColor: '#111111',
  topStyle: 1,
  topColor: '#2a4fd6',
  bottomStyle: 'jeans',
  bottomColor: '#315b96',
  eyeExpression: 'happy',
  accessory: 'none',
};

describe('AvatarSVG', () => {
  it.each([
    [1, 't-shirt'],
    [2, 'hoodie'],
    [3, 'shirt'],
    [4, 'sweater'],
  ])('renders top style %i as %s', (topStyle, styleName) => {
    const { container } = render(
      <AvatarSVG config={{ ...BASE_CONFIG, topStyle }} />
    );

    expect(
      container.querySelector(`[data-top-style="${styleName}"]`)
    ).not.toBeNull();
  });

  it.each([
    [1, 'classic-short'],
    [2, 'long-straight'],
    [3, 'side-swept'],
    [4, 'bob'],
    [5, 'short-crop'],
    [6, 'layered'],
    [7, 'short-curly'],
    [8, 'long-wavy'],
    [9, 'ponytail'],
    [10, 'bun'],
    [11, 'buzz-cut'],
    [12, 'afro'],
    [13, 'pigtails'],
    [14, 'undercut'],
  ])('renders hair style %i as %s', (hairStyle, styleName) => {
    const { container } = render(
      <AvatarSVG config={{ ...BASE_CONFIG, hairStyle }} />
    );

    expect(
      container.querySelector(`[data-hair-style="${styleName}"]`)
    ).not.toBeNull();
  });

  it.each([
    'none',
    'round-glasses',
    'baseball-cap',
    'beanie',
    'headphones',
  ] as const)('renders the %s accessory layer', (accessory) => {
    const { container } = render(
      <AvatarSVG config={{ ...BASE_CONFIG, accessory }} />
    );

    expect(
      container.querySelector(`[data-accessory="${accessory}"]`)
    ).not.toBeNull();
  });

  it.each(['stand', 'sit'] as const)(
    'renders every bottom style in the %s pose',
    (pose) => {
      for (const bottomStyle of [
        'jeans',
        'shorts',
        'skirt',
        'wide-leg',
      ] as const) {
        const { container, unmount } = render(
          <AvatarSVG config={{ ...BASE_CONFIG, bottomStyle }} pose={pose} />
        );
        expect(
          container.querySelector(`[data-bottom-style="${bottomStyle}"]`)
        ).not.toBeNull();
        unmount();
      }
    }
  );
});
