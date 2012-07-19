#!/bin/sh
#
# Syncs the backups stored in the specified directory
# with the system-wide files in /
#
# It will ask confirmation for every file to apply the changes or
# discard them entirely.
#
# Fernando Carmona Varo
#

BAKDIR="${XDG_USER_CONFIG:-$HOME/.config}"/ROOT

for bak in $(find "$BAKDIR/" -type f )
do
    dest=${bak#$BAKDIR}

    [ -f "$dest" ] || {
	echo "$dest : file doesn't exist, copying it"
	sudo mkdir -p $(dirname $dest)
	sudo cp -vi "$bak" "$dest"
	continue
    }
    
    [ "$dest" -nt "$bak" ] && {
	new=$dest
	old=$bak
    } || {
	new=$bak
	old=$dest
    }

    DIFF=$(sudo diff -u "$old" "$new")
    [ -z "$DIFF" ] && continue

    action=$(dialog --title "Sync changes to $old" --scrollbar --menu "$(echo "$DIFF")" 0 0 0 \
	Apply "Apply Changes to the file, overwritting the current one" \
	Revert "Revert all changes from the newer file, losing them" 2>&1 >/dev/tty )
    
    echo $action
    if [ "$?" = "0" ]; then
	if [ "$action" = "Revert" ]; then
	    bak="$old" # exchange old and new
	    old="$new"
	    new="$bak"
	fi
	sudo cp -vi  "$new" "$old"
	# case "$old":
	#     "/etc/sudoers")
	#     chmod 660 "$old"
	#     ;;
	#     *)
	# 	;;
	# esac
	
    fi
done



