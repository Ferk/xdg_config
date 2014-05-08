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

# Exclude some commands that load their own completion
# at runtime
exclude_completion_history="git"

# Autocomplete using previous history
# The COMP_LINE variable holds the currently entered input
# COMPREPLY array will store the remaining of the matching lines, 
# this will be done per word (no partial words will be shown).
_history() {
    local esc_line
    _init_completion || return

    esc_line=$(echo "${COMP_LINE:=$1}" | sed 's_\([][\.$\-\\|]\)_\\\1_g')
    
    COMPREPLY=($(history | sed -n "s|^[0-9: \-]* ${esc_line}|${esc_line##* }|p"))
    
    if [[ ! $COMPREPLY ]]
    then
	# When no completion was found, use filedir on last word
	_filedir_xspec 2>/dev/null
    fi
}
complete -F _history \
    browser chromium firefox t mount.iso pomodoro wicd-cli xmacroplay

# Apply _history completion for every suitable command in history
# that doesn't have a completion facility already.
for cmd in $(cat "$HISTFILE" | sed -n "s/\(\w*\).*/\1/p" | sort | uniq)
do
    if ! hash $cmd 2>&- || [[ $exclude_completion_history =~ $cmd ]]
    then continue
    fi
    complete | grep -q " $cmd\$" || complete -F _history "$cmd"
done

# remove the variable after use
unset completion_history_exclude

