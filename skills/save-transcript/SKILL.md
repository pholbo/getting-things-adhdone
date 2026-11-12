---
name: save-transcript
description: >
  Saves a meeting transcript you've shared (e.g. a Gemini notes file or an
  Otter export) into the vault as its own note, tagged `transcript` plus one
  client/person/topic tag, filed next to the meeting and linked from the
  dated meeting note if one exists. Text only, with minimal tidying of
  misheard brand, product and people names - never audio. Runs in the
  background without being asked: trigger it automatically whenever you give
  Claude a meeting transcript to read, for any reason, as well as on
  /save-transcript.
---

# Save Transcript

## Purpose

Keep a searchable copy of every meeting transcript in the vault, so later
sessions can check what was actually said rather than relying on memory or
an auto-generated summary. Summaries lose who said what, and an individual's
passing assumption can get flattened into "the client's position" - the raw
transcript is the thing to go back to.

## Trigger

- Automatically, whenever a meeting transcript is shared in a session - even
  if the user only asked for something else (an email draft, a note
  update). Do the save alongside that work; don't wait to be asked. If you'd
  rather it only ran on request, drop this line.
- `/save-transcript`, or asking to save a transcript.

## What gets saved

- **Text only.** Never copy audio (mp3, m4a, wav) into the vault.
- **Audio only, no text transcript:** don't create a note - the user can
  pull it from the recording tool if needed. Say so in one line.
- **Gemini notes files:** save only the transcript section. Strip any
  embedded base64 screenshot lines first (`grep -v "base64,"`), then find
  the transcript heading with `grep -n "Transcript"` - its exact wording
  varies between files, so search rather than hardcoding it. Drop everything
  above it (Gemini's auto-summary). Also drop the closing "computer
  generated" disclaimer and any `{#00:00:00}` anchors after timestamp
  headings, which show up as literal text in Obsidian.
- **Otter exports:** if it's a zip, unzip into a scratch folder and save the
  `_transcript.txt` content only.
- **Two transcripts of the same meeting** (e.g. Gemini and Otter): save just
  one - the one with better speaker names and accuracy on your product
  terms (for the author, that's Gemini). In the one-line report, mention the
  other exists and offer to cross-check the two. Only run the check on a
  yes, because comparing two long transcripts is token-heavy.
- **How to cross-check (on a yes):** don't read both transcripts in full.
  For each word Claude was unsure of in the saved text, search the other
  transcript for a distinctive phrase next to it and compare the two
  versions there. Fix the ones the second transcript makes clear, even when
  the mis-hearing wasn't a name. Leave and report any it doesn't cover or
  also gets wrong. When both tools hear the same odd word, it was probably
  said that way, so keep the best-guess fix and flag it.
- **Audio and text both given:** save the text as normal, but ask whether
  the audio should also be used to check the text's accuracy (it may have
  been shared for that reason). Handle any such check ad hoc - it isn't part
  of this skill. If it's unclear what's wanted, ask rather than guess.

## Tidying - minimal

- Fix misheard brand, product and people names only (e.g. a product name
  transcribed as two unrelated words). Use names already in the vault
  (client notes, memory) as the reference.
- Don't paraphrase, summarise, remove filler words, or re-split turns.
- Keep speaker labels as the source gives them. If a label is clearly
  wrong, leave it and mention it rather than silently changing it.
- Build the note with shell tools (copy the section, then `sed` the name
  fixes) rather than retyping the transcript - it's cheaper and avoids
  accidental rewording.

## Process

1. **Work out the meeting** - date, title, and whether it's a client call, a
   1-1, a project meeting, or general. Use the filename, the transcript's
   opening lines, and any meeting note for that date.
2. **Pick the folder** - next to where that meeting's notes already live
   (e.g. a clients folder for client calls, a project folder for
   project-scoped meetings, the general notes folder otherwise). If the
   folder is obvious, don't ask. Ask only when the client, project or
   meeting is genuinely unclear.
3. **Pick the tags** - exactly two, in a YAML `tags:` array:
   - `transcript` (as the type tag, in place of e.g. `meeting`)
   - the client's existing flat tag (copy it from that client's other
     notes), or the person's tag for a 1-1, or one topic tag otherwise
4. **Create the note** `YYYY-MM-DD Meeting title - transcript.md`:

   ```
   ---
   created: YYYY-MM-DD
   meeting_date: YYYY-MM-DD
   source: gemini | otter
   tags:
     - transcript
     - clienttag
   ---
   Meeting note: [[YYYY-MM-DD Meeting - Title]]

   ## Transcript

   (transcript text)
   ```

   Leave out the `Meeting note:` line if there's no meeting note. Pick one
   value for `source`.
5. **Link from the meeting note.** If a dated meeting note exists for that
   meeting, add one line near the top: `Transcript: [[note name]]`. Don't
   create a meeting note if none exists, and don't touch anything else in
   it.
6. **Report in one line** - where it was saved, and any names fixed or
   speaker labels that looked wrong. Then carry on with whatever was
   actually asked for.

## Guardrails

- Never save a summary in place of the transcript, and never save audio.
- Never move or delete the source file.
- If a transcript note for the same meeting already exists, don't overwrite
  it - ask.
- Anything drafted later in the session (emails, notes) should still work
  from the raw transcript, not a summary of it.

## Notes on conventions

- Flat tags only, never nested.
- No em-dashes in anything written into notes - hyphens instead (edit to
  taste).
