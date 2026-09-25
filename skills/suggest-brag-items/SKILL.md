---
name: suggest-brag-items
description: >
  Scans today's edited notes for moments that read like an achievement
  (shipped something, resolved an incident, landed a decision, caught an
  error, positive feedback received) and drafts a short brag-list bullet for
  each - linked back to the source note with a wikilink - to add to today's
  Daily note tagged #brag. Never edits the source note itself, and never
  adds anything without you confirming that specific draft first.
  Standalone, or run as a step from end-the-day. Trigger:
  /suggest-brag-items, or asking for brag list suggestions.
---

# Suggest Brag Items

## Purpose

A "brag list" note (a running record of things worth remembering you did -
useful for performance reviews, or just for days when it's hard to see your
own progress) only stays useful if it actually gets fed. The usual failure
mode is that tagging an achievement in the moment gets skipped when you're
heads-down, so the list quietly stops reflecting what actually happened.
This skill is an end-of-day nudge: look back over what got written and flag
anything that reads like it belongs on the list but isn't captured yet.

The achievement itself usually lives buried in a longer note - a dated
bullet inside a client note, a decision inside a project note, or a whole
note that's a finished deliverable in itself. Rather than tagging that
original text in place (often long, context-heavy, or full of internal
references that mean nothing out of context), this skill drafts a short,
standalone brag-list line and adds it as a new bullet to today's Daily note,
tagged `#brag` and linked back to the source with a `[[wikilink]]`. The
source note itself is never edited.

Not a rewrite pass and not a judgement call on what counts as a real
achievement - if something plausibly reads like one, draft it and let the
user decide.

Assumes a Dataview-style query elsewhere in the vault (e.g. a "Brag list"
note) that pulls together every `#brag`-tagged line - this skill only feeds
that tag, it doesn't build or maintain the aggregating note itself.

## Trigger

`/suggest-brag-items`, or asking for brag list suggestions. Also invoked as
a step by `/end-the-day`.

## Process

1. **Find today's edited notes** - same scope as `end-the-day`: today's
   Daily note plus any other vault file modified today (mtime). If this is
   being run as a step from `/end-the-day`, reuse the file list it already
   gathered rather than re-scanning.

2. **Scan those files for candidate achievements.** Not limited to existing
   bullets - look for anything that reads like a concrete achievement:
   something shipped, fixed, decided, resolved, agreed, caught before it
   became a problem, or positive feedback received or given. This can be a
   single bullet, a dated note entry, or a whole note that's itself a
   finished piece of work (a completed research doc, a finished reference
   note). Skip anything that's already an existing `#brag` bullet in the
   Daily note.

3. **Draft a short bullet for each candidate**, written as its own
   standalone sentence a reader would understand with no other context -
   don't just copy the source wording verbatim, since vault notes are often
   long, jargon-heavy, or full of internal references (ticket numbers, other
   people's names used as shorthand, cross-note pointers). Lead with what's
   actually impressive about it. End with a `[[wikilink]]` back to the
   source note, then `#brag`.

4. **Present all drafts together as one checkbox list** (e.g. via
   AskUserQuestion with multiSelect, one option per candidate, plus a final
   "None of these" option), so the user ticks the ones they want in a single
   pass rather than answering yes/no per item. Show each drafted bullet and
   which note it's drawn from. Include "None of these" even when there's only
   one candidate, so declining doesn't mean ticking a real draft just to
   submit.

5. **Only add the bullets that were ticked.** Append each under the Daily note's notes
   section (or wherever today's other `#brag` bullets already live), as its
   own new line. Never edit the source note - the achievement gets a fresh
   short-form line in the Daily note, the original stays untouched.

6. **If nothing looks brag-worthy**, just say so briefly rather than
   forcing the conversation.

7. **Watch for near-duplicates** against `#brag` bullets already added to
   today's Daily note - if a new draft covers the same underlying work as
   an existing bullet, flag the overlap and ask whether to replace the
   existing line with the fuller version rather than adding a duplicate.

## Guardrails

- Never add a bullet the user didn't tick - don't infer consent for anything
  left unticked.
- Never edit the source note the achievement was found in - only the Daily
  note gets a new line.
- Never touch the aggregating "Brag list" note itself, if you have one - it
  should be a generated view (e.g. a Dataview query), not something this
  skill writes to directly.

## Notes on conventions

- Adapt the tag (`#brag`) and the aggregating note's location to your own
  vault setup - this skill assumes both already exist.
