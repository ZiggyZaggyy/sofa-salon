'use client';

import { useLocale } from '@/components/LocaleProvider';
import { screeningDisplayDirector, screeningDisplayTitle } from '@/lib/screening-display';

interface Props {
  title: string;
  titleEn?: string | null;
  year?: number | null;
  director?: string | null;
  directorEn?: string | null;
  durationMinutes?: number | null;
}

export default function ScreeningFilmHeading({
  title,
  titleEn,
  year,
  director,
  directorEn,
  durationMinutes,
}: Props) {
  const { locale } = useLocale();
  const displayTitle = screeningDisplayTitle(locale, title, titleEn);
  const displayDirector = screeningDisplayDirector(locale, director, directorEn);
  const filmMetaParts = [
    year,
    displayDirector || null,
    durationMinutes != null ? `${durationMinutes} min` : null,
  ].filter(Boolean) as string[];

  return (
    <>
      <h1 className="font-pixel-cjk text-lg md:text-xl text-[#e8c84a] mb-0.5">{displayTitle}</h1>
      {filmMetaParts.length > 0 && (
        <p className="font-mono text-[11px] text-[#888888] mb-2 tracking-wide">
          {filmMetaParts.join(' · ')}
        </p>
      )}
    </>
  );
}
