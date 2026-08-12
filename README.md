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
- **`templates/`** - Templater templates for daily notes and generic/company
  notes.
- **`skills/`** - Claude Code skills that do the body-doubling work. Every
  skill here is either **standalone** (does one job, callable on its own) or
  an **orchestrator** (does no work itself, just calls other skills in
  sequence) - never both, and never a skill that does several unrelated jobs
  in one go. New skills added later should keep to this split rather than
  growing into a do-everything script. Currently:
  - `start-the-day` - orchestrator only: opens today's Daily note, then runs
    `surface-stale-tasks`, then runs `prep-meeting` once per meeting you name.
    Doesn't do any of that work itself.
  - `surface-stale-tasks` - flags to-dos that may have gone stale (7+ days in
    your Today list, 21+ days anywhere else). Standalone - run it any time
    you want a staleness check without the rest of the morning ritual.
  - `prep-meeting` - given a meeting name, finds or creates a dated meeting
    note and pulls in matching tasks by tag. Standalone - run it for any
    meeting, any time of day.
  - `update-tasks` - refreshes a human-readable snapshot note of your task
    manager's open to-dos, if you keep one. Standalone.
  - All four work whether you track tasks in the vault itself or in a
    separate task manager - see `start-the-day`'s notes on that choice, plus
    an example Things3 integration under `skills/things3-export/`.
  - `end-the-day` - scans what you touched today (or just this chat thread,
    for a lighter per-task checkpoint) for loose ends - action items that
    aren't actually tracked anywhere, unresolved questions, duplicates - and
    walks through fixes one at a time. Never silently edits anything.
- **`docs/vault-setup.md`** - the mechanics doc: how templates, folders, and
  the 1:1 tagging system are wired together, plus known failure modes
  (macOS smart quotes breaking Templater scripts, stale frontmatter blocks,
  tag substring collisions).
- **`docs/obsidian-plugin-setup.md`** - which Obsidian community plugins this
  depends on and the settings that actually matter (most of it doesn't work
  without the Tasks plugin's global filter set correctly, for one).

## Requirements

- [Obsidian](https://obsidian.md) with the plugins listed in
  `docs/obsidian-plugin-setup.md` - Templater and Dataview are required. The
  `Tasks` plugin is only needed if you're tracking tasks inside the vault
  rather than in a separate task manager (Things3, Todoist, Reminders.app,
  etc.) - see `start-the-day`'s notes on that choice.
- [Claude Code](https://claude.com/claude-code) pointed at your vault
  directory.

## Setting it up

**Quicker route:** if you already have Obsidian and Claude Code installed,
navigate to your vault root and run:

```
git clone https://github.com/pholbo/getting-things-adhdone /tmp/gta
/tmp/gta/setup.sh .
claude
```

then type `/setup` inside Claude Code. It'll ask a few questions (new vault
or existing, how you track tasks) and copy in CLAUDE.md, templates, folder
structure, and the right skill set for your answers. You'll still want to
install the Obsidian plugins below and skim `docs/vault-setup.md` afterwards,
but this gets you to a working starting point first.

**Manual route:**

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
- **Never silently edit.** `end-the-day` reports what it'd change and asks
  before touching anything, one decision at a time rather than a wall of
  text.
- **Flat over nested.** Tags, folders, and structure stay as shallow as
  they can, because a system with a learning curve is a system that stops
  getting maintained.
- **One skill, one job.** A skill either does a single, standalone thing, or
  it's a thin orchestrator that calls other skills in sequence - never a mix
  of both. `start-the-day` used to be one skill doing several jobs; it's now
  an orchestrator over `surface-stale-tasks`, `prep-meeting`, and
  `update-tasks`, each of which is independently useful on its own. Splitting
  this way keeps each skill's job statable in one sentence, and lets you run
  a piece of a ritual without the whole thing.

## Related

- [i-have-adhd](https://github.com/ayghri/i-have-adhd) - a Claude Code skill
  that keeps the model's own output ADHD-friendly (answer first, no burying
  it under preamble). Complements this repo well: this is about the vault
  Claude works in, that's about how Claude talks back to you. Used alongside
  the skills here.

## License

MIT - see `LICENSE`.
