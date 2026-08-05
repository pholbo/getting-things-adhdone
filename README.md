# Getting Things ADHDone

An Obsidian + Claude Code setup for running a second brain when your working
memory won't cooperate. Less "productivity system," more a **body double** -
a working partner that sits with you, holds the list you can't hold in your
head, and nudges you toward starting rather than organising forever.

## Why this exists

Most PKM (personal knowledge management) advice assumes you'll maintain the
system. If you have ADHD, the system is usually the first thing to fall over -
not because the ideas are bad, but because "spend 20 minutes weekly reviewing
your task database" is itself an executive-function tax you don't have spare
capacity for.

This repo is the alternative: Claude Code does the maintenance (finding
carried-over tasks, catching untagged loose ends, tidying at day's end) so the
human only has to do two things - write things down roughly, and answer a
short prioritisation question when asked. The structure stays flat and
low-ceremony on purpose; the "skills" below do the retrieval work instead of
asking you to keep it organised yourself.

## What's in here

- **`CLAUDE.md`** - project instructions for Claude Code: vault structure,
  tagging conventions, task/date conventions. Drop this at the root of your
  own vault and edit to taste.
- **`vault-skeleton/`** - an *example* folder structure (Notes, Projects,
  Archive, Templates, Daily notes, etc.), for starting a vault from scratch.
  If you already have a vault, skip it and map the conventions onto your
  existing folders instead - see that folder's own README for both paths.
- **`templates/`** - Templater templates for daily notes, 1:1 meeting notes,
  and generic/company notes.
- **`skills/`** - three Claude Code skills that do the actual body-doubling
  work:
  - `start-the-day` - opens today's Daily note, pulls in what's due, carried
    over, or blocked from across the vault, and asks you to pick 1-3 things
    to focus on.
  - `end-the-day` - scans what you touched today for loose ends (untagged
    tasks, bare bullets, unresolved questions) and walks through fixes one
    at a time - never silently edits anything.
  - `end-task` - a lighter per-task checkpoint for closing out a single chat
    thread before starting the next one.
- **`docs/vault-setup.md`** - the mechanics doc: how templates, folders, and
  the 1:1 tagging system are wired together, plus known failure modes
  (macOS smart quotes breaking Templater scripts, stale frontmatter blocks,
  tag substring collisions).
- **`docs/obsidian-plugin-setup.md`** - which Obsidian community plugins this
  depends on and the settings that actually matter (most of it doesn't work
  without the Tasks plugin's global filter set correctly, for one).

## Requirements

- [Obsidian](https://obsidian.md) with the plugins listed in
  `docs/obsidian-plugin-setup.md` - Templater, Tasks, and Dataview are
  required, a few others are recommended but optional.
- [Claude Code](https://claude.com/claude-code) pointed at your vault
  directory.

## Setting it up

1. Install and configure the Obsidian plugins per
   `docs/obsidian-plugin-setup.md` first - several of the pieces below
   silently do nothing if a plugin setting is off.
2. Starting from scratch? Copy `vault-skeleton/` into your new vault. Already
   have a vault? Skip it and add whichever pieces you're missing (a Daily
   notes folder, a Projects/Archive split) to your existing structure -
   see `vault-skeleton/README.md` for both paths.
3. Copy `CLAUDE.md` to your vault root and adjust the folder names/emoji in
   its structure table to match whatever you ended up with (or drop the
   emoji entirely - it's cosmetic).
4. Copy `templates/` into your vault's Templater templates folder, and
   `skills/` into `.claude/skills/` inside your vault.
5. Read `docs/vault-setup.md` for how the templates, tags, and dashboards
   are meant to fit together, then adapt rather than adopt wholesale - this
   reflects one person's workflow, not a universal standard.
6. Start with `/start-the-day` each morning and see what sticks.

## Philosophy

- **Manual over automated, by default.** Cron jobs and push notifications
  are easy to build and easy to start ignoring. On-demand skills you
  trigger yourself stay legible - you always know why something happened.
- **Never silently edit.** Both end-of-day skills report what they'd
  change and ask before touching anything, one decision at a time rather
  than a wall of text.
- **Flat over nested.** Tags, folders, and structure stay as shallow as
  they can, because a system with a learning curve is a system that stops
  getting maintained.

## Related

- [i-have-adhd](https://github.com/ayghri/i-have-adhd) - a Claude Code skill
  that keeps the model's own output ADHD-friendly (answer first, no burying
  it under preamble). Complements this repo well: this is about the vault
  Claude works in, that's about how Claude talks back to you. Used alongside
  the skills here.

## License

MIT - see `LICENSE`.
