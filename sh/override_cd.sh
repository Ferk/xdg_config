#!/bin/sh

# Show Version Control status after cd'ing to a versioned directory
cd() {
    [ -z "$1" ] && builtin cd && return $?
    builtin cd "$1" "$2" && timeout 1s sh <<EOF
	## Version control check
	if git rev-parse --git-dir >/dev/null 2>&1
	then
		git status -bs --untracked-files="no" #| column -c $COLUMNS
		git log -3 --pretty=format:'%an, %ar: %s' | cut -c -$COLUMNS
		
	elif svn info >/dev/null 2>&1
	then
		# Show svn status, but if it takes more than 1 second only cache it on background
		if ! svn status --non-interactive -q 2>/dev/null
		then
			svn status -q >/dev/null &
		fi
	fi
EOF
}

