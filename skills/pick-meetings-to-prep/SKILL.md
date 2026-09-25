---
name: pick-meetings-to-prep
description: >
  Asks which of today's meetings you want to prep for (you name them - no
  calendar read by default), then runs the prep-meeting skill once per
  meeting you name. Standalone, or run as a step from start-the-day.
  Trigger: /pick-meetings-to-prep, or asking which meetings to prep.
---

# Pick Meetings to Prep

## Purpose

Get the list of meetings you want to prep for today and hand each one off to
`prep-meeting`. This skill only collects the list - the actual prep work
belongs to `prep-meeting`.

By default you just name the meetings yourself. The author originally had
Claude read the calendar automatically (see "Optional: an automated calendar
read" below), then dropped it: it broke when moving from the terminal to the
Claude desktop app, and chasing a fix was more effort than saying what's on.
Naming two or three meetings takes seconds, and you're the best judge of
which ones need prep anyway.

## Trigger

`/pick-meetings-to-prep`, or asking which meetings to prep. Also invoked as a
step by `/start-the-day`.

## Process

1. **Ask which meetings you want to prep for today.** A plain question in
   chat - reply with names or topics (and times if you like). Don't guess or
   suggest meetings.
2. **If the answer is none, say so and stop.**
3. **For each meeting named, run the `prep-meeting` skill.** That skill
   handles finding/creating the meeting note and linking it into today's
   Daily note - this step is just the loop that invokes it once per named
   meeting.

## Optional: an automated calendar read

If you'd rather Claude read your calendar and offer a multiselect, you can
swap step 1 for a calendar read. What the author learned trying this on
macOS:

- `icalBuddy` (`brew install ical-buddy`) reads events from Calendar.app,
  including a Google Calendar synced into it:
  `icalBuddy -ic "<calendar name>" -nc -iep "title,datetime" -b "- " -df "" -tf "%H:%M" eventsToday`
  It expands recurring events to today's actual occurrence.
- Plain AppleScript against Calendar.app is unreliable here - it returned a
  recurring event's original start date rather than today's occurrence, so
  date filtering silently returned the wrong events.
- macOS grants calendar access per app. `icalBuddy` worked from Terminal, but
  from the Claude desktop app it saw no calendars at all ("No calendars"),
  because the desktop app doesn't request calendar permission and so never
  appears in System Settings to be granted. If you use the desktop app, expect
  this route not to work.
- Fetching a Google Calendar secret ICS feed via a web-fetch tool misdated
  recurring events, because the fetch summarises the feed rather than parsing
  it. Avoid it for anything date-sensitive.

Whatever method you use, if the read fails, say so rather than silently
falling back to asking - make the fallback an explicit choice.

## Guardrails

- Never invent meetings or tasks.
- Never create or modify calendar events.
