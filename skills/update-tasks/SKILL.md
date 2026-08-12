---
name: update-tasks
description: >
  Lightweight refresh of a human-readable snapshot note mirroring your task
  manager's open to-dos, if you keep one for quick scanning. Reruns the
  export script so the note reflects current state, rather than relying on
  however stale it was last left. Standalone - use before trusting the
  snapshot note for anything. Trigger: /update-tasks, or asking to
  refresh/update tasks or the task export note.
---

# Update Tasks

## Purpose

A snapshot note is only as fresh as the last time the export script ran.
This skill exists purely to rerun that script on demand, so any check
against the note - by this skill, another skill, or the user directly - is
checking current state, not a stale copy.

This is deliberately narrow - it doesn't analyse, prioritise, or surface
stale tasks (that's `surface-stale-tasks`'s job). It just refreshes the
source of truth for anything that wants to read a readable snapshot rather
than a raw export.

## Trigger

`/update-tasks`, or asking to refresh/update tasks, the task list, or the
task export note.

## Process

1. Run your export script (e.g. `skills/things3-export/run.sh` for Things3)
   to regenerate the snapshot note from your task manager's current state.
2. Report back briefly - how many to-dos, across how many groups (most
   export scripts print this themselves), and note that the snapshot is
   current as of now.
3. Nothing else. Don't read the note's contents unless asked a follow-up
   question about what's in it - this skill's job ends at refreshing it.

## Notes on conventions

- Never edit the task manager itself, and never hand-edit the snapshot note
  - if it's regenerated wholesale each run, manual edits just get
    overwritten next time.
- If the export script fails (task manager not running, a permission not yet
  granted, etc.), report the error plainly rather than guessing at a fix.
