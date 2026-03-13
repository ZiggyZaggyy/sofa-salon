import { createClient } from '@/lib/supabase/server';
import { NextRequest, NextResponse } from 'next/server';

async function requireAdmin(supabase: Awaited<ReturnType<typeof createClient>>) {
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return { error: 'Unauthorised', status: 401 as const };
  const { data: profile } = await supabase
    .from('profiles')
    .select('is_admin')
    .eq('id', user.id)
    .single();
  if (!profile?.is_admin) return { error: 'Forbidden', status: 403 as const };
  return null;
}

export async function PATCH(
  req: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;
  const supabase = await createClient();
  const auth = await requireAdmin(supabase);
  if (auth) return NextResponse.json({ error: auth.error }, { status: auth.status });
  const body = await req.json();
  const { name, room_background_id: roomBackgroundId } = body;
  const updates: Record<string, unknown> = { updated_at: new Date().toISOString() };
  if (typeof name === 'string' && name.trim()) updates.name = name.trim();
  if (typeof roomBackgroundId === 'string' && roomBackgroundId.trim()) updates.room_background_id = roomBackgroundId.trim();
  if (Object.keys(updates).length === 1) {
    return NextResponse.json({ error: 'name or room_background_id required' }, { status: 400 });
  }
  const { data, error } = await supabase
    .from('rooms')
    .update(updates)
    .eq('id', id)
    .select()
    .single();
  if (error) return NextResponse.json({ error: error.message }, { status: 400 });
  return NextResponse.json({ room: data });
}

export async function DELETE(
  _req: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;
  const supabase = await createClient();
  const auth = await requireAdmin(supabase);
  if (auth) return NextResponse.json({ error: auth.error }, { status: auth.status });
  const { error } = await supabase.from('rooms').delete().eq('id', id);
  if (error) {
    return NextResponse.json({ error: error.message }, { status: 400 });
  }
  return NextResponse.json({ ok: true });
}
