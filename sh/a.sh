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
	echo -ne '\a'

	if hash beep 2>/dev/null
	then
		beep -f 5000 -l 50 -r 2
	fi &
}


