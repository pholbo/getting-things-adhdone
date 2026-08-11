---
name: start-the-day
description: >
  Morning ADHD-focus ritual. Opens (or creates) today's Daily note, surfaces
  tasks from your task manager that may have gone stale, then asks whether
  you want to prep for any meetings today (you check your own diary and name
  them - there's no calendar read access), creating/updating a linked meeting
  note with relevant tasks pulled in by tag. Trigger: /start-the-day or
  "start the day" / "kick off my morning".
---

# Start the Day

## Purpose

A focus tool, not a status report. This skill assumes prioritisation happens
in a dedicated task manager, not in the vault - the Daily note doesn't try to
mirror a "today's focus" checkbox list. Its job is to surface tasks that may
have slipped off your radar, and to help you prep for meetings - not to
re-derive or second-guess whatever your task manager already shows you.

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
one more system to keep in sync - this skill's job is to make that sync
asymmetric and cheap: it only ever *reads* from the task manager and *never
writes back*, so there's one direction of truth and no risk of Claude
quietly diverging from what you actually asked your task manager to track.

**This part is intentionally pluggable.** The steps below describe the
*pattern* (export/query task data, apply staleness thresholds, filter by
tag) rather than a specific tool. Wherever it says "your task manager,"
substitute whatever you use - Things3 via AppleScript (the author's setup;
see `things3-export/` for example scripts you'd adapt), Todoist/TickTick via
their APIs, Reminders.app, or anything else that can hand Claude a plain-text
or JSON export of open items with creation/due dates and tags.

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

2. **Surface potentially stale tasks.**
   - Pull two views from your task manager: your current "Today" list, and
     every open item across all lists. Both should include each item's
     creation date. Exactly how you get this out (AppleScript, an API call,
     a CLI export) is specific to your tool - `things3-export/` has example
     scripts for Things3 on macOS.
   - From the Today list, flag anything whose creation date is **7+ days
     old** - if it's been sitting in Today a week, it's probably not
     actually getting done there.
   - From the full list, flag anything **21+ days old**, excluding items
     already flagged from the Today list, so nothing is surfaced twice.
   - Present these conversationally as "these look like they might have gone
     stale" - not a demand. Ask if they want to move any forward, drop them,
     or leave them as-is. Never edit the task manager yourself either way
     (see guardrails) - that's their action to take.
   - If nothing is stale by these thresholds, just say so briefly rather
     than forcing the conversation.
   - Adjust the 7/21-day thresholds to taste - they're a starting point, not
     a law.

3. **Ask if there's anything on today's diary worth prepping for.** There's
   no calendar read access - look at your own diary and name the meeting
   (and who it's with, if relevant). Don't try to guess or infer the
   schedule. Work through meetings one at a time, conversationally - don't
   ask for the whole day's agenda up front.
   - For each meeting named, first work out what kind it is - a topic tied
     to an existing standing note (a client, project, or similar), a
     recurring 1:1 with a person, or something else.
   - Search the vault for an existing dated meeting note covering today's
     meeting specifically (a `YYYY-MM-DD Meeting - <topic/person>.md`
     pattern works well), plus the standing note it relates to.
   - **Pull relevant tasks by tag**, if your task manager's tags overlap
     with vault topics/people. Filter the full-list export (from step 2) for
     items whose tags match, and add them to the note as a plain bulleted
     list of outstanding items. If nothing's tagged yet for this
     client/person, say so rather than guessing. (Task-manager tags don't
     have to follow the same convention as your vault's Obsidian tags - the
     author's, for instance, uses Title Case with spaces in Things3 while
     the vault stays flat and lowercase; match whatever the mapping actually
     is for you.)
   - If a dated meeting note already exists for today, open it and populate
     it with that task list plus anything else worth raising. If not,
     create one following your standard note template's frontmatter shape
     rather than inventing a new one, named descriptively (e.g.
     `YYYY-MM-DD Meeting - <topic/person>.md`), filed wherever fits your
     folder structure (a client/project folder for topic-driven meetings,
     alongside existing dated notes for a recurring 1:1).
   - **Link it from the Daily note.** Add (or append to) a `## Meetings
     today` section in the Daily note with a wikilink to the meeting note.
     Create the section if it doesn't exist yet; don't duplicate a link
     that's already there.

4. Don't mark anything done in your task manager, don't invent new tasks,
   don't reorganise unrelated parts of the note. This is a read-and-surface
   step, not a cleanup or prioritisation step - any actual changes to task
   state are the user's to make themselves, in the tool that owns that
   state.

## Notes on conventions (see the vault's CLAUDE.md for the full set)

- If you're using an external task manager, task tracking lives there, not
  in the vault - the Daily note doesn't mirror a task list.
- Flat tags only, never nested, for Obsidian notes. Your task manager's tags
  are a separate system and don't need to match that convention.
- No em-dashes in anything written into notes - hyphens instead (edit to
  taste).
