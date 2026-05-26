import { createClient } from '@/lib/supabase/server';
import {
  listRegisteredPastScreenings,
  searchUnclaimedPastScreenings,
} from '@/lib/historical-catalog';
import { NextRequest, NextResponse } from 'next/server';

export async function GET(req: NextRequest) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json({ error: 'Unauthorised' }, { status: 401 });
  }

  const { searchParams } = new URL(req.url);
  const q = searchParams.get('q') ?? undefined;
  const limit = Number(searchParams.get('limit') ?? 30);
  const offset = Number(searchParams.get('offset') ?? 0);
  const scope = searchParams.get('scope') ?? 'unclaimed';

  if (scope === 'registered') {
    const { items, total } = await listRegisteredPastScreenings(supabase, {
      userId: user.id,
      q,
      limit: Number.isFinite(limit) ? limit : 50,
    });
    return NextResponse.json({ items, total });
  }

  const { items, total } = await searchUnclaimedPastScreenings(supabase, {
    userId: user.id,
    q,
    limit: Number.isFinite(limit) ? limit : 30,
    offset: Number.isFinite(offset) ? offset : 0,
  });

  return NextResponse.json({ items, total });
}
