'use client';

import { useRouter } from 'next/navigation';

interface Props {
  children: React.ReactNode;
  className?: string;
}

/** Back button that uses browser history (previous page) instead of a fixed URL. */
export default function BackButton({ children, className }: Props) {
  const router = useRouter();
  return (
    <button
      type="button"
      onClick={() => router.back()}
      className={className ?? 'font-mono text-[10px] tracking-[0.2em] uppercase text-[#888888] hover:text-[#e8c84a] inline-block transition-colors bg-transparent border-0 cursor-pointer p-0'}
    >
      {children}
    </button>
  );
}
