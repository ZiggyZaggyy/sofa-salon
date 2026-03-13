import { createClient } from '@/lib/supabase/server';
import { NextResponse } from 'next/server';

export async function GET() {
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

  const admin = (await import('@/lib/supabase/admin')).createAdminClient();
  const client = admin ?? supabase;
  const { data: rows, error } = await client
    .from('ticker_user_messages')
    .select('id, content, is_active, created_at, user_id')
    .order('created_at', { ascending: false })
    .limit(100);

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  const list = (rows ?? []) as Array<{ id: string; content: string; is_active: boolean; created_at: string; user_id: string }>;
  const userIds = Array.from(new Set(list.map((r) => r.user_id).filter(Boolean)));
  let displayNames: Record<string, string> = {};
  if (userIds.length > 0) {
    const { data: profiles } = await client.from('profiles').select('id, display_name').in('id', userIds);
    for (const p of profiles ?? []) {
      const row = p as { id: string; display_name: string | null };
      if (row.display_name) displayNames[row.id] = row.display_name;
    }
  }

  const result = list.map((r) => ({
    id: r.id,
    content: r.content,
    is_active: r.is_active,
    created_at: r.created_at,
    profiles: { display_name: displayNames[r.user_id] ?? null },
  }));
  return NextResponse.json(result);
}
