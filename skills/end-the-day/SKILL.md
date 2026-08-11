---
name: end-the-day
description: >
  Closing-out pass - works as both a once-daily wrap-up and a lighter
  per-task checkpoint (absorbs what a separate `/end-task` skill used to do).
  Scans today's edited notes for loose ends - action-item bullets that don't
  show up as a tracked task, unresolved open questions, duplicates - and
  suggests sharper wording where an action item reads vague. Reports
  findings, then works through fixes one at a time via structured Yes/No
  questions; never auto-edits, never marks anything done in your task
  tracker. Trigger: /end-the-day, or wrapping up your day / closing out a
  task / thread.
---

# End the Day

## Purpose

A closing-out pass, not a rewrite. The goal is to catch action items that
would otherwise fall through the cracks (jotted in a note but never actually
tracked anywhere, or left as an unresolved open question) and offer sharper
wording where it helps - while leaving every actual edit, and every change
to your task tracker, to your approval. Never silently tidy, restructure, or
rewrite prose.

This also covers what a separate `/end-task` skill used to do on its own -
closing out a single thread before starting the next one. There's no
separate lighter version needed: this only ever looks at *today's* edited
notes, so running it mid-task naturally gives a scoped checkpoint, and
running it once at the end of the day naturally gives the fuller sweep. Same
process either way.

### Where "tracked" comes from

This skill needs to judge whether a bullet is already tracked somewhere, and
that depends on how you track tasks (see `start-the-day` for the fuller
discussion of vault-native vs. external task managers):

- **Vault-native**: if you're using Obsidian's `Tasks` plugin (or similar),
  "tracked" means a `- [ ]` checkbox carrying whatever tag/marker your setup
  requires (e.g. `#task`). Judge against what's actually in the note, not an
  export.
- **External task manager**: if tasks live in a separate app, pull its
  current export (see `start-the-day`'s `things3-export/` for a Things3
  example, or your own equivalent) and judge against that instead - a plain
  bullet in a note isn't "tracked" just because it reads like an action item.

Whichever applies to your setup, use that as the source of truth for step 2
below; don't invent a third, vault-checkbox-shaped judgment when you're
actually using an external tracker, or vice versa.

Out of scope now: a project-drop-folder review used to live in this skill
(scanning a `Claude files - <Project>` folder for new/stale files) - pulled
out because it didn't hold up well in practice. If that pattern is useful to
you, it's a reasonable thing to bolt back on as your own second pass, but
it's not part of this skill as written.

## Trigger

`/end-the-day`, or asking to wrap up / end / close out your day, or saying
you're done with the current task / wrapping up this thread / ready to close
this chat.

## Process

1. **Find today's edited notes.**
   - Always include today's Daily note.
   - Also check the vault for any other file modified today (mtime), so the
     scan isn't limited to the daily note if you edited a project note,
     client note, decision log, etc.
   - If this is a per-task checkpoint rather than an end-of-day pass, it's
     still fine to look at all of today's edits, not just this conversation's
     - simpler than trying to isolate "this thread's changes" separately.

2. **Pull whatever represents "tracked" for your setup** (see above) - the
   current task-manager export if you use one, or just the notes themselves
   if you're going vault-native - so loose-end detection is judged against
   what's actually tracked, not guessed at.

3. **Scan those files for loose ends:**
   - Plain bullets that read like a concrete action item but don't obviously
     correspond to anything tracked - flag them and ask if the user wants to
     add it themselves. Never add a task on their behalf; this skill only
     reads task state, never writes to it.
   - Open questions or unresolved "?"/"TBD"-style notes - flag as "still
     open?" rather than assuming resolved.
   - Likely duplicates - the same action mentioned in more than one note, or
     a note-jotted item that's clearly the same thing as an existing tracked
     task worded differently.

4. **Suggest sharper, more action-oriented wording** for any flagged item
   that reads vague or passive (a bare topic instead of a verb-led
   instruction). Offer the reworded version alongside the original - don't
   apply it.

5. **If this is a per-task close-out**, also check whether the task being
   worked on this session looks finished against what was actually produced.
   Don't assume - ask for confirmation. This is a conversational check, not a
   status change anywhere (marking anything complete is the user's own
   action, not something this skill performs).

6. **Report findings**, each item tagged with what kind of issue it is
   (unlinked action item / open question / duplicate / wording suggestion),
   with a one-line reason. Keep it scannable - this is a closing-out pass,
   not a report to read carefully.

7. **Ask before changing anything, one item at a time.** Use structured
   question/answer prompts (Yes/No, plus a free-text option) rather than a
   single wall-of-text list - reviewing one decision at a time beats a big
   block to respond to all at once. Work through findings this way rather
   than batching them into one message. No silent edits, no silent changes
   to task state.

## Out of scope

- Rewriting prose/notes for clarity beyond flagged action items.
- Reorganising sections or merging notes.
- Judging whether a task is actually done, or marking anything complete in a
  task tracker - that's the user's action, this skill only surfaces and asks.
- Silent edits of any kind - this skill only proposes.
- Project drop-folder review - see Purpose above.
- Any repo-maintenance/sync tooling - that's a separate concern from
  closing out a day's notes.

## Notes on conventions (see the vault's CLAUDE.md for the full set)

- If you're using an external task manager, task tracking lives there, not
  in the vault - judge against its export, not vault checkboxes.
- If you're vault-native, a checkbox only counts as tracked if it carries
  whatever marker your setup requires (e.g. `#task`).
- Flat tags only, never nested, for Obsidian notes.
- No em-dashes in anything written into notes - hyphens instead (edit to
  taste).
