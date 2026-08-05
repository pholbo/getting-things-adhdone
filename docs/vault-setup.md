---
created: 2026-07-13 17:06
tags:
  - obsidian
  - admin
---
How note creation and the 1:1 workflow are wired together.

## Folders

|Folder|Purpose|
|---|---|
|Notes|Default location for all new notes. Flat.|
|Projects / \<name\>|One subfolder per active project, sits at vault root beside Notes - only notes actually scoped to that project's work.|
|Archive / \<name\>|Finished projects, moved here from Projects.|
|Notes / Daily notes|Daily notes, kept together by choice.|
|Notes / Attachments|Obsidian attachment folder.|
|Notes / Claude memory|Human-readable companion to Claude's own session memory - one file per project, one for vault-wide setup.|
|Templates|Templater templates.|

Company notes and everything else non-project sit in Notes flat. Folders aren't used for organisation there - notes are found via links, search and queries. Projects are the one deliberate exception (added 2026-07-31, PARA-inspired: just Projects + Archive, not the full Projects/Areas/Resources/Archive system) - the flat-notes list was getting unwieldy, and grouping a project's own notes together made more sense than a links-only hub note once file management stopped being manual toil. Projects and Archive sit at vault root rather than nested under Notes, since they're a different organisational axis (active vs. done) rather than another kind of note. Zendesk was the first project moved into this structure; ITSM Vendor Selection followed straight into Archive, since that project was already finished.

## Settings

**Files and links**

- Default location for new notes: Notes
- Automatically update internal links: on

**Templater → Folder templates**

|Folder|Template|
|---|---|
|Notes|Standard|
|Notes / Daily notes|Daily|

Deepest match wins.

## Hotkeys

|Key|Result|
|---|---|
|Cmd + N|New note in Notes, Standard template applied automatically|
|Cmd + Shift + N|Templater picker - choose 1-1 Meeting, Company, Standard|

Cmd + Shift + N is Templater's own built-in "Create new note from template" command.

## The 1:1 workflow

Tag-per-person, not note-per-person. There is no Person note.

1. Capture topics as tasks anywhere, tagged `#1-1` plus a flat per-person tag, e.g. `#1-1` `#jason` (not nested `#1-1/jason`).
2. The 1-1 Meeting template prompts for the person's name, then a tag (defaults to their first name lowercased, editable), then a meeting date. It renames the file to `<date> 1-1 <name>` and pulls in every open topic matching both `#1-1` and that person's tag.

**How they connect.** The two tags on a task line are the only link between a topic and a person - there's no properties field, no backlink matching, no separate person record. Renaming a person's tag means updating it on every existing task tagged with the old one; nothing propagates automatically.

Meeting note filenames are generated from the date. Don't rename them by hand - the filename and `meeting_date` are meant to stay in lockstep.

## Read-only notes

Notes that only render queries are locked to Reading view. Notes you write into are not.

|Locked|Editable|
|---|---|
|Brag list|Meeting notes|
|1-1 Topics aggregator|Templates|
|Meeting notes dashboard|Daily notes, Templates|

Mechanism: the **Force note view mode** plugin, plus this property on the note:

```
obsidianUIMode: preview
```

Cmd + E to edit anyway. Apply the same property to any new dashboard.

Two things to know:

- Folder rules in that plugin's settings **override** this per-note property. There are currently no folder rules, which is the cleanest state - if you add one, it will silently win.
- Never apply this to a template. Templates start with a script block, there is nowhere to put the property, and preview mode would try to render the syntax rather than show it.

## Things that break

**Properties not rendering, queries returning nothing.** The template file has a stale properties block sitting above its script block. Every note made from it inherits two, and Obsidian only reads the first. Open the template in source mode and delete anything above the script. Check the template before checking the settings - this is almost always the cause.

**A template silently does nothing.** macOS smart quotes have replaced the straight quotes in the script with curly ones, which aren't valid JavaScript. Turn it off: System Settings → Keyboard → Text Input → Edit → uncheck "Use smart quotes and dashes".

**Meeting missing from a list.** Check the date. Upcoming shows today and later, Past shows yesterday and earlier.

**meeting_date has no calendar picker.** Its date type is registered in `.obsidian/types.json`. If that file is lost to a sync conflict, the type reverts to text. The template always writes a real date value, so Obsidian can re-infer it.

**Template not found.** Template paths contain an emoji, which is fragile. Copy paths from the file explorer rather than typing them.

## Tag collisions

Task tag matching is a substring match, so `rob` also matches `robin`. If both ever exist, give one a distinguishing tag. The 1-1 Meeting template's tag prompt lets you override the suggested tag at creation.