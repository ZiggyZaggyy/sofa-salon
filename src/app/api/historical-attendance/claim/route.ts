import { createClient } from '@/lib/supabase/server';
import {
  claimCatalogScreenings,
  MAX_CLAIM_SCREENINGS_PER_REQUEST,
} from '@/lib/historical-catalog';
import { NextRequest, NextResponse } from 'next/server';

export async function POST(req: NextRequest) {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return NextResponse.json({ error: 'Unauthorised' }, { status: 401 });
  }

  const body = await req.json();
  const screeningId = typeof body.screeningId === 'string' ? body.screeningId : null;
  const screeningIds = Array.isArray(body.screeningIds)
    ? body.screeningIds.filter((id: unknown) => typeof id === 'string')
    : screeningId
      ? [screeningId]
      : [];

  if (screeningIds.length === 0) {
    return NextResponse.json({ error: 'screeningId or screeningIds required' }, { status: 400 });
  }
  if (screeningIds.length > MAX_CLAIM_SCREENINGS_PER_REQUEST) {
    return NextResponse.json(
      { error: `At most ${MAX_CLAIM_SCREENINGS_PER_REQUEST} screenings per request` },
      { status: 400 }
    );
  }

  const results = await claimCatalogScreenings(supabase, user.id, screeningIds);
  const claimed = results.filter((r) => r.ok).length;
  const failed = results.filter((r) => !r.ok);

  return NextResponse.json({
    ok: failed.length === 0,
    claimed,
    results,
  });
}
