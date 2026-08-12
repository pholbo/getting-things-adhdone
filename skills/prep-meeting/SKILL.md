---
name: prep-meeting
description: >
  Given a meeting name/topic for today (you name it - no calendar read
  access), finds or creates a dated meeting note and populates it with
  matching tasks pulled by tag from your task manager. Links the note into
  today's Daily note. Standalone, or run once per meeting from
  start-the-day. Trigger: /prep-meeting, or naming a meeting you want to prep
  for.
---

# Prep Meeting

## Purpose

Pull together what's relevant for a specific meeting today - existing notes,
plus any outstanding tasks tagged for that client/person in your task
manager - without having to hunt across the vault and the task manager
yourself.

## Trigger

`/prep-meeting`, or naming a meeting you want to prep for. Also invoked once
per named meeting by `/start-the-day`.

## Process

1. **Work out what kind of meeting it is** - a topic tied to an existing
   standing note (a client, project, or similar), a recurring 1:1 with a
   person, or something else.
2. **Search the vault** for an existing dated meeting note covering today's
   meeting specifically (a `YYYY-MM-DD Meeting - <topic/person>.md` pattern
   works well), plus the standing note it relates to.
3. **Pull relevant tasks by tag**, if your task manager's tags overlap with
   vault topics/people. Pull a full-detail export from your task manager
   (see `skills/things3-export/` for an example Things3 integration - don't
   substitute a trimmed-down snapshot note here, it may be missing the tags
   field this step depends on). Filter for items whose tags match, and add
   them to the note as a plain bulleted list of outstanding items. If
   nothing's tagged yet for this client/person, say so rather than guessing.
   (Task-manager tags don't have to follow the same convention as your
   vault's Obsidian tags - the author's, for instance, uses Title Case with
   spaces in Things3 while the vault stays flat and lowercase; match
   whatever the mapping actually is for you.)
4. **Populate the note.**
   - If a dated meeting note already exists for today, open it and add the
     task list plus anything else worth raising.
   - If not, create one following your standard note template's frontmatter
     shape rather than inventing a new one, named descriptively (e.g.
     `YYYY-MM-DD Meeting - <topic/person>.md`), filed wherever fits your
     folder structure (a client/project folder for topic-driven meetings,
     alongside existing dated notes for a recurring 1:1).
5. **Link it from the Daily note.** Add (or append to) a `## Meetings today`
   section in today's Daily note with a wikilink to the meeting note. Create
   the section if it doesn't exist yet; don't duplicate a link that's
   already there. If the Daily note itself doesn't exist yet, this is
   normally handled by whatever called this skill (e.g. `start-the-day`) -
   create it only if nothing else will.

## Guardrails

- Never edit the task manager, never invent new tasks, never reorganise
  unrelated parts of the meeting note or Daily note.
- Don't guess the day's schedule - the user names the meeting; there's no
  calendar read access.
