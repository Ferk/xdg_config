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
    # Attempt first to use alternative completion when provided
    if [[ $COMP_HISTORY_PRECOMP ]] && eval "$COMP_HISTORY_PRECOMP"
    then
	[[ $COMPREPLY ]] && return
    fi

    local esc_line=$(echo "${COMP_LINE:=$1}" | sed 's_\([][\.$\-\\|]\)_\\\1_g')

    COMPREPLY=($(history | sed -n "s|^[0-9: \-]* ${esc_line}|${esc_line##* }|p"))
    if [[ ! $COMPREPLY ]]
    then
	# When no completion was found, use filedir on last word
	_filedir_xspec $@
    fi
}

# The "_minimal" function is used in _completion_loader
# as the default completion function when no other function
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


# There are also some commands, like 'make', 'wget' programs that use
# urls, etc; where it might be useful to keep the proper completion
# function while using "_history" as a fallback when no completions
# were found (to complete urls or other parameters).
#
# For this, add wrappers for 'complete' and '_completion_loader'.
# The bash array COMP_USE_FALLBACK can be used to indicate such commands. 
_complete_with_fallback()
{
    local compfn
    if [[ $1 != '-F' || -z $2 || $2 == _minimal ]]
    then 
	builtin complete $@
	return $?
    else
	compfn=$2
	shift 2
	eval "${compfn}_with_fb() { COMP_HISTORY_PRECOMP=\"$compfn\" _history \$@; }"
	builtin complete -F ${compfn}_with_fb $@
    fi
}

_completion_loader_with_fallback()
{
    for cmd in "${COMP_USE_FALLBACK[@]}"
    do
	if [[ $cmd == "${1##*/}" ]]
	then	    
	    alias complete=_complete_with_fallback
	    _completion_loader $@
	    unalias complete
	    return 124
	fi
    done
    _completion_loader $@
} &&
complete -D -F _completion_loader_with_fallback

[[ $COMP_USE_FALLBACK ]] || 
COMP_USE_FALLBACK=(make wget chromium firefox)

