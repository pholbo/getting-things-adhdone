---
name: start-the-day
description: >
  Morning ADHD-focus ritual. Renames the chat to "Daily DD-MM-YYYY"
  (Claude desktop app only, skipped elsewhere), optionally checks in about
  sorting your task inbox and any other capture inboxes (skippable), opens
  (or creates) today's Daily note, asks whether you want a stale-task review
  at all (default no) and only runs surface-stale-tasks on a yes, then runs
  pick-meetings-to-prep, which asks which meetings to prep and runs
  prep-meeting once per meeting.
  Trigger: /start-the-day or "start the day" / "kick off my morning".
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
cheap: they almost only *read* from the task manager. The one exception is
that `end-the-day` can add a new item to your task inbox when you say yes to
that specific item - it never organises, schedules, tags or completes
anything, so the inbox stays the single place new tasks get sorted, and
there's no risk of Claude quietly diverging from what you actually asked
your task manager to track.

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

1. **Rename this chat** (optional, Claude desktop app only). Do this first,
   before any question. Rename the chat to `Daily DD-MM-YYYY` (today's date)
   using the desktop app's session tools - the app may ask the user to
   approve the new title. If those tools aren't available (e.g. a terminal
   session), skip silently. Don't file it into a sidebar group here -
   `end-the-day` does that at day's end, so today's chat stays easy to reach
   in the main list all day. This supports a pattern of one long-running
   "daily" chat for ad hoc questions, with bigger tasks forked into their own
   chats.

2. **If you keep a task inbox, ask whether to sort it now, skip it, or
   it's already done.** Offer all three - you may have already sorted it
   before invoking this skill. If you capture tasks anywhere that isn't your
   task manager's inbox (e.g. voice captures on a phone your task manager
   has no app for - the author dictates to Gemini in the car, which saves to
   Google Tasks), include a reminder in the question to clear those into
   the inbox as part of the same sort. This is just the question - don't
   pull or list inbox items yourself, that part stays entirely manual in
   whatever app owns your task inbox. If the user wants to sort it now, wait for
   them to say they're done before moving on. Don't push back on a skip -
   the point is this stays optional so it doesn't turn into a chore that
   gets avoided. Skip this step entirely if you don't use a separate task
   inbox concept.

3. **Find or create today's Daily note.**
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

4. **Ask whether the user wants to go over stale tasks at all - default is
   no.** A plain yes/no before anything runs. Many mornings the answer is no,
   because the user reviews this themselves while going through their task
   manager, so don't run the scan speculatively "just to see". Only on a yes,
   **run the `surface-stale-tasks` skill** and present its output as-is -
   then stop and wait for the user's response before moving on. Never
   present the stale list and continue to meetings in the same message; that
   turns the question into decoration. On a no, go straight to the next step
   without comment. (The author added this gate after the always-on version
   never once led to an action.)

5. **Run the `pick-meetings-to-prep` skill.** It asks which meetings the
   user wants to prep for and runs `prep-meeting` once per meeting named -
   present its output as-is. (It can optionally read a calendar instead -
   see that skill.)

6. Don't mark anything done in your task manager, don't invent new tasks,
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
- This skill never writes to your task manager. Elsewhere, the only write is
  `end-the-day` adding a new inbox item on a per-item yes - never organising,
  completing or rescheduling anything.
