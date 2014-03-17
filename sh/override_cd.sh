#!/bin/sh

# Custom 'cd' override for additional info and functions
cd() {
	builtin cd "$@" || {
		local err=$?
		if type -p _z
		then
			echo "cd: attempting to use next best directory match"
			_z "$@" && echo "$PWD"
			err=$?
		fi
		return $err
	}

	## Show version control status
	if git rev-parse --git-dir >/dev/null 2>&1
	then
		git status -bs --untracked-files="no" #| column -c $COLUMNS
		git log -3 --pretty=format:'%an, %ar: %s' | cut -c -$COLUMNS

	elif timeout 0.5s svn info >/dev/null 2>&1
	then
		# Show svn status, but if it takes more than 1 second only cache it on background
		if ! timeout 1s svn status --non-interactive -q 2>/dev/null
		then
			svn status -q >/dev/null &
		fi
	fi

	# Load the directory into the 'z' history (see z.sh)
	if hash _z >/dev/null
	then
		_z --add "$(pwd $_Z_RESOLVE_SYMLINKS 2>/dev/null)" 2>/dev/null
	fi
}
