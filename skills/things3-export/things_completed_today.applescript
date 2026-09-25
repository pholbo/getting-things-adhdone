-- Lists Things3 to-dos completed on a given date (default: today), one per
-- line, tab-separated: group (project or area), name, tags, completion date.
-- Usage: osascript things_completed_today.applescript [YYYY-MM-DD]
-- Used by the log-completed-tasks skill.

-- Areas to leave out of the log (e.g. personal life). Empty list = keep everything.
property excludedAreas : {"Personal"}

on run argv
	set targetDateStr to ""
	if (count of argv) > 0 then set targetDateStr to item 1 of argv

	if targetDateStr is "" then
		set dayStart to (current date)
		set time of dayStart to 0
	else
		-- Build the date field by field, so it works whatever the system's date format is
		set dayStart to (current date)
		set day of dayStart to 1
		set year of dayStart to (text 1 thru 4 of targetDateStr) as integer
		set month of dayStart to (text 6 thru 7 of targetDateStr) as integer
		set day of dayStart to (text 9 thru 10 of targetDateStr) as integer
		set time of dayStart to 0
	end if
	set dayEnd to dayStart + 1 * days

	tell application "Things3"
		set outputLines to {}
		set doneTodos to to dos of list "Logbook"
		repeat with t in doneTodos
			set compDate to completion date of t
			if compDate is not missing value and compDate ≥ dayStart and compDate < dayEnd then
				set todoName to name of t
				set groupName to "No Area"
				set areaName to ""
				try
					set theProject to project of t
					if theProject is not missing value then
						set groupName to name of theProject
						try
							set projArea to area of theProject
							if projArea is not missing value then set areaName to name of projArea
						end try
					else
						set theArea to area of t
						if theArea is not missing value then
							set groupName to name of theArea
							set areaName to groupName
						end if
					end if
				end try
				if excludedAreas does not contain areaName then
					set tagStr to ""
					try
						set tagStr to tag names of t
					end try
					set end of outputLines to groupName & tab & todoName & tab & tagStr & tab & (compDate as string)
				end if
			end if
		end repeat
		set AppleScript's text item delimiters to linefeed
		set outputText to outputLines as string
		set AppleScript's text item delimiters to ""
		return outputText
	end tell
end run
