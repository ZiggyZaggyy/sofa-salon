import { createClient } from '@/lib/supabase/server';
import { NextRequest, NextResponse } from 'next/server';

export async function PATCH(
  req: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
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

  const { id } = await params;
  if (!id) {
    return NextResponse.json({ error: 'Reservation id required' }, { status: 400 });
  }

  const body = await req.json();
  const { attended } = body;
  if (attended !== true && attended !== false && attended !== null) {
    return NextResponse.json(
      { error: 'attended must be true, false, or null' },
      { status: 400 }
    );
  }

  const { data: reservation, error } = await supabase
    .from('reservations')
    .update({ attended: attended ?? null })
    .eq('id', id)
    .select('id, attended, user_id')
    .single();

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 400 });
  }

  const userId = reservation?.user_id;
  if (userId) {
    const { data: profile } = await supabase
      .from('profiles')
      .select('no_show_count, consecutive_attendances')
      .eq('id', userId)
      .single();

    if (attended === true) {
      const nextConsecutive = (Number(profile?.consecutive_attendances ?? 0) + 1);
      const noShow = Number(profile?.no_show_count ?? 0);
      const isPigeon = noShow >= 3;
      const updates: { consecutive_attendances: number; no_show_count?: number; attendance_count?: number } = {
        consecutive_attendances: isPigeon && nextConsecutive >= 2 ? 0 : nextConsecutive,
      };
      if (isPigeon && nextConsecutive >= 2) {
        updates.no_show_count = 0;
      }
      const { data: p } = await supabase.from('profiles').select('attendance_count').eq('id', userId).single();
      updates.attendance_count = Math.max(0, Number(p?.attendance_count ?? 0) + 1);
      await supabase.from('profiles').update(updates).eq('id', userId);
    } else if (attended === false) {
      const current = Math.min(Number(profile?.no_show_count ?? 0), 3);
      const next = Math.min(current + 1, 3);
      await supabase
        .from('profiles')
        .update({ consecutive_attendances: 0, no_show_count: next })
        .eq('id', userId);
    }
  }

  return NextResponse.json(reservation);
}
