'use client';

import { useEffect, useState } from 'react';
import { createClient } from '@/lib/supabase/client';

export default function TickerUserSubmit() {
  const [user, setUser] = useState<{ id: string } | null>(null);
  const [content, setContent] = useState('');
  const [sending, setSending] = useState(false);
  const [sent, setSent] = useState(false);

  useEffect(() => {
    const supabase = createClient();
    supabase.auth.getUser().then(({ data: { user: u } }) => setUser(u ?? null));
    supabase.auth.onAuthStateChange((_, session) => setUser(session?.user ?? null));
  }, []);

  if (!user) return null;

  const submit = async () => {
    const text = content.trim();
    if (!text || sending) return;
    setSending(true);
    try {
      const res = await fetch('/api/ticker/user', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ content: text }),
      });
      if (res.ok) {
        setContent('');
        setSent(true);
        setTimeout(() => setSent(false), 3000);
      }
    } finally {
      setSending(false);
    }
  };

  return (
    <div className="flex items-center gap-2 px-4 py-1.5 bg-[#0f0f0f] border-b border-[#2a2a2a]" style={{ borderRadius: 0 }}>
      <input
        type="text"
        value={content}
        onChange={(e) => setContent(e.target.value)}
        placeholder="Send to ticker..."
        className="flex-1 min-w-0 max-w-[200px] bg-[#1e1e1e] border border-[#2a2a2a] text-[#e8e4dc] font-mono text-[11px] px-2 py-1 outline-none focus:border-[#e8c84a]"
        style={{ borderRadius: 0 }}
        onKeyDown={(e) => e.key === 'Enter' && submit()}
      />
      <button
        type="button"
        onClick={submit}
        disabled={sending || !content.trim()}
        className="font-mono text-[10px] tracking-wider uppercase text-[#e8c84a] hover:underline disabled:opacity-50"
      >
        {sending ? '…' : sent ? 'Sent' : 'Send'}
      </button>
    </div>
  );
}
