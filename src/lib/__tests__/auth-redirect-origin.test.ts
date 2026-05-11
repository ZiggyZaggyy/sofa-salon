import { getAuthRedirectOrigin } from '../auth-redirect-origin';

describe('getAuthRedirectOrigin', () => {
  it('prefers x-forwarded-host when set', () => {
    expect(
      getAuthRedirectOrigin({
        requestUrl: 'http://internal/auth/callback?code=x',
        forwardedHost: 'ziggygraph.app',
        forwardedProto: 'https',
        hostHeader: 'ziggygraph.vercel.app',
        publicAppUrl: 'https://ziggygraph.vercel.app',
      })
    ).toBe('https://ziggygraph.app');
  });

  it('uses Host header when no forwarded host', () => {
    expect(
      getAuthRedirectOrigin({
        requestUrl: 'https://ziggygraph.app/auth/callback?code=x',
        forwardedHost: null,
        forwardedProto: null,
        hostHeader: 'ziggygraph.app',
        publicAppUrl: 'https://ziggygraph.vercel.app',
      })
    ).toBe('https://ziggygraph.app');
  });

  it('uses request URL origin before NEXT_PUBLIC_APP_URL when host headers missing', () => {
    expect(
      getAuthRedirectOrigin({
        requestUrl: 'https://ziggygraph.app/auth/callback',
        forwardedHost: null,
        forwardedProto: null,
        hostHeader: null,
        publicAppUrl: 'https://ziggygraph.vercel.app',
      })
    ).toBe('https://ziggygraph.app');
  });

  it('falls back to public app URL when request URL has no usable origin', () => {
    expect(
      getAuthRedirectOrigin({
        requestUrl: 'about:blank',
        forwardedHost: null,
        forwardedProto: null,
        hostHeader: null,
        publicAppUrl: 'https://ziggygraph.vercel.app/',
      })
    ).toBe('https://ziggygraph.vercel.app');
  });
});
