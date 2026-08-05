---
name: start-the-day
description: >
  Morning ADHD-focus ritual. Opens (or creates) today's Daily note, populates
  its "Today's focus" section from open tasks across the vault, then asks a
  short set of prioritisation questions. Trigger: /start-the-day or "start the
  day" / "kick off my morning".
---

# Start the Day

## Purpose

A focus tool, not a status report. The goal is to hand you a short, honest
list of what's actually in front of you today, then help you pick 1-3 things
to actually work on - not to dump every open task in the vault on you at once.

## Trigger

`/start-the-day`, or asking to start/kick off your day/morning.

## Process

1. **Find or create today's Daily note.**
   - Path: `📝 Notes/🗓️ Daily notes/YYYY-MM-DD.md` (today's date).
   - If it exists, read it - don't clobber anything already written under `## Notes`
     or elsewhere. Only the `## Today's focus` section gets (re)built.
   - If it doesn't exist, create it using the current `⚙️ Templates/Daily.md` as the
     structure (read the template fresh each time rather than hardcoding it here -
     it may change). Compute the date/time directly rather than relying on
     Templater, since this file is being written directly.

2. **Gather candidate tasks** by searching the vault for open (`- [ ]`) lines
   carrying `#task`:
   - **Due today** - carries 📅, ⏳, or 🛫 dated today.
   - **Carried over** - carries 📅, ⏳, or 🛫 dated before today, still open, not
     tagged `#blocked`.
   - **Blocked** - tagged `#blocked`, regardless of date.
   Don't silently drop anything that matches - if a list is long, say so and let
   the user decide what to cut rather than pre-filtering quietly.

3. **Populate the three subsections** under `## Today's focus`:
   - For tasks that already live in *this* note (e.g. added the same morning),
     list them directly as checkboxes.
   - For tasks living in *other* notes, embed them by block reference rather than
     copying the line - this keeps a single source of truth and avoids duplicate
     tracked tasks:
     - Check if the source line already ends in a block ID (`^some-id`). If not,
       add one - a short kebab-case slug from the task's first few significant
       words, checked against that file for collisions.
     - Embed with `![[YYYY-MM-DD#^some-id]]` in the Daily note.
   - If a section has nothing to show, leave it empty rather than inventing
     filler.

4. **Ask a short prioritisation prompt** - not a long questionnaire. Something
   like: state the counts (due / carried over / blocked), then ask which 1-3
   things you actually want to focus on first today. Keep it to one or two
   questions.

5. Don't mark anything done, don't invent new tasks, don't reorganise unrelated
   parts of the note. This is a read-and-surface step, not a cleanup step.

## Notes on conventions (see the vault's CLAUDE.md for the full set)

- A checkbox only counts as tracked if it carries `#task`.
- Date emoji are distinct: 📅 due, ⏳ scheduled, 🛫 start - match the one already
  on the line, don't assume they're interchangeable.
- Flat tags only, never nested.
- No em-dashes in anything written into notes - hyphens instead (edit to taste).
