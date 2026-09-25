---
name: setup
description: >
  One-time interactive scaffolding for getting-things-adhdone. Asks a few
  questions (new vault or existing, how you track tasks) and copies in the
  right CLAUDE.md, templates, folder structure, and skill set from the
  staged repo at .claude/.gta-source. Trigger: /setup, run once after
  setup.sh has staged the repo into this vault.
---

# Setup

## Purpose

Turns the manual "Setting it up" steps in the repo README into a short,
conversational walkthrough, so a new user gets a working starting point
without reading the whole repo first. This skill is meant to be **run once**
per vault, near the start - not something that recurs.

## Trigger

`/setup`, after `setup.sh` has copied this skill and staged the repo source
into `.claude/.gta-source` inside the vault you're sitting in.

## Process

### 0. Confirm the source is staged

Check `.claude/.gta-source` exists in the current directory and looks like
the repo (has `skills/`, `templates/`, `vault-skeleton/`, `CLAUDE.md`). If
it's missing, stop and explain how to get it:

```
git clone https://github.com/pholbo/getting-things-adhdone /tmp/gta
/tmp/gta/setup.sh .
```

then re-run `/setup`. Don't try to fetch the repo yourself over the network -
this skill only ever reads from the local staged copy.

### 1. New vault, or adding to an existing one?

Ask this first, one question at a time - don't bundle it with the next
question.

- **New vault, starting from scratch:** copy `vault-skeleton/*` into the
  vault root as-is (it's just folders with `.gitkeep` placeholders - safe to
  copy wholesale into an empty or near-empty vault).
- **Existing vault:** don't copy `vault-skeleton/` at all. Instead, ask what
  the user already has for: a Daily notes folder, a Templater templates
  folder, and whether they want a Projects/Archive split. Note which of
  these are missing and offer to create just those, matching the user's own
  existing naming rather than imposing the skeleton's folder names/emoji.

### 2. How do you track tasks?

Ask: in Obsidian itself, or a separate task manager?

- **In Obsidian** (Tasks plugin + Dataview queries): tasks live in the vault
  as `#task` checkboxes. Copy `skills/end-the-day/`, `skills/end-task/` and
  `skills/suggest-brag-items/` into `.claude/skills/` - skip
  `start-the-day`, `surface-stale-tasks`, `pick-meetings-to-prep`,
  `prep-meeting`, `update-tasks` and `log-completed-tasks` entirely, since
  those are all built around reading from an external task manager and
  don't apply here (`end-the-day` skips its completed-tasks steps without
  one). Point
  the user at `docs/obsidian-plugin-setup.md` for the Tasks plugin's global
  filter setting - most of this silently does nothing if that's misconfigured.
- **A separate task manager:** ask which one, offering common options
  (Things3, Todoist, TickTick, Apple Reminders) plus a free-text "other."
  Copy `skills/end-the-day/`, `skills/end-task/`, `skills/start-the-day/`,
  `skills/surface-stale-tasks/`, `skills/pick-meetings-to-prep/`,
  `skills/prep-meeting/`, `skills/update-tasks/`,
  `skills/log-completed-tasks/`, `skills/suggest-brag-items/`, and
  `skills/things3-export/` into
  `.claude/skills/` (and `.claude/skills/` sibling location for the export
  folder, matching the source layout).
  - **If Things3:** the `things3-export/` AppleScripts work as-is (macOS
    only). Mention the AppleScript permission prompt they'll hit the first
    time a script runs, and the `excludedAreas` setting in
    `things_completed_today.applescript`. Also offer the optional
    on-request extras, `link-task` (two-way task/note links) and
    `search-mail` (reads Apple Mail), without installing them by default.
  - **If anything else** (Todoist, TickTick, Reminders, other): the
    AppleScript export scripts are Things3-specific and won't work for
    them. Say this plainly rather than pretending it's plug-and-play. Point
    at `skills/surface-stale-tasks/SKILL.md` and `skills/prep-meeting/
    SKILL.md`'s own descriptions of the pattern they need (a read-only
    export of open items with creation dates and tags) as the shape to
    replicate against their tool's API/CLI/export feature - building that
    integration is follow-up work, not something this skill generates for
    them automatically. Offer to help write it if they want to do that now,
    but don't assume they do.

### 3. Copy the shared pieces

- Copy `CLAUDE.md` to the vault root. If one already exists there, don't
  overwrite it silently - show the user what the new one would add/change
  and ask first.
- Copy `templates/*` into the vault's Templater templates folder (from step
  1's answer, or ask if it wasn't already established).
- Mention `docs/vault-setup.md` and `docs/obsidian-plugin-setup.md` as
  further reading, without requiring it before the user starts.

### 4. Report and hand off

Summarise what got copied where, what got skipped and why (e.g. "skipped
the Things3 export scripts since you're on Todoist - you'll need your own
integration there"), and suggest running `/start-the-day` (if an external
task manager was chosen) or checking `end-the-day`'s notes on `#task`
checkboxes (if Obsidian-native) as the next thing to try.

Mention `.claude/.gta-source` can be deleted once they're happy - it was
only staging.

## Guardrails

- Never overwrite an existing file in the vault without showing the user
  the diff and asking first - this is a first-run scaffolding step, not a
  sync tool, and the vault may not be empty.
- Don't fabricate support for a task manager integration that doesn't
  actually exist yet (see step 2) - be explicit about what's a working
  example (Things3) versus a pattern to adapt (everything else).
- This skill doesn't need to run again after the first setup - don't offer
  to re-run it as a maintenance step.
