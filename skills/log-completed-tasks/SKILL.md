---
name: log-completed-tasks
description: >
  Pulls the tasks your task manager shows as completed on a given date
  (default: today), optionally excluding an area such as personal life, and
  writes them as a plain bullet list under a "Completed today" (or
  "Completed <date>") heading in that date's Daily note. Purely factual - not
  a brag-list pass (that's suggest-brag-items's job) and not treated as the
  full record of what got done, since not everything finished goes through
  the task manager. Standalone, or run as a step from end-the-day. Trigger:
  /log-completed-tasks, or asking what you completed today (or on a date).
---

# Log Completed Tasks

## Purpose

A task manager's completed list (Things3 calls it the Logbook) holds
everything marked done, but nothing surfaces it back into the vault. This
skill pulls that day's completions into the Daily note as a plain factual
record - separate from `suggest-brag-items`, which judges what's
*impressive*; this just states what got finished.

Deliberately not the only source of truth for "what I did today" - plenty of
finished work never becomes a task at all. This skill only ever claims to log
what the task manager shows, and says so in the note, rather than implying
it's a complete account of the day. (`end-the-day` has a separate step for
catching work that never touched the task manager.)

## Trigger

`/log-completed-tasks`, or asking what you completed today or on a specific
date. Also invoked as a step by `end-the-day`.

## Process

1. **Work out the target date.** Default to today. If the user names a
   different date, use that instead, as `YYYY-MM-DD`.

2. **Pull that date's completions from your task manager.** For Things3, run
   `osascript skills/things3-export/things_completed_today.applescript` for
   today, or add `"YYYY-MM-DD"` for another date (adjust the path to wherever
   you keep the script). Output is tab-separated: group (project or area),
   name, tags, completion date/time. Areas listed in the script's
   `excludedAreas` setting (e.g. `Personal`) are left out by the script
   itself. For another task manager, use its API or export to get the same
   fields.

3. **Find or create the Daily note for the target date.** If it doesn't
   exist yet (a past date being queried retroactively), create it from your
   current Daily template's structure rather than assuming its shape.

4. **Write a heading and bullet list:**
   - `## Completed today` if the target date is today, otherwise
     `## Completed YYYY-MM-DD`.
   - One bullet per item: the task name, its group in brackets, and its tags
     if any.
   - If nothing came back, write the heading with a single line noting
     nothing was logged that day - don't skip the section, since a blank day
     in the task manager is itself informative.

5. **Write directly** - this is a factual pull, not a drafted judgement call,
   so no per-item confirmation is needed (unlike `suggest-brag-items`).

6. **Mention, don't dwell on, the brag overlap.** When run from
   `end-the-day`, note in one line that some of these may also be worth a
   `suggest-brag-items` pass - but don't flag individual items or judge which
   ones qualify. That stays `suggest-brag-items`'s job.

## Guardrails

- Never edit the task manager - read-only against its completed list.
- Never present this list as exhaustive - always frame it as "what the task
  manager shows completed," not "everything done today."
- Don't merge this into `suggest-brag-items`'s pass or pre-judge which items
  are brag-worthy.

## Notes on conventions (see the vault's CLAUDE.md for the full set)

- Flat tags only, never nested, for Obsidian notes.
- No em-dashes in anything written into notes - hyphens instead (edit to
  taste).
