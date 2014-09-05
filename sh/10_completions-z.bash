



_complete_z() {
    local COMPREPLY=( $(_z --complete "$READLINE_LINE") )

    if [[ ${#COMPREPLY[@]} == 1 ]]
    then
	READLINE_LINE=$COMPREPLY
    else
	echo ${COMPREPLY[@]} | column -t -c 80
    fi
}


# Cause shell-command to be executed whenever keyseq is entered. When
# shell-command is executed, the shell sets the READLINE_LINE variable
# to the contents of the Readline line buffer and the READLINE_POINT
# variable to the current location of the insertion point. If the
# executed command changes the value of READLINE_LINE or
# READLINE_POINT, those new values will be reflected in the editing
# state.
bind -x '"\ea":"_complete_z"'




