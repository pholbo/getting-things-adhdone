---
name: end-the-day
description: >
  End-of-day tidy-up pass. Scans today's edited notes for loose ends - untagged
  tasks, bare action-item bullets, unresolved open questions, duplicates - and
  suggests more action-oriented wording for tasks. Also scans each project's
  "Claude files - <Project>" drop folder (under Projects/<name>, wherever that
  lives for you) for
  new or stale files. Reports findings grouped by file/folder, then works
  through fixes one at a time via structured Yes/No questions rather than a
  single wall of text; never auto-edits, never auto-moves files. Trigger:
  /end-the-day or "end the day" / "wrap up my day".
---

# End the Day

## Purpose

A closing-out pass, not a rewrite. The goal is to catch tasks that would
otherwise fall through the cracks (untagged, not a checkbox, left as an open
question) and offer sharper wording where it helps - while leaving every actual
edit to your approval. Never silently tidy, restructure, or rewrite prose.

## Trigger

`/end-the-day`, or asking to wrap up / end / close out your day.

## Process

### Pass 1 - vault notes

1. **Find today's edited notes.**
   - Always include today's Daily note (`📝 Notes/🗓️ Daily notes/YYYY-MM-DD.md`).
   - Also check the vault for any other file modified today (mtime), so the
     scan isn't limited to the daily note if you edited a project note,
     decision log, etc.

2. **Scan those files for loose ends:**
   - Checkbox lines missing `#task` - won't be tracked by any dashboard/query.
   - Checkbox lines missing a created marker (➕ date) where sibling tasks in
     the same note have one.
   - Plain bullets that read like action items but aren't checkboxes at all.
   - Open questions or unresolved "?"/"TBD"-style notes - flag as "still open?"
     rather than assuming resolved.
   - Likely duplicates - same task tracked in more than one place.

3. **Suggest action-oriented rewording** for tasks that read vague or passive
   (e.g. a bare topic instead of a verb-led instruction). Offer the reworded
   version alongside the original - don't apply it.

### Pass 2 - project drop folders

4. **Find each project's drop folder.**
   - Every project folder under a `Projects/<name>/` directory (sibling to the
     vault, not inside it - adjust the path to wherever yours lives) has a
     `Claude files - <name>/` subfolder, with an `Archive - <name>/` subfolder
     inside it.
   - List files sitting directly in `Claude files - <name>/` (not already in
     `Archive - <name>/`).

5. **Judge each file as new, still-active, or stale**, read against the
   project's current context (its vault notes/memory file, recent daily-note
   entries, other reference files in the project folder) - not by file age
   alone:
   - **New** - hasn't been looked at/discussed yet. Flag it so you know it's
     there; don't guess what should be done with it.
   - **Still active** - relevant to current work. Leave it, no action needed.
   - **Likely stale** - superseded, referenced project work already finished,
     or no longer connected to anything active. Propose archiving it (move to
     `Archive - <name>/`) - never move without confirmation.

### Both passes

6. **Report findings grouped by file/project folder**, each item tagged with
   what kind of issue it is (untagged / bare bullet / open question / duplicate
   / wording suggestion / new file / active file / likely-stale file), with a
   one-line reason for anything flagged stale. Keep it scannable - this is an
   end-of-day pass, not a report to read carefully.

7. **Ask before changing anything, one item at a time.** Use structured
   question/answer prompts rather than a single wall-of-text list - reviewing
   one decision at a time beats a big block to respond to all at once. Each
   finding becomes its own question, with Yes/No as the offered options (a
   free-text comment is always available on top of those). Work through
   findings this way rather than batching them into one message. No silent
   edits, no silent file moves.

## Out of scope

- Rewriting prose/notes for clarity beyond task lines.
- Reorganising sections or merging notes.
- Judging whether a task is actually done, or marking anything complete.
- Silent edits of any kind - this skill only proposes.
- Moving or deleting a project file without confirming that specific file.
- Touching anything already inside an `Archive - <name>/` folder unless asked.

## Notes on conventions (see the vault's CLAUDE.md for the full set)

- A checkbox only counts as tracked if it carries `#task`.
- Flat tags only, never nested.
- No em-dashes in anything written into notes - hyphens instead (edit to taste).
