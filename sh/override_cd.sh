#!/bin/sh




# Show Version Control status after cd'ing to a versioned directory
cd() {
    [ -z "$1" ] && builtin cd && return $?
    builtin cd "$1" "$2" && {
	## Git check
	git rev-parse --git-dir 2>&- >&- && {
	    git status -bs --untracked-files="no" #| column -c $COLUMNS
	    git log -3 --pretty=format:'%an, %ar: %s' | cut -c -$COLUMNS
	} || svn status -q 2>&-
	true
    }
}

