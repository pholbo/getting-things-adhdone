# Things3 export (example)

Example scripts for the "your task manager" integration described across the
`start-the-day`, `surface-stale-tasks`, `prep-meeting`, and `update-tasks`
skills, for Things3 on macOS specifically. If you use a different task
manager, these aren't drop-in - swap in whatever your tool's API/export/CLI
gives you instead, keeping the same shape: a plain-text export of open items
with creation dates (and tags, for the meeting-prep step), read only, never
written back to.

Two deliberate exceptions to "never written back to", both only on an
explicit per-item yes: `link-task` appends to a task's notes field, and
`end-the-day` can add a new to-do to the Things3 Inbox (title and note only).
See those skills' own guardrails.

- `things_export.applescript` - every open to-do across all lists, tab-
  separated: group, name, due date, tags, creation date.
- `things_today.applescript` - just the Things3 "Today" list: name and
  creation date.
- `things_completed_today.applescript` - to-dos completed on a given date
  (default today; pass `YYYY-MM-DD` for another), tab-separated: group,
  name, tags, completion date. Used by `log-completed-tasks`. Edit the
  `excludedAreas` setting at the top to leave out areas such as personal
  life.
- `build_things_note.py` - turns the export's raw tab-separated output into a
  markdown note grouped by project/area, for pasting into the vault as a
  reference snapshot (optional - `start-the-day` can also just read the raw
  export directly).
- `run.sh` - wires the two together. Edit the default output path, or always
  pass your target note's path as `$1`.

Run manually, or on your own schedule (e.g. a login item or cron job) if you
want a fresh snapshot without asking Claude to run it each time.
