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
# COMPREPLY array will store the remaining of the matching lines, 
# this will be done per word (no partial words will be shown).
_history() {
    local esc_line
    esc_line=$(echo "${COMP_LINE:=$1}" | sed 's_\([][\.$\-\\|]\)_\\\1_g')

    COMPREPLY=($(history | sed -n "s|^[0-9: \-]* ${esc_line}|${esc_line##* }|p"))
    if [[ ! $COMPREPLY ]]
    then
	# When no completion was found, use filedir on last word
	_filedir_xspec $@
    fi
}
complete -F _history \
    browser chromium firefox t mount.iso pomodoro wicd-cli xmacroplay


# The "_minimal" function is used in _completion_loader
# as the default completion function when no better completion
# could be found.
#
# By default it ends up using "_filedir", let's make it use
# our "_history" function instead
_minimal()
{
    local cur prev words cword split
    _init_completion -s || return
    $split && return
    _history $@
}

