---
name: link-task
description: >
  Creates a two-way link between a task in your task manager and a vault
  note: a deep link to the task added to the note, and a link back to the
  note appended to the task's notes field. Trigger: /link-task, or asking to
  link a specific task to a specific note (or vice versa).
---

# Link Task

## Purpose

Lets you jump straight from a note to the exact task it relates to, and back
again, without duplicating task tracking in your vault. This is a narrow,
per-request exception to the general "read-only against your task manager"
stance the other task-manager-integration skills in this repo take - see the
guardrails below before using it, and see `start-the-day`'s "Why a separate
task manager at all" section for the read-only-by-default reasoning this
skill deliberately breaks from, just for this one action, only on request.

The example below is written against Things3 (the author's setup, macOS) -
it needs a task manager that supports both a deep link scheme (something
like `things:///show?id=...`) and a way to programmatically read/append to a
task's notes field. Adapt the mechanics to whatever your task manager
exposes; the pattern (identify the task, build both link forms, add one to
the note, append the other to the task, confirm both sides) carries over.

## Trigger

`/link-task`, or naming a task and a note you want linked together.

## Process

1. **Identify the task.** If you haven't given an exact match, search your
   task manager's export or search feature for a name match and confirm
   which task is meant before touching anything.
2. **Get the task's ID or deep-link identifier** from your task manager (for
   Things3 on macOS: `osascript -e 'tell application "Things3" to return id
   of (first to do whose name is "<exact name>")'`, then build the link as
   `things:///show?id=<id>`).
3. **Identify the target note** and its vault-relative path. Build the
   Obsidian link as
   `obsidian://open?vault=<vault name>&file=<url-encoded path, no .md>`.
4. **Add the task link to the note:**
   - If the note has an "Open tasks" section, add a bullet there:
     `- [<task title>](<task deep link>)`.
   - If it doesn't, create one following that note's existing structure -
     don't invent a new section name if a note already uses "Open tasks"
     elsewhere.
5. **Append the Obsidian link to the task's notes field** (for Things3):
   ```
   osascript -e 'tell application "Things3"
   set t to (first to do whose id is "<id>")
   set oldNotes to notes of t
   set newNotes to oldNotes & return & return & "<obsidian link>"
   set notes of t to newNotes
   end tell'
   ```
   Always append after existing notes with a blank line separator - never
   overwrite what's already there. If your task manager only supports
   overwriting the notes field wholesale rather than appending, read the
   current value first and reconstruct it with the new link added, rather
   than risk clobbering it.
6. **Confirm both sides worked** by reading back the note edit and the
   task's notes field, and tell the user what was added and where.

## Guardrails

- Only do this when explicitly asked for this specific task/note pair,
  right now - never infer permission from a past request, never do it
  proactively while doing other work (e.g. don't auto-link every task
  mentioned during meeting prep).
- Only ever touch a task's **notes field** (append-only) or, if separately
  asked, its **title**. Never touch status, due date, scheduling, list/area/
  project membership, or tags, and never mark anything done.
- Never reorganise or prioritise tasks - what happens today/this week stays
  entirely the user's call.
- If the task or note can't be found or the match is ambiguous, ask rather
  than guessing.
