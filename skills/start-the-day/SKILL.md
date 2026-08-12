---
name: start-the-day
description: >
  Morning ADHD-focus ritual. Opens (or creates) today's Daily note, then runs
  the surface-stale-tasks skill, then asks whether you want to prep for any
  meetings today (you check your own diary and name them - there's no
  calendar read access), running the prep-meeting skill once per meeting you
  name. Trigger: /start-the-day or "start the day" / "kick off my morning".
---

# Start the Day

## Purpose

A focus tool, not a status report. Prioritisation happens in your task
manager, not here - the Daily note doesn't try to mirror a "today's focus"
checkbox list. This skill is an **orchestrator only** - it does no work
itself beyond opening the Daily note; the actual staleness check and meeting
prep live in their own standalone skills (`surface-stale-tasks`,
`prep-meeting`) that this one calls in sequence.

### Why split into smaller skills

This used to be one skill doing three jobs. It's been split so that each job
is independently useful: you might want a stale-task check mid-afternoon
without running the whole morning ritual, or want to prep one extra meeting
that gets added to your diary after lunch, without repeating everything else.
Splitting also keeps each skill's own job statable in one sentence, which
makes each one easier to trust and to edit later without touching the others.
See the repo README's "One skill, one job" principle - this pattern is meant
to generalise to whatever skills you add later, not just apply here.

### Why a separate task manager at all

An earlier version of this skill (and the `Tasks` plugin Obsidian setup it
was built on) kept everything - notes and tasks - inside the vault, with
Dataview/Tasks queries doing the surfacing. That works, and if it works for
you, keep it: skip this skill's task-manager-integration steps and just use
`end-the-day` against vault-native `#task` checkboxes instead (see that
skill's notes).

The author moved task tracking out to a dedicated app (Things3, on macOS)
because a note-taking tool and a task manager are optimising for different
things: a real task manager gives you due-date notifications, recurring
tasks, and capture from anywhere (phone, watch, car) without needing Obsidian
open, none of which a markdown checkbox in a note does well. The tradeoff is
one more system to keep in sync - these skills make that sync asymmetric and
cheap: they only ever *read* from the task manager and *never write back*, so
there's one direction of truth and no risk of Claude quietly diverging from
what you actually asked your task manager to track.

**This part is intentionally pluggable.** `surface-stale-tasks` and
`prep-meeting` describe the *pattern* (export/query task data, apply
staleness thresholds, filter by tag) rather than a specific tool. Wherever
they say "your task manager," substitute whatever you use - Things3 via
AppleScript (the author's setup; see `skills/things3-export/` for example
scripts you'd adapt), Todoist/TickTick via their APIs, Reminders.app, or
anything else that can hand Claude a plain-text or JSON export of open items
with creation/due dates and tags.

## Trigger

`/start-the-day`, or asking to start/kick off your day/morning.

## Process

1. **Find or create today's Daily note.**
   - Path: `📝 Notes/🗓️ Daily notes/YYYY-MM-DD.md` (today's date).
   - If it exists, read it - don't clobber anything already written under
     `## Notes` or elsewhere.
   - If it doesn't exist, create it using the current `⚙️ Templates/Daily.md`
     as the structure (read the template fresh each time rather than
     hardcoding it here - it may change). Compute the date/time directly
     rather than relying on Templater, since this file is being written
     directly.
   - Do **not** write a task list into the Daily note - your task manager is
     the source of truth for what's on today's plate, and mirroring it here
     is duplicated maintenance for no benefit.

2. **Run the `surface-stale-tasks` skill.** Present its output as-is - don't
   re-derive or second-guess it here.

3. **Ask if there's anything on today's diary worth prepping for.** There's
   no calendar read access - look at your own diary and name the meeting
   (and who it's with, if relevant). Don't try to guess or infer the
   schedule. Work through meetings one at a time, conversationally - don't
   ask for the whole day's agenda up front.
   - For each meeting named, run the `prep-meeting` skill. That skill
     handles finding/creating the meeting note, pulling matching tasks by
     tag, and linking it into today's Daily note - this step is just the
     loop that invokes it once per named meeting.

4. Don't mark anything done in your task manager, don't invent new tasks,
   don't reorganise unrelated parts of the note. This is a read-and-surface
   ritual, not a cleanup or prioritisation step - any actual changes to task
   state are the user's to make themselves, in the tool that owns that state.

## Notes on conventions (see the vault's CLAUDE.md for the full set)

- If you're using an external task manager, task tracking lives there, not
  in the vault - the Daily note doesn't mirror a task list.
- Flat tags only, never nested, for Obsidian notes. Your task manager's tags
  are a separate system and don't need to match that convention.
- No em-dashes in anything written into notes - hyphens instead (edit to
  taste).
- Never offer to edit your task manager on the user's behalf, even as a
  convenience - these skills only ever read from it.
