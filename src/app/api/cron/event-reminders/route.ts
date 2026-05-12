/**
 * Cron: send event reminder emails (活动提示) before screening.
 * Call with Authorization: Bearer <CRON_SECRET> or ?secret=<CRON_SECRET>.
 * Sends to users who have a reservation for a screening in the next 24h
 * and who have email_event_reminder !== false.
 */
import { NextRequest, NextResponse } from 'next/server';
import { createClient } from '@/lib/supabase/server';
import { sendReminder } from '@/lib/email';

function getCronSecret(): string | null {
  return process.env.CRON_SECRET ?? null;
}

function isAuthorized(req: NextRequest): boolean {
  const secret = getCronSecret();
  if (!secret) return false;
  const auth = req.headers.get('authorization');
  if (auth?.startsWith('Bearer ') && auth.slice(7) === secret) return true;
  const q = req.nextUrl.searchParams.get('secret');
  return q === secret;
}

export async function GET(req: NextRequest) {
  if (!isAuthorized(req)) {
    return NextResponse.json({ error: 'Unauthorised' }, { status: 401 });
  }

  const supabase = await createClient();
  const now = new Date();
  const in24h = new Date(now.getTime() + 24 * 60 * 60 * 1000);

  const { data: screenings } = await supabase
    .from('screenings')
    .select('id, title, screening_at, duration_minutes')
    .gte('screening_at', now.toISOString())
    .lte('screening_at', in24h.toISOString())
    .eq('is_active', true);

  if (!screenings?.length) {
    return NextResponse.json({ sent: 0, message: 'No screenings in next 24h' });
  }

  const admin = (await import('@/lib/supabase/admin')).createAdminClient();
  if (!admin) {
    return NextResponse.json({ error: 'Admin client not configured' }, { status: 500 });
  }

  let sent = 0;

  for (const screening of screenings) {
    const { data: reservations } = await supabase
      .from('reservations')
      .select('user_id')
      .eq('screening_id', screening.id)
      .or('is_ghost.eq(false),is_ghost.is.null');

    const userIds = Array.from(new Set((reservations ?? []).map((r: { user_id: string }) => r.user_id)));
    const screeningAt = new Date(screening.screening_at).toLocaleString();

    for (const userId of userIds) {
      const { data: userData } = await admin.auth.admin.getUserById(userId);
      const email = userData?.user?.email;
      if (!email) continue;
      try {
        await sendReminder({
          to: email,
          screeningTitle: screening.title ?? 'Screening',
          screeningAt,
          calendar: {
            screeningId: screening.id,
            screeningAtIso: new Date(screening.screening_at).toISOString(),
            durationMinutes:
              screening.duration_minutes != null
                ? Number(screening.duration_minutes)
                : null,
          },
        });
        sent++;
      } catch {
        // continue
      }
    }
  }

  return NextResponse.json({ sent, screenings: screenings.length });
}
