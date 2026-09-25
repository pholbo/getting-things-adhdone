---
name: end-task
description: >
  Lightweight per-chat close-out check, distinct from end-the-day's fuller
  once-daily sweep. Checks whether Claude's own auto-memory files relevant to
  this session's work are still accurate - updates anything stale (predates a
  change made this session) or duplicated (an outstanding item now resolved),
  and reports what changed. Does not touch vault notes, the task manager, or
  brag items - those stay end-the-day's job. Trigger: /end-task, or saying
  you're about to close this chat and want to check notes are up to date.
---

# End Task

## Purpose

A pattern that works well with these skills: keep one long-running "daily"
chat for ad hoc questions (see `start-the-day`), and fork each substantial
task into its own chat, closing it once the task's done. Before closing a
task chat, it's worth making sure Claude's own auto-memory - its persistent
memory files, not the vault - actually reflects what just happened, so the
next chat you open starts from accurate context instead of stale carry-over.

This is deliberately narrower than `end-the-day`. That skill does a heavier
vault-wide sweep (loose ends across every note edited today, task-manager
cross-checks, brag-item suggestions) that's worth the cost once a day, not
every time a task chat closes. `end-task` only looks at memory freshness -
cheap enough to run on every close, and the thing that most directly
protects the next chat.

## Trigger

`/end-task`, or saying you're closing this chat and want to confirm
notes/memory are current before you do.

## Process

1. **Work out what this session actually touched** - which project(s) or
   topic(s) the conversation's work relates to. No vault-wide scan needed;
   this is scoped to the current session's content.

2. **Check the relevant existing memory files** for that project/topic (via
   the memory index, e.g. `MEMORY.md`, and the files it points to). Look
   specifically for:
   - Anything stated as "not yet done," "outstanding," or "blocked" that
     this session actually resolved.
   - Anything this session's new information supersedes or contradicts.
   - Duplicate entries that should collapse into one once updated.

3. **Cross-check against anything already tagged in today's Daily note**
   for the session's topic (e.g. a digest tag you use for weekly project
   updates), purely to confirm memory and the note agree on what happened -
   don't add or edit tags here, that's a vault edit and out of scope.

4. **Update the affected memory files directly.** Memory writes don't need
   approval the way vault edits do - but say plainly what was written,
   corrected, or removed, so the user can see the diff rather than just
   being told it's handled.

5. **Report a short close-out summary**: what was checked, what (if
   anything) changed, and confirmation it's safe to close. If nothing needed
   updating, say so briefly rather than padding it out.

## Out of scope

- Vault notes (Daily note, project notes) - loose ends and wording there are
  `end-the-day`'s job.
- The task manager - no reads or writes here at all.
- Brag-list suggestions - stays `suggest-brag-items`'s job, run from
  `end-the-day`.
- Adding or editing digest tags - this skill only checks memory against
  what's already tagged.

## Notes on conventions

- No em-dashes in anything written - hyphens instead (edit to taste).
- Prefer bullet-point lists over walls of prose.
