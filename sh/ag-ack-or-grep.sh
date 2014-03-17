#!/bin/sh

# Check if 'ag' is available
# If not use ack or a custom grep function

if hash ag 2>&-
then
	unalias ag 2>/dev/null
	
elif hash ack 2>&-
then
	alias ag=ack
	
else
	ag() {
		[ "$1" ] || { echo 'usage: ag PATTERN [FILES OR DIRECTORIES]'; return; }
		
		local pattern="$1"
		shift
		grep "${@:-.}"	--color=always --exclude=.[^.]* --exclude=node_modules -nHre "$pattern" | less -R -F -X
	}
fi

