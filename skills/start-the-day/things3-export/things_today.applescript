tell application "Things3"
	set todayTodos to to dos of list "Today"
	set outputLines to {}
	repeat with t in todayTodos
		set todoName to name of t
		set createdStr to (creation date of t) as string
		set end of outputLines to todoName & tab & createdStr
	end repeat
	set AppleScript's text item delimiters to linefeed
	set outputText to outputLines as string
	set AppleScript's text item delimiters to ""
	return outputText
end tell
