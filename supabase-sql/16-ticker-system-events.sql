-- System-generated ticker messages for event cancelled / rescheduled.
-- Shown in ticker when show_reschedule_cancel_ticker is true; expire after a few days.
-- Run in Supabase SQL Editor once.

CREATE TABLE IF NOT EXISTS ticker_system_events (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  screening_id  UUID REFERENCES screenings(id) ON DELETE SET NULL,
  type          TEXT NOT NULL CHECK (type IN ('cancelled', 'rescheduled')),
  title         TEXT NOT NULL,
  content       TEXT NOT NULL,
  expires_at    TIMESTAMPTZ NOT NULL,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ticker_system_events_expires ON ticker_system_events(expires_at);

ALTER TABLE ticker_system_events ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read non-expired" ON ticker_system_events
  FOR SELECT USING (expires_at > NOW());

CREATE POLICY "Admin all ticker_system_events" ON ticker_system_events
  FOR ALL USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = TRUE)
  ) WITH CHECK (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND is_admin = TRUE)
  );

-- Default: show reschedule/cancel ticker (user can uncheck in admin)
INSERT INTO ticker_config (key, value) VALUES ('show_reschedule_cancel_ticker', 'true')
  ON CONFLICT (key) DO NOTHING;
