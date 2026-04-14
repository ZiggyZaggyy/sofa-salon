import Image from 'next/image';

/** User-provided assets in `public/screening-icons/`. */

export function DoubanMark({ className }: { className?: string }) {
  return (
    <Image
      src="/screening-icons/douban.png"
      alt=""
      width={24}
      height={24}
      className={`h-6 w-6 shrink-0 object-contain ${className ?? ''}`}
      aria-hidden
    />
  );
}

/** Circular crop hides square-canvas white corners on the PNG. */
export function LetterboxdMark({ className }: { className?: string }) {
  return (
    <Image
      src="/screening-icons/letterboxd.png"
      alt=""
      width={48}
      height={48}
      className={`h-full w-full object-cover object-center ${className ?? ''}`}
      aria-hidden
    />
  );
}
