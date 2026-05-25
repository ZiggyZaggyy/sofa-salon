-- One-off: reset blood bar / pigeon counters for all users.

UPDATE profiles
SET
  no_show_count = 0,
  consecutive_attendances = 0;
