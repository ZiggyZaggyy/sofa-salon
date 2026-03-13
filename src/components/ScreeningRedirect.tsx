'use client';

import { useEffect } from 'react';
import { useRouter } from 'next/navigation';

const MOBILE_BREAKPOINT = 640;

interface Props {
  screeningId: string;
  isAdmin?: boolean;
  children: React.ReactNode;
}

export default function ScreeningRedirect({ screeningId, isAdmin = false, children }: Props) {
  const router = useRouter();

  useEffect(() => {
    if (typeof window === 'undefined') return;
    if (window.innerWidth < MOBILE_BREAKPOINT && !isAdmin) {
      router.replace(`/?open=${encodeURIComponent(screeningId)}`);
    }
  }, [screeningId, isAdmin, router]);

  return <>{children}</>;
}
