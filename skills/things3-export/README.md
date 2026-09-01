# Things3 export (example)

Example scripts for the "your task manager" integration described across the
`start-the-day`, `surface-stale-tasks`, `prep-meeting`, and `update-tasks`
skills, for Things3 on macOS specifically. If you use a different task
manager, these aren't drop-in - swap in whatever your tool's API/export/CLI
gives you instead, keeping the same shape: a plain-text export of open items
with creation dates (and tags, for the meeting-prep step), read only, never
written back to.

(`link-task` is the one deliberate exception to "never written back to" - it
appends to a task's notes field, but only on explicit per-task request. See
that skill's own guardrails.)

- `things_export.applescript` - every open to-do across all lists, tab-
  separated: group, name, due date, tags, creation date.
- `things_today.applescript` - just the Things3 "Today" list: name and
  creation date.
- `build_things_note.py` - turns the export's raw tab-separated output into a
  markdown note grouped by project/area, for pasting into the vault as a
  reference snapshot (optional - `start-the-day` can also just read the raw
  export directly).
- `run.sh` - wires the two together. Edit the default output path, or always
  pass your target note's path as `$1`.

Run manually, or on your own schedule (e.g. a login item or cron job) if you
want a fresh snapshot without asking Claude to run it each time.
