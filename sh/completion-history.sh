#  -*- Shell-Script -*-
#
# Bash completions using bash history
#
# Fernando Carmona Varo

# Missing autocompletions, that we don't want to override with _history
complete -F _pacman pac packer
# complete -F _aptitude a
complete -F _root_command sudo
complete -F _filedir_xspec e
complete -F _filedir_xspec mpv

# Autocomplete using previous history
# The COMP_LINE variable holds the currently entered input
# The function will return the remaining of the matching lines, 
# this will be done per word (no partial words will be shown).
_history() {
    history | sed -n "s/^[0-9: \-]* ${COMP_LINE:=$1}/${COMP_LINE##* }/p"
}
complete -C _history \
    browser chromium firefox t mount.iso pomodoro wicd-cli xmacroplay

# Apply _history completion for every suitable command in history
# that doesn't have a completion facility already.
for cmd in $(cat "$HISTFILE" | sed -n "s/\(\w*\).*/\1/p" | sort | uniq)
do
    if ! hash $cmd 2>&-
    then continue
    fi
    complete | grep -q " $cmd\$" || complete -C _history "$cmd"
done

