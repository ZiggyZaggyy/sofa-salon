/**
 * Origin used after `/auth/callback` exchanges a PKCE code. Must match the host the user
 * actually used (e.g. ziggygraph.app) instead of NEXT_PUBLIC_APP_URL when both exist—otherwise
 * OAuth / recovery redirects jump to *.vercel.app.
 */
export function getAuthRedirectOrigin(input: {
  requestUrl: string;
  forwardedHost: string | null | undefined;
  forwardedProto: string | null | undefined;
  hostHeader: string | null | undefined;
  /** Last resort only (e.g. misconfigured Host behind edge proxies). */
  publicAppUrl: string | undefined;
}): string {
  const url = new URL(input.requestUrl);
  const fh = input.forwardedHost?.split(',')[0]?.trim();
  const fp = input.forwardedProto?.split(',')[0]?.trim();
  const defaultProto =
    fp || (url.protocol === 'https:' ? 'https' : url.protocol.replace(':', '') || 'https');

  if (fh) {
    return `${defaultProto}://${fh}`;
  }

  const host = input.hostHeader?.trim();
  if (host) {
    return `${defaultProto}://${host}`;
  }

  if (url.protocol === 'http:' || url.protocol === 'https:') {
    if (url.host) {
      return url.origin;
    }
  }

  const fallback = input.publicAppUrl?.trim();
  if (fallback) {
    return fallback.replace(/\/$/, '');
  }

  return url.origin && url.origin !== 'null' ? url.origin : 'http://localhost:3000';
}
