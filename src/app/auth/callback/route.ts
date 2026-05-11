import { getAuthRedirectOrigin } from '@/lib/auth-redirect-origin';
import { createClient } from '@/lib/supabase/server';
import { NextResponse } from 'next/server';

function getRedirectOrigin(request: Request): string {
  return getAuthRedirectOrigin({
    requestUrl: request.url,
    forwardedHost: request.headers.get('x-forwarded-host'),
    forwardedProto: request.headers.get('x-forwarded-proto'),
    hostHeader: request.headers.get('host'),
    publicAppUrl: process.env.NEXT_PUBLIC_APP_URL,
  });
}

/**
 * Auth callback: exchanges PKCE `code` for a session, then redirects to `next`.
 * Used for Google OAuth and for password-recovery links when Supabase sends users here first.
 */
export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const code = searchParams.get('code');
  const next = searchParams.get('next') ?? '/';
  const safeNext = next.startsWith('/') ? next : '/';
  const origin = getRedirectOrigin(request);

  if (code) {
    const supabase = await createClient();
    const { error } = await supabase.auth.exchangeCodeForSession(code);
    if (!error) {
      return NextResponse.redirect(`${origin}${safeNext}`);
    }
  }

  return NextResponse.redirect(`${origin}/auth/login?error=auth`);
}
