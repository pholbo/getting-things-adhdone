# Obsidian plugin setup

The templates and skills in this repo assume a specific set of community
plugins, and a couple of them need non-default settings to work at all - the
`start-the-day`/`end-the-day` skills will silently find nothing if the Tasks
global filter isn't set, for example. This doc covers what to install and
which settings actually matter.

Install via **Settings → Community plugins → Browse**, search each name,
install, then enable it.

## Required

**Templater** (`templater-obsidian`)
Runs the `<%* ... %>` scripts inside the templates in `templates/` - the
1:1 Meeting template's name/tag/date prompts, and the date stamp in Daily
notes.
- Settings → Templater → **Template folder location**: point this at wherever
  you put `templates/` in your vault.
- Settings → Templater → **Folder templates**: map folders to templates, e.g.
  `Notes → Standard`, `Notes/Daily notes → Daily`. Deepest matching folder
  wins if you nest further.
- If a template silently does nothing, check for curly smart quotes in the
  script - macOS text replacement turns straight quotes into curly ones,
  which breaks the JavaScript. Turn it off in System Settings → Keyboard →
  Text Input → Edit → uncheck "Use smart quotes and dashes".

**Tasks** (`obsidian-tasks-plugin`)
Every checkbox convention in `CLAUDE.md` and both day-skills depends on this
plugin's query blocks and date-emoji parsing.
- Settings → Tasks → **Global filter**: set to `#task`. Without this, the
  Tasks plugin treats every checkbox in the vault as tracked, which is not
  what the skills expect - they rely on `#task` being the thing that marks a
  line as tracked.
- The three date emoji (📅 due, ⏳ scheduled, 🛫 start) are separate fields
  to the plugin - a `tasks` query filtering `scheduled today` won't match a
  line that only has a 📅 due date. Match the emoji on the task line to the
  field name in the query.

**Dataview** (`dataview`)
Powers any `dataview`/`dataviewjs` query blocks in dashboard notes. No
required settings beyond enabling it.

## Recommended

**Natural Language Dates** (`nldates-redux`)
Lets you type things like "next friday" and have it resolve to a real date -
handy when adding 📅/⏳/🛫 dates to tasks by hand. Not load-bearing for the
skills, just convenient.

**Force note view mode** (`obsidian-view-mode-by-frontmatter`)
Locks specific notes (dashboards, aggregators) to Reading view so a stray
keystroke doesn't wreck a query block, via `obsidianUIMode: preview` in that
note's frontmatter. Cmd+E still opens it for editing.
- Leave **folder rules** empty in this plugin's settings. A folder rule
  silently overrides the per-note property, which defeats the point of
  setting it note-by-note. Only add one deliberately, and know what it will
  override first.
- Never add `obsidianUIMode: preview` to a template file - templates open in
  Source mode by design (they start with a script block), and Reading view
  would try to render the Templater syntax as if it were finished text.

**Homepage** (`homepage`)
Opens a chosen note automatically when Obsidian launches - useful if you
build a dashboard note you want to land on every time. Purely a convenience,
skip it if you don't want a fixed landing page.

**Minimal Settings** (`obsidian-minimal-settings`)
A settings UI for the Minimal theme. Only relevant if you're using that
theme - unrelated to any of the task/template mechanics above, purely
cosmetic.

## Sanity check

Once installed and configured, confirm:
1. A new note created in your Daily notes folder auto-applies the Daily
   template (proves Templater folder templates are wired up).
2. A line like `- [ ] test #task 📅 2026-01-01` shows up in a
   `tasks` query block filtering `due today` when the date matches (proves
   the Tasks global filter is set correctly).

If either fails, re-check the settings above before assuming something in
`templates/` or `skills/` is broken - a misconfigured plugin is the more
common cause.
