---
name: search-mail
description: >
  Searches your email on request via AppleScript against Apple Mail - by
  subject, sender, or date - and reads back matching messages. Local and
  read-only, the same trick pick-meetings-to-prep uses for Calendar.app, so
  it doesn't need an OAuth mail connector. Never sends, deletes, moves, or
  marks anything read. Standalone, on-request only. Trigger: /search-mail,
  or asking to find/check/look up an email.
---

# Search Mail

## Purpose

Lets you ask "find the email from X about Y" and get an answer, without
connecting an OAuth mail connector to a work or personal inbox - useful if
that kind of connector isn't available to you, isn't vetted for your
organisation's data yet, or you'd simply rather not grant it broad account
access for something you only need occasionally. This works entirely
through Mail.app, which already has your account(s) configured locally, so
it's local file/app access rather than a connector - same category of
workaround as `pick-meetings-to-prep`'s use of `icalBuddy` against
Calendar.app instead of a Google Calendar connector.

On-request only, like `link-task` - this is not a standing daily scan, and
doesn't get called from `start-the-day` or `end-the-day` unless you
specifically wire that up yourself.

**Requires the account in question to be configured in Apple Mail** -
AppleScript can only see what Mail.app itself has set up. If your email
only lives in a browser tab, this doesn't apply until you add it as an
account in Mail.app.

## Trigger

`/search-mail`, or asking to find, check, or look up an email/thread.

## Process

1. **Confirm the search terms** if you haven't given something specific
   enough to search on directly - a sender name/domain, a subject keyword,
   or a rough date range. Don't guess at vague requests.

2. **Search by subject or sender first, not body content.** Searching
   `content contains` across a large mailbox is much slower than subject/
   sender since it has to fetch full message bodies to filter - only fall
   back to a content search if subject/sender genuinely doesn't narrow it
   down enough, and say so, since it'll be slower.

3. **Query via AppleScript against Mail.app**, targeting the right account.
   First confirm the account name: `osascript -e 'tell application "Mail"
   to get name of every account'`.
   - **Known quirk** (tested against a Gmail account synced into Mail.app):
     referencing a special mailbox like `mailbox "All Mail" of account
     "<name>"` by direct name can fail with error -1728 ("Can't get
     mailbox"), even though that mailbox genuinely exists and shows up when
     you list `every mailbox of account "<name>"` by name. Ordinary
     mailboxes (`"INBOX"`, `"Sent Mail"`) don't have this problem. If a
     plain by-name reference throws -1728, iterate `every mailbox of
     account "<name>"` and match by `name` instead, rather than assuming
     the mailbox doesn't exist.
   - Default to whichever mailbox best represents "everything" for the
     account in question (e.g. "All Mail" for Gmail-backed accounts, since
     it covers inbox, archive, and anything filed elsewhere) unless asked
     to narrow to Sent or a specific mailbox.
   - Example query shape:
     ```
     tell application "Mail"
       set acct to account "<account name>"
       set targetBox to missing value
       repeat with m in (every mailbox of acct)
         if name of m is "<mailbox name>" then
           set targetBox to m
           exit repeat
         end if
       end repeat
       set theMessages to (messages of targetBox whose subject contains "<term>")
       -- collect subject, sender, date received of m as string, for each
     end tell
     ```

4. **Present matches as a short list first** (subject, sender, date) rather
   than dumping full bodies - if there are several hits, ask which one(s)
   are actually worth reading in full before pulling `content of m` for
   each. If there's an obvious single match, just read it.

5. **Read back the message content plainly** - `content of m` returns the
   body text directly, no further parsing needed for plain-text mail. Note
   if a message looks HTML-heavy/hard to read as plain text rather than
   silently returning a garbled result.

6. **For a full thread (several messages on one subject), present a
   deduplicated chronological summary, not raw output.** Each reply's
   `content` includes the full quoted history beneath it, so pulling every
   message in a thread means the same earlier messages appear repeatedly.
   Read the messages, work out the actual chronology, and summarise each
   real message once, in order - skip pure auto-replies (out-of-office,
   etc.) unless specifically asked about those. Don't just paste the raw
   AppleScript output.

## Guardrails

- Read-only, always. Never send, reply, forward, delete, move, flag, or
  mark anything read/unread via this skill.
- Never search or summarise mail proactively - only when asked, for the
  specific thing that was asked about, right now.
- If a search returns nothing, say so plainly rather than broadening the
  search silently - ask before trying a looser match.
- Account/mailbox names are specific to how Mail.app is configured on your
  machine and can change (renamed, removed, email moves off Mail.app
  entirely) - if a search unexpectedly returns nothing that should be
  there, re-verify the account name rather than assuming the mail isn't
  there.
