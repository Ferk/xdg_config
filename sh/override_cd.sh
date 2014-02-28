#!/bin/sh




# Show Version Control status after cd'ing to a versioned directory
cd() {
    [ -z "$1" ] && builtin cd && return $?
    builtin cd "$1" "$2" && {

	## Version control check
	if git rev-parse --git-dir 2>&- >&-
	then
	    git status -bs --untracked-files="no" #| column -c $COLUMNS
	    git log -3 --pretty=format:'%an, %ar: %s' | cut -c -$COLUMNS

	elif svn info 2>$- >$-
	then
	    # Show svn status, but if it takes more than 1 second only cache it on background
	    if ! timeout 1s svn status --non-interactive -q 2>&-
	    then
		svn status -q >&- &
	    fi
	fi

    }
}

