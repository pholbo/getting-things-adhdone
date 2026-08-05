<%*
const personName = (await tp.system.prompt("Person's full name?"))?.trim();
if (!personName) return;

const personTag = (await tp.system.prompt(
  "Person tag?",
  personName.split(/\s+/)[0].toLowerCase()
))?.trim().toLowerCase();
if (!personTag) return;

const meetingDate = (await tp.system.prompt("Meeting date (YYYY-MM-DD)?"))?.trim();
if (!meetingDate) return;

await tp.file.rename(`${meetingDate} 1-1 ${personName}`);
-%>
---
created: <% tp.date.now("YYYY-MM-DD HH:mm") %>
meeting_date: <% meetingDate %>
tags:
  - 1-1-meeting
---
## Topics to discuss

```tasks
not done
tags include #1-1
tags include #<% personTag %>
sort by created
```

## Notes
