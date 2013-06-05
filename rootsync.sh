#!/bin/bash -e
#
# Syncs the backups stored in the specified directory
# with the system-wide files in /
#
# It will ask confirmation for every file to apply the changes or
# discard them entirely.
#
# Fernando Carmona Varo
#

# Source directory to be synced with the root directory tree
SRCDIR="${XDG_USER_CONFIG:-$HOME/.config}"/ROOT

if [ $(id -u) -ne 0 ]
then
    sudo -Ep "This tool must be run as root. Enter password:" "$0" "$@"
    exit $?
fi

cd "$(dirname "$0")"
[ -d "$SRCDIR" ] || { echo "Source directory '$SRCDIR' not found."; exit 1; } 

seloption() {

    # If set to accept all changes, don't ask
    [ -z "$acceptall" ] || return 0;

    echo -e "+ \e[36mThere are changes to apply to \"$old\""
    local ret
    select action in  "Apply Changes to the file, overwritting the current one (can also press Control+D)" \
	"Revert all changes from the newer file, losing them" \
	"Ignore this file" \
	"Show diff" \
	"Edit $new and apply the changes" \
	"Ignore all files and cancel update" \
	"Accept ALL changes and perform update without asking again"
    do
    
    case "$action" in
	Apply*)
	    echo apply
	    ret=0
	    break
	    ;;
	Revert*)
	    local tmp="$old" # exchange old and new
	    old="$new"
	    new="$tmp"
	    ret=0
	    break
	    ;;
	Ignore*)
	    ret=1
	    break
	    ;;
	Show*)
	    diff -u "$old" "$new" | ${PAGER:-less}
	    continue
	    ;;
	Edit*)
	    ${EDITOR:-nano} "$new" 
	    ret=0
	    break
	    ;;
	Accept*)
	    acceptall="true"
	    ret=0
	    break
	    ;;
	Exit*)
	    exit 1
	    ;;
	*)
	    echo none
	    break
	    ;;
    esac
    done
    echo -ne "\e[0m"
    return $ret
}

# Replace $2 with the data in $1 without altering $2's owner
owninstall() {
    # Replace
    local owner=$(stat -c%U "$2")
    install -o "$owner" -v "$1" "$2"
}

for sfile in $(find "$SRCDIR" -type f \( ! -path '*/.svn/*'  \) \( ! -path "*/.git*"  \) \( ! -path "*[#~]"  \) )
do
    # obtain root file path from source file path
    rfile="${sfile#$SRCDIR}"

    [ -f "$rfile" ] || {
	echo "$rfile : file doesn't exist, copying it"
	sudo mkdir -p "$(dirname $rfile)"
	install -v "$1" "$2"
	continue
    }
    
    if [ "$rfile" -nt "$sfile" ]
    then
	new=$rfile
	old=$sfile
    else
	new=$sfile
	old=$rfile
    fi
    
    if diff -u "$old" "$new"
    then
	unchanged+="\n$new"
	continue
    fi
    seloption || continue

    owninstall "$new" "$old"
    change=yes;
done

echo -e "Unresolved files: ${unchanged}"

if [ "$change" ]
then
    echo "Assuring permissions..."

    # Make sure the relevant files have the right permissions
    chmod 440 /etc/sudoers.d/*
    #chmod g+rw -R /var/www/

#    echo "Syncing filesystem..."
#    # Force a filesystem sync so that changes are saved to disk
#    sync
fi


