/**
 * Admin-only: get/set current user's no_show_count and attendance_count for testing
 * 鸽王 (blood bar, pigeon) and badge display.
 */
import { createClient } from '@/lib/supabase/server';
import { NextRequest, NextResponse } from 'next/server';

export async function GET() {
  const supabase = await createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user?.id) return NextResponse.json({ error: 'Unauthorised' }, { status: 401 });
  const { data: profile } = await supabase.from('profiles').select('is_admin, no_show_count, attendance_count').eq('id', user.id).single();
  if (!profile?.is_admin) return NextResponse.json({ error: 'Forbidden' }, { status: 403 });
  return NextResponse.json({
    no_show_count: profile.no_show_count ?? 0,
    attendance_count: profile.attendance_count ?? 0,
  });
}

export async function PATCH(req: NextRequest) {
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
  const noShowCount = typeof body.no_show_count === 'number' ? Math.max(0, Math.min(3, body.no_show_count)) : undefined;
  const attendanceCount = typeof body.attendance_count === 'number' ? Math.max(0, body.attendance_count) : undefined;

  if (noShowCount === undefined && attendanceCount === undefined) {
    return NextResponse.json(
      { error: 'Provide no_show_count and/or attendance_count' },
      { status: 400 }
    );
  }

  const updates: { no_show_count?: number; attendance_count?: number; consecutive_attendances?: number } = {};
  if (noShowCount !== undefined) updates.no_show_count = noShowCount;
  if (attendanceCount !== undefined) updates.attendance_count = attendanceCount;
  updates.consecutive_attendances = 0;

  const { error } = await supabase.from('profiles').update(updates).eq('id', user.id);
  if (error) {
    return NextResponse.json({ error: error.message }, { status: 400 });
  }
  return NextResponse.json({ ok: true });
}
