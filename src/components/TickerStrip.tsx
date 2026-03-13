'use client';

import type { Locale } from '@/lib/i18n';

export type TickerSegmentItem =
  | string
  | { type: 'event'; screening_at: string; title: string };

/** Format event segment(s) in the viewer's local time (runs in browser = correct timezone). */
function formatEventSegmentStrings(
  item: { type: 'event'; screening_at: string; title: string },
  locale: Locale
): string[] {
  const { screening_at, title } = item;
  const date = new Date(screening_at);
  const timeStr = date.toLocaleTimeString('en-GB', {
    hour: '2-digit',
    minute: '2-digit',
  });
  const datePart =
    typeof screening_at === 'string' && screening_at.length >= 10
      ? screening_at.slice(0, 10) + 'T12:00:00Z'
      : screening_at;
  const dateForDisplay = new Date(datePart);
  const dateStrEn = dateForDisplay.toLocaleDateString('en-GB', {
    month: 'short',
    day: 'numeric',
    weekday: 'short',
  });
  const dateStrZh = dateForDisplay.toLocaleDateString('zh-CN', {
    month: 'long',
    day: 'numeric',
    weekday: 'short',
  });
  const isZh = locale === 'zh';
  const dateStr = isZh ? dateStrZh : dateStrEn;
  const now = new Date();
  const diffHours = Math.round((date.getTime() - now.getTime()) / 36e5);
  const diffDays = Math.round(diffHours / 24);
  const segments: string[] = [];
  if (diffHours < 3) {
    segments.push(
      isZh ? `今晚 · ${timeStr} · ${title}` : `TONIGHT · ${timeStr} · ${title}`
    );
    segments.push(isZh ? `即将开始 · ${title}` : `STARTING SOON · ${title}`);
  } else if (diffHours < 8) {
    segments.push(
      isZh ? `今天 · ${timeStr} · ${title}` : `TODAY · ${timeStr} · ${title}`
    );
  } else if (diffDays < 2) {
    segments.push(
      isZh ? `明天 · ${timeStr} · ${title}` : `TOMORROW · ${timeStr} · ${title}`
    );
  } else if (diffDays < 7) {
    segments.push(
      isZh ? `即将放映 · ${dateStr} · ${title}` : `UPCOMING · ${dateStr} · ${title}`
    );
  } else {
    segments.push(
      isZh ? `敬请期待 · ${dateStr} · ${title}` : `COMING SOON · ${dateStr} · ${title}`
    );
  }
  return segments;
}

function expandSegments(
  items: TickerSegmentItem[],
  locale: Locale
): string[] {
  const out: string[] = [];
  for (const item of items) {
    if (typeof item === 'string') {
      out.push(item);
    } else {
      out.push(...formatEventSegmentStrings(item, locale));
    }
  }
  return out;
}

interface Props {
  segmentItems: TickerSegmentItem[];
  locale: Locale;
  fallback: string[];
}

export default function TickerStrip({
  segmentItems,
  locale,
  fallback,
}: Props) {
  const allSegments =
    segmentItems.length > 0
      ? expandSegments(segmentItems, locale)
      : fallback;
  const loopSegments =
    allSegments.length > 0 ? [...allSegments, ...allSegments] : [...fallback, ...fallback];

  return (
    <div
      className="ticker-wrap"
      style={{
        overflow: 'hidden',
        whiteSpace: 'nowrap',
        userSelect: 'none',
      }}
    >
      <div className="animate-ticker" style={{ display: 'inline-block' }}>
        {loopSegments.map((seg, i) => (
          <span
            key={i}
            className="ticker-text"
            style={{
              fontSize: 12,
              letterSpacing: 2,
              textTransform: 'uppercase',
              padding: '0 40px',
            }}
          >
            {seg}
            <span style={{ opacity: 0.6, padding: '0 8px' }}>·</span>
          </span>
        ))}
      </div>
    </div>
  );
}
