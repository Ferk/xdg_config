#!/bin/sh
#
# Adds the "a" function that emits a beep sound with the intention to
# be used as alarm to notify when something has finished.
#
# It's intended to be used from the commandline with things like this:
# $ really_slow_command ; a
#

function a() {
	# This would be useful if your terminal is set up to trigger the
	# 'urgent' property to your windowmanager, so the window will blink.
	printf '\a'
	( 
		if hash beep
		then
			beep -f 5000 -l 50 -r 2
		elif hash rundll32
		then
			# kernel32.dll,Beep might also work, but I can't get any
			# pleasant sound
			rundll32 user32.dll,MessageBeep -1
		elif hash say
		then
			say "ding"
		fi &
	) 2>/dev/null
}
