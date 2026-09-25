---
name: end-the-day
description: >
  Once-daily closing-out pass - the heavier vault-wide sweep, distinct from
  the lightweight per-chat end-task memory check. Scans today's edited notes
  for loose ends - action-item bullets that don't show up as a tracked task,
  unresolved open questions, duplicates - and suggests sharper wording where
  an action item reads vague. Reports findings, then works through fixes one
  at a time via structured Yes/No questions; never auto-edits, never marks
  anything done in your task tracker, and only adds a task to your inbox on a
  per-item yes. Also runs log-completed-tasks to log today's completions into
  the Daily note, auto-detects a "sparse" day (few completions, several other
  notes edited) and if so offers real work that never touched the task
  tracker, runs suggest-brag-items over the same file set, verifies
  everything changed this session, and finally files the chat in a "Dailies"
  sidebar group (Claude desktop app only). Trigger: /end-the-day, or wrapping
  up your day.
---

# End the Day

## Purpose

A closing-out pass, not a rewrite. The goal is to catch action items that
would otherwise fall through the cracks (jotted in a note but never actually
tracked anywhere, or left as an unresolved open question) and offer sharper
wording where it helps - while leaving every actual edit, and every change
to your task tracker, to your approval. Never silently tidy, restructure, or
rewrite prose.

`end-task` is the lighter counterpart - a quick per-chat check that Claude's
own memory files reflect what the session just did, cheap enough to run
every time a task chat closes. This skill is the heavier once-daily version:
a full sweep across every note edited today, plus completed-tasks logging and
brag-item suggestions. Run `end-task` when closing an individual task chat;
run this once, at the actual end of the day. (An earlier version folded both
into this skill; they were split back out because a full vault sweep is too
heavy to run every time a chat closes.)

### Where "tracked" comes from

This skill needs to judge whether a bullet is already tracked somewhere, and
that depends on how you track tasks (see `start-the-day` for the fuller
discussion of vault-native vs. external task managers):

- **Vault-native**: if you're using Obsidian's `Tasks` plugin (or similar),
  "tracked" means a `- [ ]` checkbox carrying whatever tag/marker your setup
  requires (e.g. `#task`). Judge against what's actually in the note, not an
  export.
- **External task manager**: if tasks live in a separate app, pull its
  current export (see `skills/things3-export/` for a Things3 example, or your
  own equivalent) and judge against that instead - a plain bullet in a note
  isn't "tracked" just because it reads like an action item.

Whichever applies to your setup, use that as the source of truth for step 2
below; don't invent a third, vault-checkbox-shaped judgment when you're
actually using an external tracker, or vice versa.

Out of scope now: a project-drop-folder review and a public-repo sync check
both used to live in this skill. The drop-folder review didn't hold up in
practice, and the repo sync was slow enough to hold up finishing for the
day, so both were pulled out. Bolt either back on as your own pass if the
pattern is useful to you.

## Trigger

`/end-the-day`, or asking to wrap up / end / close out your day. Not
triggered by closing an individual task chat - that's `end-task`.

## Process

1. **Find today's edited notes.**
   - Always include today's Daily note.
   - Also check the vault for any other file modified today (mtime), so the
     scan isn't limited to the daily note if you edited a project note,
     client note, decision log, etc.

2. **Pull whatever represents "tracked" for your setup** (see above) - the
   current task-manager export if you use one, or just the notes themselves
   if you're going vault-native - so loose-end detection is judged against
   what's actually tracked, not guessed at.

3. **Scan those files for loose ends:**
   - Plain bullets that read like a concrete action item but don't obviously
     correspond to anything tracked - flag them and ask if the user wants
     each one added. If they say yes to a specific item, add it to the task
     manager's inbox (for Things3, via AppleScript's `make new to do`) with a
     title and optional note only - never a project, area, tag or date, so
     the inbox stays the one place new tasks get sorted. Never add anything
     without that per-item yes. If you'd rather this skill stayed strictly
     read-only, drop the adding and just flag the item.
   - Open questions or unresolved "?"/"TBD"-style notes - flag as "still
     open?" rather than assuming resolved.
   - Likely duplicates - the same action mentioned in more than one note, or
     a note-jotted item that's clearly the same thing as an existing tracked
     task worded differently.

4. **Suggest sharper, more action-oriented wording** for any flagged item
   that reads vague or passive (a bare topic instead of a verb-led
   instruction). Offer the reworded version alongside the original - don't
   apply it.

5. **Report findings**, each item tagged with what kind of issue it is
   (unlinked action item / open question / duplicate / wording suggestion),
   with a one-line reason. Keep it scannable - this is a closing-out pass,
   not a report to read carefully.

6. **Ask before changing anything, one item at a time.** Use structured
   question/answer prompts (Yes/No, plus a free-text option) rather than a
   single wall-of-text list - reviewing one decision at a time beats a big
   block to respond to all at once. Work through findings this way rather
   than batching them into one message. No silent edits, no silent changes
   to task state.

7. **Run the `log-completed-tasks` skill** for today, writing a "Completed
   today" section into today's Daily note. This is a factual pull from your
   task manager, not a judgement call - present its output as-is, and don't
   treat it as a complete account of the day's work (plenty gets done that
   never becomes a task). If you track tasks inside the vault rather than a
   separate task manager, skip this step and step 8.

8. **Auto-detect a sparse day, and if so, scan for real work the task
   manager never saw.** Some days are spent mostly in Claude chats or notes
   and barely touch the task manager, so step 7's list badly undersells
   them. Check for that: fewer than 3 completions from step 7 AND 2 or more
   non-Daily-note files edited today (from step 1), with extra weight if any
   of those are a decision log or project note. If the condition isn't met,
   skip this step entirely and don't mention it - don't force a scan onto a
   normal or quiet day.
   - If it is met, scan the step 1 files for entries that read as genuinely
     finished work - a decision reached, a build step completed, a call that
     resolved open questions - with no task completion behind it.
   - Draft each as a short, standalone bullet (same style as
     `suggest-brag-items` drafts - understandable out of context, linked back
     to its source note).
   - Present all drafts together as one checkbox list (multiSelect) so the
     user ticks which ones actually happened. If your question tool caps the
     number of options, split into several rounds rather than silently
     dropping the excess.
   - Add only the ticked bullets to the "Completed today" section, clearly
     separated from the task-manager list (e.g. under a sub-line like "From
     today's notes and calls (not in the task manager):") so the section's
     provenance stays honest - never blend an inferred item into the factual
     list.
   - If nothing looks like a real gap, say so briefly and move on.

9. **Run the `suggest-brag-items` skill** over the same file set gathered
   in step 1, so it isn't re-scanning the vault separately. Present its
   output as-is - this is a separate concern from loose-end detection
   (achievements worth keeping, not action items that fell through the
   cracks), so keep it as its own pass. Some items from step 7 or 8 may also
   surface here as brag candidates - that's expected overlap.

10. **Verify before reporting the day closed.** List every file actually
    created or modified this session, re-read each one, and quote the
    specific lines that prove the change landed. Flag anything claimed as
    done earlier in the session but not actually reflected in the file.
    Don't skip it even on a quiet session with few edits.

11. **File the daily chat** (optional, Claude desktop app only). The very
    last thing, after verification. Move this chat into a sidebar group
    named `Dailies` using the desktop app's session tools, looking the group
    up by name each time rather than hardcoding its id. If no such group
    exists, say so and stop - don't create one. If the tools aren't
    available (e.g. a terminal session), skip silently. Done here rather than
    in `start-the-day` (which names the chat) so today's chat stays in the
    main list while it's in use, and the Dailies group only holds finished
    days and can stay collapsed.

## Out of scope

- Rewriting prose/notes for clarity beyond flagged action items.
- Reorganising sections or merging notes.
- Judging whether a task is actually done, or marking anything complete in a
  task tracker - that's the user's action, this skill only surfaces and asks.
- Organising, scheduling or tagging tasks - the only write is adding a new
  inbox item on a per-item yes.
- Silent edits of any kind - this skill only proposes.
- Project drop-folder review and repo sync - see Purpose above.
- Per-chat memory freshness checks - that's `end-task`'s job.

## Notes on conventions (see the vault's CLAUDE.md for the full set)

- If you're using an external task manager, task tracking lives there, not
  in the vault - judge against its export, not vault checkboxes.
- If you're vault-native, a checkbox only counts as tracked if it carries
  whatever marker your setup requires (e.g. `#task`).
- Flat tags only, never nested, for Obsidian notes.
- No em-dashes in anything written into notes - hyphens instead (edit to
  taste).
