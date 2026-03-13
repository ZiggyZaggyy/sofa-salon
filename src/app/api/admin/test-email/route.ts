/**
 * Admin-only: send a test email to the current admin's email.
 * POST body: { type: 'welcome' | 'reminder' | 'waitlist_promotion' | 'post_event_rating' }
 */
import { NextRequest, NextResponse } from 'next/server';
import { createClient } from '@/lib/supabase/server';
import {
  sendWelcomeEmail,
  sendReminder,
  sendWaitlistPromotion,
  sendPostEventRatingReminder,
} from '@/lib/email';

export async function POST(req: NextRequest) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user?.id) {
    return NextResponse.json({ error: 'Unauthorised' }, { status: 401 });
  }
  const { data: profile } = await supabase
    .from('profiles')
    .select('is_admin')
    .eq('id', user.id)
    .single();
  if (!profile?.is_admin) {
    return NextResponse.json({ error: 'Forbidden' }, { status: 403 });
  }
  const email = user.email;
  if (!email) {
    return NextResponse.json({ error: 'No email on your account' }, { status: 400 });
  }

  let body: { type?: string } = {};
  try {
    body = await req.json();
  } catch {
    // no body
  }
  const type = body.type;
  if (!type || !['welcome', 'reminder', 'waitlist_promotion', 'post_event_rating'].includes(type)) {
    return NextResponse.json(
      { error: 'body.type required: welcome | reminder | waitlist_promotion | post_event_rating' },
      { status: 400 }
    );
  }

  const origin = req.nextUrl.origin;
  const profileUrl = `${origin}/profile`;
  const sampleTitle = 'Test Screening — 测试放映';
  const sampleAt = new Date(Date.now() + 24 * 60 * 60 * 1000).toLocaleString();
  const sampleSeat = 'sofa-0-seat-1';

  try {
    if (type === 'welcome') {
      await sendWelcomeEmail({
        to: email,
        profileUrl,
        locale: 'en',
      });
    } else if (type === 'reminder') {
      await sendReminder({
        to: email,
        screeningTitle: sampleTitle,
        screeningAt: sampleAt,
      });
    } else if (type === 'waitlist_promotion') {
      await sendWaitlistPromotion({
        to: email,
        screeningTitle: sampleTitle,
        seatKey: sampleSeat,
        screeningAt: sampleAt,
      });
    } else if (type === 'post_event_rating') {
      await sendPostEventRatingReminder({
        to: email,
        screeningTitle: sampleTitle,
        profileUrl,
      });
    }
  } catch (e) {
    return NextResponse.json(
      { error: e instanceof Error ? e.message : 'Failed to send email' },
      { status: 500 }
    );
  }

  return NextResponse.json({ ok: true });
}
