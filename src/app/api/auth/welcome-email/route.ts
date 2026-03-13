import { NextRequest, NextResponse } from 'next/server';
import { createClient } from '@/lib/supabase/server';
import { sendWelcomeEmail } from '@/lib/email';

/**
 * POST /api/auth/welcome-email
 * Send the post-signup welcome/reminder email once per user.
 * Body: { locale?: 'en' | 'zh' } (optional, defaults to 'en').
 */
export async function POST(req: NextRequest) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user?.email) {
    return NextResponse.json({ error: 'Unauthorised or no email' }, { status: 401 });
  }

  const { data: profile } = await supabase
    .from('profiles')
    .select('welcome_email_sent_at')
    .eq('id', user.id)
    .maybeSingle();

  if ((profile as { welcome_email_sent_at?: string } | null)?.welcome_email_sent_at) {
    return NextResponse.json({ ok: true, alreadySent: true });
  }

  let locale: 'en' | 'zh' = 'en';
  try {
    const body = await req.json();
    if (body.locale === 'zh' || body.locale === 'en') locale = body.locale;
  } catch {
    // no body or invalid JSON
  }

  const profileUrl = `${req.nextUrl.origin}/profile`;
  try {
    await sendWelcomeEmail({ to: user.email, profileUrl, locale });
  } catch (e) {
    return NextResponse.json({ error: 'Failed to send email' }, { status: 500 });
  }

  const now = new Date().toISOString();
  await supabase.from('profiles').upsert(
    { id: user.id, welcome_email_sent_at: now },
    { onConflict: 'id' }
  );

  return NextResponse.json({ ok: true });
}
