-- Room background preset (host sets in "修改房间"). Default 'warm' = current look.
ALTER TABLE rooms
  ADD COLUMN IF NOT EXISTS room_background_id TEXT NOT NULL DEFAULT 'warm';
