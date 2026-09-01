---
name: pick-meetings-to-prep
description: >
  Reads today's calendar and lets you multiselect which events to prep for,
  running the prep-meeting skill once per selection. Standalone, or run as a
  step from start-the-day. Trigger: /pick-meetings-to-prep, or asking what's
  on today / which meetings to prep.
---

# Pick Meetings to Prep

## Purpose

Turn today's calendar into a short list of meetings worth prepping, without
making you prep every single thing on it. This skill only reads the
calendar and hands off - the actual prep work belongs to `prep-meeting`.

**This is one way to get Claude your diary, not the only way.** The example
below reads a macOS Calendar.app calendar via `icalBuddy` (the author's
setup: a Google Calendar account synced into Calendar.app). If you're not on
macOS, don't want a calendar integration, or Claude Code doesn't have
read access to your calendar in your setup, the simplest substitute is to
skip this skill entirely and just tell Claude which meetings you want to
prep for directly - `start-the-day` can ask that as a plain conversational
question instead of running this step, and `prep-meeting` doesn't care how
it was invoked. Swap in whatever calendar-read method fits your platform
(an API call, a different CLI tool, an exported .ics file) if you want the
automated version without this exact dependency.

## Trigger

`/pick-meetings-to-prep`, or asking what's on today or which meetings to
prep. Also invoked as a step by `/start-the-day`.

## Process

1. **Read today's calendar.** Example command for the author's setup
   (macOS, Google Calendar synced into Calendar.app):
   `icalBuddy -ic "<calendar name>" -nc -iep "title,datetime" -b "- " -df "" -tf "%H:%M" eventsToday`
   Requires `icalBuddy` (installed via Homebrew: `brew install ical-buddy`)
   - if the command isn't found or doesn't apply to your setup, say so
     rather than silently falling back to asking the user to list their
     meetings verbally (that's a legitimate fallback, just make it an
     explicit choice, not a silent substitution).
   - Note from the author's testing: plain AppleScript against Calendar.app
     doesn't work reliably for this - it returned a recurring event's
     original start date rather than today's actual occurrence, so date
     filtering silently returned the wrong events. `icalBuddy` expands
     recurrence correctly and was the only tested path that did.
2. **If there are no events today, say so and stop** - nothing to
   multiselect.
3. **Present the event titles (with times) as a multiselect question** so
   the user picks which ones they want to prep for.
4. **For each meeting selected, run the `prep-meeting` skill.** That skill
   handles finding/creating the meeting note and linking it into today's
   Daily note - this step is just the loop that invokes it once per
   selected meeting.

## Guardrails

- Read-only against the calendar and your task manager - this skill never
  creates or modifies calendar events or tasks.
