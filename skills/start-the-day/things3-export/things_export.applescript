tell application "Things3"
	set outputLines to {}
	set allTodos to to dos whose status is open
	repeat with t in allTodos
		set todoName to name of t
		set groupName to "No Area"
		try
			set theProject to project of t
			if theProject is not missing value then
				set groupName to name of theProject
			else
				set theArea to area of t
				if theArea is not missing value then
					set groupName to name of theArea
				end if
			end if
		end try
		set dueStr to ""
		try
			set dd to due date of t
			if dd is not missing value then
				set dueStr to (dd as string)
			end if
		end try
		set tagStr to ""
		try
			set tagNames to tag names of t
			set tagStr to tagNames
		end try
		set createdStr to (creation date of t) as string
		set end of outputLines to groupName & tab & todoName & tab & dueStr & tab & tagStr & tab & createdStr
	end repeat
	set AppleScript's text item delimiters to linefeed
	set outputText to outputLines as string
	set AppleScript's text item delimiters to ""
	return outputText
end tell
