import { createClient } from '@/lib/supabase/server';
import { NextRequest, NextResponse } from 'next/server';
import { sendEventCancelled, sendEventRescheduled } from '@/lib/email';

const TICKER_EXPIRY_DAYS = 3;

export async function DELETE(
  req: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;
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

  const body = await req.json().catch(() => ({}));
  const confirm = body.confirm === true;

  const { data: screening } = await supabase
    .from('screenings')
    .select('id, title')
    .eq('id', id)
    .single();
  if (!screening) {
    return NextResponse.json({ error: 'Screening not found' }, { status: 404 });
  }

  const [{ data: reservations }, { data: waitlist }] = await Promise.all([
    supabase.from('reservations').select('user_id').eq('screening_id', id),
    supabase.from('waitlist').select('user_id').eq('screening_id', id).eq('status', 'waiting'),
  ]);
  const userIds = new Set<string>();
  for (const r of reservations ?? []) userIds.add((r as { user_id: string }).user_id);
  for (const w of waitlist ?? []) userIds.add((w as { user_id: string }).user_id);
  const totalAffected = userIds.size;

  if (totalAffected > 0 && !confirm) {
    return NextResponse.json({
      hasRegistrations: true,
      count: totalAffected,
      message: 'Confirm delete to notify all registered users and cancel the event.',
    });
  }

  const admin = (await import('@/lib/supabase/admin')).createAdminClient();
  const emails: string[] = [];
  if (admin && userIds.size > 0) {
    for (const uid of Array.from(userIds)) {
      const { data: u } = await admin.auth.admin.getUserById(uid);
      if (u?.user?.email) emails.push(u.user.email);
    }
  }

  for (const email of emails) {
    try {
      await sendEventCancelled({ to: email, screeningTitle: (screening as { title: string }).title });
    } catch {
      // continue
    }
  }

  const expiresAt = new Date();
  expiresAt.setDate(expiresAt.getDate() + TICKER_EXPIRY_DAYS);
  await supabase.from('ticker_system_events').insert({
    screening_id: id,
    type: 'cancelled',
    title: (screening as { title: string }).title,
    content: (screening as { title: string }).title,
    expires_at: expiresAt.toISOString(),
  });

  await supabase.from('waitlist').delete().eq('screening_id', id);
  await supabase.from('reservations').delete().eq('screening_id', id);
  const { error: delError } = await supabase.from('screenings').delete().eq('id', id);
  if (delError) {
    return NextResponse.json({ error: delError.message }, { status: 400 });
  }
  return NextResponse.json({ ok: true, deleted: true });
}

export async function PATCH(
  req: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;
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

  const body = await req.json();
  const {
    title,
    description,
    screening_at,
    room_id,
    squeeze_note,
    waitlist_mode,
    year,
    director,
    duration_minutes,
    is_active,
  } = body;

  if (!title || !screening_at) {
    return NextResponse.json(
      { error: 'title and screening_at required' },
      { status: 400 }
    );
  }

  const { data: existing } = await supabase
    .from('screenings')
    .select('screening_at, title')
    .eq('id', id)
    .single();
  const previousAt = existing?.screening_at ? new Date((existing as { screening_at: string }).screening_at).getTime() : null;
  const newAt = new Date(screening_at).getTime();
  const rescheduled = previousAt != null && previousAt !== newAt;

  const updates: Record<string, unknown> = {
    title,
    description: description ?? '',
    screening_at,
    room_id: room_id ?? null,
    squeeze_note: squeeze_note ?? '',
    waitlist_mode: waitlist_mode ?? 'auto',
    year: year != null ? Number(year) : null,
    director: director ?? '',
    duration_minutes: duration_minutes != null ? Number(duration_minutes) : null,
  };
  if (typeof is_active === 'boolean') updates.is_active = is_active;

  const { data, error } = await supabase
    .from('screenings')
    .update(updates)
    .eq('id', id)
    .select()
    .single();

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 400 });
  }

  if (rescheduled) {
    const screeningTitle = (existing as { title: string })?.title ?? title;
    const [{ data: reservations }] = await Promise.all([
      supabase.from('reservations').select('user_id').eq('screening_id', id),
    ]);
    const userIds = new Set<string>();
    for (const r of reservations ?? []) userIds.add((r as { user_id: string }).user_id);
    const admin = (await import('@/lib/supabase/admin')).createAdminClient();
    const emails: string[] = [];
    if (admin && userIds.size > 0) {
      for (const uid of Array.from(userIds)) {
        const { data: u } = await admin.auth.admin.getUserById(uid);
        if (u?.user?.email) emails.push(u.user.email);
      }
    }
    const screeningAtStr = new Date(screening_at).toLocaleString();
    for (const email of emails) {
      try {
        await sendEventRescheduled({ to: email, screeningTitle, screeningAt: screeningAtStr });
      } catch {
        // continue
      }
    }
    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + TICKER_EXPIRY_DAYS);
    await supabase.from('ticker_system_events').insert({
      screening_id: id,
      type: 'rescheduled',
      title: screeningTitle,
      content: screeningTitle,
      expires_at: expiresAt.toISOString(),
    });
  }

  return NextResponse.json({ screening: data });
}
