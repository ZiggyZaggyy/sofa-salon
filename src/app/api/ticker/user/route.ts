import { createClient } from '@/lib/supabase/server';
import { NextRequest, NextResponse } from 'next/server';

export async function POST(req: NextRequest) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user?.id) {
    return NextResponse.json({ error: 'Unauthorised' }, { status: 401 });
  }

  const body = await req.json();
  const content = typeof body?.content === 'string' ? body.content.trim() : '';
  if (!content) {
    return NextResponse.json({ error: 'content required' }, { status: 400 });
  }

  // Use service role so insert always succeeds (avoids RLS/cookie issues in server context)
  const admin = (await import('@/lib/supabase/admin')).createAdminClient();
  const client = admin ?? supabase;
  const { data, error } = await client
    .from('ticker_user_messages')
    .insert({ user_id: user.id, content, is_active: true })
    .select('id, content, created_at')
    .single();

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 400 });
  }
  return NextResponse.json(data);
}
