---
name: end-task
description: >
  Checkpoint pass for closing out a single task/thread before ending the chat -
  narrower and cheaper than /end-the-day, which is a once-daily full-vault
  sweep. Confirms the task this chat was working on, checks whether it's done
  and offers to mark it, scans only what changed in this conversation for loose
  ends (untagged tasks, bare bullets, unresolved questions), and summarises
  what's done vs still open so you have a clean handoff point. Never scans the
  whole vault or project drop folders - that's /end-the-day's job. Trigger:
  /end-task or saying you're done with this task / wrapping up this thread.
---

# End Task

## Purpose

A per-task checkpoint, not a mini end-of-day. If you run one chat per
substantial task, this skill closes a chat out cleanly: confirm what got done,
catch anything from *this thread* that would otherwise fall through the
cracks, and leave a clear note of what's still open before starting a fresh
chat for the next task. It only looks at this conversation's own changes, not
the whole day - that broader sweep is `/end-the-day`'s job, and the two are
not meant to duplicate each other.

## Trigger

`/end-task`, or saying you're done with the current task / wrapping up this
thread / ready to close this chat.

## Process

1. **Identify the task this chat was working on.**
   - If it's an existing tracked task (in a Daily note, project note, etc.),
     find it directly rather than guessing.
   - If the work never had a tracked task (e.g. it started as a quick ask and
     grew), don't invent one retroactively unless you want it captured - ask,
     don't assume.

2. **Check whether it's actually done.**
   - Look at what was produced this session against what the task needed.
   - If it looks complete, ask for confirmation before marking `[x]` - don't
     mark anything done without an explicit yes, even if the evidence looks
     clear-cut.
   - If it's only partly done, don't mark it done - note what's left instead
     (see step 4).

3. **Scan this conversation's own changes for loose ends** - same categories
   as `/end-the-day` Pass 1, but scoped only to edits made in this chat, not a
   vault-wide mtime scan:
   - Checkbox lines added this session missing `#task`.
   - Checkbox lines missing a created marker (➕ date).
   - Plain bullets added this session that read like action items but aren't
     checkboxes.
   - Open questions raised this session that never got resolved.

4. **Note anything left open** - follow-ups, blockers, "still waiting on X"
   items that came out of this thread. These should already be tracked
   properly (tagged tasks, `#blocked` where relevant) rather than just
   mentioned in this summary - if something surfaced this session and isn't
   tracked yet, flag it and ask whether to add it, same as step 1.

5. **Summarise: done vs still open.** A short, scannable close-out - what got
   finished (and got marked `[x]`, if confirmed), what's still outstanding and
   where it's tracked, so you can open a fresh chat for the next task without
   having to reconstruct where things stand.

6. **Ask before changing anything**, same pattern as `/end-the-day` - one
   thing at a time if there's more than one loose end, never a silent edit.

## Out of scope

- Scanning the whole vault, other notes not touched this session, or project
  drop folders (`Claude files - <name>/`) - that's `/end-the-day`.
- Judging whether a task is done without explicit confirmation.
- Rewording, restructuring, or tidying anything beyond this session's own
  loose ends.
- Starting the next task or opening a new chat - that's your call, this skill
  just closes out the current one cleanly.

## Notes on conventions (see the vault's CLAUDE.md for the full set)

- A checkbox only counts as tracked if it carries `#task`.
- Flat tags only, never nested.
- No em-dashes in anything written into notes - hyphens instead (edit to taste).
