# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

An Obsidian vault worked on together with Claude Code. Works whether the vault is local-only or synced via any method (Google Drive, iCloud, Syncthing, etc.) - nothing here depends on a particular sync mechanism. Not a codebase - no build, lint, or test commands apply. Work here means editing Markdown notes, YAML frontmatter, Templater scripts (`.md` templates with `` blocks), and Dataview query blocks embedded in notes (plus Tasks-plugin query blocks too, if you're tracking tasks inside the vault - see below).

## Structure

Mostly flat, with one deliberate exception: project-scoped notes get their own folder, which sits at vault root alongside Notes rather than nested inside it.

| Folder | Purpose |
|---|---|
| `📝 Notes` | Default location for all non-project notes - flat, found via links/tags/queries |
| `📁 Projects/<name>` | One subfolder per active project (e.g. `Zendesk`) - only project-scoped notes go here |
| `🗄️ Archive/<name>` | Finished projects, moved here from `📁 Projects` |
| `📝 Notes/🗓️ Daily notes` | Daily notes only |
| `📝 Notes/📎 Attachments` | Obsidian attachment folder |
| `📝 Notes/🤖 Claude memory` | Human-readable companion to Claude's own session memory, one file per project plus one for vault-wide setup |
| `⚙️ Templates` | Templater templates |

A note only belongs in `📁 Projects/<name>` if it's genuinely scoped to that project's work - don't move general reference notes (company notes, vendor notes, musings) in just because they're topically related.

Full mechanics of how note creation and templates are wired together live in `docs/vault-setup.md` - read that before changing template or dashboard behaviour; it also documents known failure modes (stale duplicate frontmatter blocks, macOS smart quotes breaking Templater scripts, tag substring collisions, etc.) rather than repeating them here.

## Plugins in use

`templater-obsidian`, `dataview`, `nldates-redux`, `obsidian-view-mode-by-frontmatter` (Force note view mode), `homepage`, `obsidian-minimal-settings`. Add `obsidian-tasks-plugin` too **only if** you're tracking tasks inside the vault rather than in a separate task manager - see below.

## Task tracking: two options

The skills in this repo work either way - pick one and edit this section to
describe your actual setup, don't leave both described as if they're both
active at once.

**Option A - external task manager (what the author actually uses; see
`start-the-day`'s "Why a separate task manager at all" for the reasoning).**
Tasks live in a dedicated app (Things3, Todoist, Reminders.app, whatever) -
the vault never mirrors a task list, and `end-the-day`/`start-the-day` judge
what's "tracked" against an export from that tool rather than vault
checkboxes. No `obsidian-tasks-plugin` needed. If you're on this path,
delete the Tasks-plugin-specific bullets below and describe your own tool's
export instead (see `skills/things3-export/` for a worked Things3 example).

**Option B - vault-native, via the Tasks plugin.** Everything below this
line only applies if you've gone this route - install `obsidian-tasks-plugin`
(see `docs/obsidian-plugin-setup.md`) and keep these conventions:

- Tasks-plugin global filter is `#task` - a checkbox line only counts as a tracked task if it carries that tag.
- Tasks-plugin date emoji are distinct fields and not interchangeable in queries: 📅 = due, ⏳ = scheduled, 🛫 = start. A `tasks` query block filtering `scheduled today` will not match a task carrying only a 📅 due date - match the emoji used on the task line to the field name used in the query.
- Priority markers `⏫`/`🔼`/`🔽` are used for urgency signal alongside due dates.
- `#blocked` tag for open tasks stuck on someone/something else, alongside `#task` + project tag. A dedicated "All Tasks" dashboard has a Blocked section separate from everything else.
- Completed work is logged as done tasks (`- [x] ... #task #zendesk ✅ <date>`), not a separate `#log` tag.
- Add a Tasks-plugin created-date marker (`➕ <date>`) to any task checkbox Claude creates, so `sort by created` queries work correctly.

## Tag conventions (apply either way)

- Flat tags only, never nested (`#zendesk`, not `#project/zendesk`). This is a deliberate preference - don't propose nested tag schemes.
- No Person notes - 1:1s are tag-per-person, not note-per-person. 1:1 topics get two flat tags: `#1-1` plus a per-person tag (e.g. `#jason`), never nested `#1-1/jason`. The 1-1 Meeting template prompts for the person's name and tag at creation time (no Person-note picker) and pulls topics via `tags include #1-1` + `tags include #<person-tag>`.
- A `#brag` tag marks a bullet for the running "brag list" dashboard (see `suggest-brag-items`) - flat, same as everything else here.
- No em-dashes - use hyphens instead (edit this to your own preference).

## Dashboards and read-only notes

A `Home.md` and a few other notes (an all-tasks view, a 1:1 topics aggregator, a brag list) are query-only dashboards, locked to Reading view via `obsidianUIMode: preview` in frontmatter (Cmd+E to edit anyway). Never add this property to a template file - templates start with a Templater script block and preview mode will try to render the script syntax instead of executing it.

Per-note `obsidianUIMode` is overridden by any folder rule in the Force-note-view-mode plugin settings - keep that list empty unless you mean for a whole folder's view mode to be silently overridden.

## Automation preference

Default to manual/on-demand mechanisms (queries you check yourself, slash-command-style skills) over scheduled automation (cron, digests, push notifications) for this vault, unless explicitly asked for automation.

## Project-hub pattern

1:1s use tag-per-person (see above), not a hub note. Projects use a folder per project under `📁 Projects/<name>` at vault root (PARA-inspired, deliberately just Projects + Archive rather than full PARA) - all of a project's notes live together in that folder rather than being linked together from a separate hub note. Move a project's folder into `🗄️ Archive` when it's finished; nothing more ceremonial than that.
