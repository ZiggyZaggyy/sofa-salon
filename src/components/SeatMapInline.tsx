'use client';

import { useCallback, useEffect, useState } from 'react';
import { createClient } from '@/lib/supabase/client';
import { useLocale } from '@/components/LocaleProvider';
import type { FurniturePiece, Decoration } from '@/lib/furniture';
import SeatMap from '@/components/SeatMap';

interface Props {
  screeningId: string;
  roomId?: string | null;
}

export default function SeatMapInline({ screeningId, roomId }: Props) {
  const { t } = useLocale();
  const [refreshKey, setRefreshKey] = useState(0);
  const [data, setData] = useState<{
    room: { furniture: FurniturePiece[]; decorations: Decoration[]; canvasW: number; canvasH: number } | null;
    reservations: unknown[];
    waitlist: unknown[];
    user: { id: string } | null;
    profile: { wechat_id: string | null; is_admin?: boolean; no_show_count?: number } | null;
    squeezeNote: string | null;
    waitlistMode: 'auto' | 'manual';
    screeningTitle: string;
  } | null>(null);

  useEffect(() => {
    const supabase = createClient();
    async function load() {
      const { data: { user } } = await supabase.auth.getUser();
      const [seatmapRes, profileRes] = await Promise.all([
        fetch(`/api/screenings/${screeningId}/seatmap`, { credentials: 'include' }),
        user ? supabase.from('profiles').select('wechat_id, is_admin, no_show_count').eq('id', user.id).single() : Promise.resolve({ data: null }),
      ]);
      const profile = (profileRes as { data: unknown }).data as { wechat_id: string | null; is_admin?: boolean; no_show_count?: number } | null;

      if (!seatmapRes.ok) {
        setData({
          room: null,
          reservations: [],
          waitlist: [],
          user: user ? { id: user.id } : null,
          profile,
          squeezeNote: null,
          waitlistMode: 'auto',
          screeningTitle: '',
        });
        return;
      }

      const payload = await seatmapRes.json();
      const room = payload.room as { furniture: FurniturePiece[]; decorations: Decoration[]; canvasW: number; canvasH: number } | null;
      setData({
        room,
        reservations: payload.reservations ?? [],
        waitlist: payload.waitlist ?? [],
        user: user ? { id: user.id } : null,
        profile: profile ?? null,
        squeezeNote: payload.squeezeNote ?? null,
        waitlistMode: (payload.waitlistMode as 'auto' | 'manual') ?? 'auto',
        screeningTitle: payload.screeningTitle ?? '',
      });
    }
    load();
  }, [screeningId, refreshKey]);

  const refetchReservations = useCallback(() => {
    setRefreshKey((k) => k + 1);
  }, []);

  if (!data) {
    return (
      <div style={{ padding: '16px 0' }}>
        {[1, 2, 3].map((i) => (
          <div
            key={i}
            style={{
              height: 48,
              background: '#161616',
              border: '1px solid #2a2a2a',
              marginBottom: 8,
              position: 'relative',
              overflow: 'hidden',
            }}
          >
            <div
              style={{
                position: 'absolute',
                inset: 0,
                background:
                  'linear-gradient(90deg, transparent, rgba(232,200,74,0.03), transparent)',
                animation: 'shimmer 1.5s infinite',
              }}
            />
          </div>
        ))}
        <style>{`
          @keyframes shimmer {
            0%   { transform: translateX(-100%); }
            100% { transform: translateX(100%); }
          }
        `}</style>
      </div>
    );
  }

  if (!data.room) {
    return (
      <p className="film-meta" style={{ padding: '24px 0', textAlign: 'center' }}>
        {t.seatMap.noRoom}
      </p>
    );
  }

  return (
    <SeatMap
      screeningId={screeningId}
      screeningTitle={data.screeningTitle}
      room={data.room}
      squeezeNote={data.squeezeNote}
      initialReservations={data.reservations as Parameters<typeof SeatMap>[0]['initialReservations']}
      initialWaitlist={data.waitlist as Parameters<typeof SeatMap>[0]['initialWaitlist']}
      waitlistMode={data.waitlistMode}
      currentUser={data.user}
      currentUserProfile={data.profile}
      isAdmin={false}
      onReservationsChange={refetchReservations}
    />
  );
}
