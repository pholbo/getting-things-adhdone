# Vault skeleton

An **example** of the folder structure `CLAUDE.md` and the skills in this
repo assume - one way to lay it out, not the only way, and not something you
need to adopt wholesale. If you're starting a vault from scratch and want
somewhere to begin, copy this in and you don't have to build the folders by
hand. The `.gitkeep` files just hold the empty folders in git - delete them
once each folder has real content.

**Already have a vault?** You don't need this folder at all. Skip straight
to mapping the conventions onto what you've already got: add a `Daily notes`
folder if you don't have one, add a `Projects`/`Archive` pair if you want
that separation, and keep everything else where it already lives. Adjust
`CLAUDE.md`'s folder table to match your real structure rather than renaming
your vault to match this skeleton.

## What's here

```
📝 Notes/
├── 🗓️ Daily notes/     - daily notes only
├── 📎 Attachments/      - Obsidian's attachment folder
└── 🤖 Claude memory/    - human-readable companion to Claude Code's session memory
📁 Projects/              - one subfolder per active project
🗄️ Archive/                - finished projects, moved here from Projects
⚙️ Templates/              - Templater templates
```

Everything outside `📝 Notes` that isn't `Projects`, `Archive`, or
`Templates` is just... notes, flat, found via links/tags/queries rather than
folders. That's deliberate - see the root `README.md` and `CLAUDE.md` for why.

## Using it

**Starting from scratch:**

1. Copy this folder's contents into a new Obsidian vault - the emoji in the
   folder names are cosmetic, rename freely, just keep `CLAUDE.md` and
   `skills/*/SKILL.md` in sync if you do.
2. Copy the repo's `templates/*.md` files into `⚙️ Templates/`.
3. Copy the repo's `skills/` folder into `.claude/skills/` at your vault
   root (outside this structure - Claude Code looks for it relative to
   the vault root, not inside `📝 Notes`).
4. Copy the repo's `CLAUDE.md` into the vault root and adjust folder names
   if you renamed anything in step 1.

**Adding this to an existing vault:** skip this folder entirely. Add
whichever pieces you're missing (a Daily notes folder, a Projects/Archive
split, a Templates folder) to your existing structure instead of adopting
this layout wholesale, then follow steps 2-4 above against your own folder
names. `CLAUDE.md`'s folder table is documentation, not configuration - edit
it to describe your vault as it actually is.
