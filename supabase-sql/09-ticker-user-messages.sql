-- User-submitted ticker messages (弹幕). Interleaved with admin segments (e.g. 3:1).
-- Run in Supabase SQL Editor once.

CREATE TABLE IF NOT EXISTS ticker_user_messages (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  screening_id  UUID REFERENCES screenings(id) ON DELETE SET NULL,
  content       TEXT NOT NULL,
  is_active     BOOLEAN DEFAULT TRUE,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  moderated_by  UUID REFERENCES auth.users(id) ON DELETE SET NULL
);

ALTER TABLE ticker_user_messages ENABLE ROW LEVEL SECURITY;

-- User can insert own
CREATE POLICY "User insert own" ON ticker_user_messages
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Public (and Ticker) can read active only
CREATE POLICY "Public read active" ON ticker_user_messages
  FOR SELECT USING (is_active = TRUE);

-- Admin can read all and update (hide) or delete
CREATE POLICY "Admin all ticker_user_messages" ON ticker_user_messages
  FOR ALL USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = TRUE)
  ) WITH CHECK (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = TRUE)
  );

CREATE INDEX IF NOT EXISTS idx_ticker_user_messages_active_created ON ticker_user_messages(is_active, created_at DESC);
