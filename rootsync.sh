#!/bin/sh


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
    
    dialog --title "Sync changes to $old" --scrollbar --menu "$(echo "$DIFF")" 0 0 0 \
	Apply "Apply Changes to the file, overwritting the current one" \
	Revert "Revert all changes from the newer file, losing them" 2>/tmp/dialog.tmp

    action=$(cat /tmp/dialog.tmp; rm /tmp/dialog.tmp)
    echo $action
    if [ "$?" = "0" ]; then
	if [ "$action" = "Revert" ]
 	then sudo cp -vi  "$old" "$new" 
	else sudo cp -vi  "$new" "$old"
	fi 
    fi
done



