---
name: surface-stale-tasks
description: >
  Flags to-dos from your task manager that may have gone stale (7+ days in
  your Today list, 21+ days anywhere else), using a full-detail export that
  includes each item's creation date. Read-only, conversational, never edits
  your task manager. Standalone, or run as a step from start-the-day.
  Trigger: /surface-stale-tasks, or asking to check for stale/forgotten
  tasks.
---

# Surface Stale Tasks

## Purpose

Tasks can sit forgotten in a task manager - this is a nudge to notice, not a
demand to act. It never edits your task manager itself; you decide what to do
with anything flagged.

Deliberately uses a full-detail export rather than any human-readable
snapshot note you might also keep (see `update-tasks`) - a snapshot built for
readability may drop fields like creation date to stay scannable, but this
skill needs creation date to judge staleness. Don't substitute a trimmed-down
snapshot here even if it's faster to read; if it's missing the field this
skill depends on, the staleness check will be wrong.

## Trigger

`/surface-stale-tasks`, or asking to check for stale/forgotten tasks. Also
invoked as a step by `/start-the-day`.

## Process

1. Pull two views from your task manager: your current "Today" list, and
   every open item across all lists. Both should include each item's
   creation date. Exactly how you get this out (AppleScript, an API call, a
   CLI export) is specific to your tool - `skills/things3-export/` has
   example scripts for Things3 on macOS.
2. From the Today list, flag anything whose creation date is **7+ days
   old** - if it's been sitting in Today a week, it's probably not actually
   getting done there.
3. From the full list, flag anything **21+ days old**, excluding items
   already flagged from the Today list, so nothing is surfaced twice.
4. Present these conversationally as "these look like they might have gone
   stale" - not a demand. Ask if the user wants to move any forward, drop
   them, or leave them as-is.
5. If nothing is stale by these thresholds, just say so briefly rather than
   forcing the conversation.
6. Adjust the 7/21-day thresholds to taste - they're a starting point, not a
   law.

## Guardrails

- Never edit the task manager - no marking done, no rescheduling, no
  retagging. That's the user's action to take, in the tool that owns that
  state.
- Never offer to make the change for them, even as a convenience - this
  skill only ever reads.
