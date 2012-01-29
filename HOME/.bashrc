# ~/.bashrc: executed by bash(1) for non-login shells.
#
# This file is executed for each subshell opened by bash.
# For some variables and initialization that is not bash-specific or that is
# intended to be executed only once, see ~/.profile
#
# Also see /usr/share/doc/bash/examples/startup-files (installing bash-doc)
# for other bashrc examples
#
# Fernando Carmona Varo <ferkiwi@gmail.com>
#

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# List of commands to ignore (& means ignore duplicates)
export HISTIGNORE="&:??:exit:history"

export HISTSIZE=100000

shopt -s checkwinsize # refresh LINES and COLUMNS when window size changes
shopt -s cdspell dirspell # spelling corrections when cd'ing and globbing
shopt -s globstar # recursive globbing with **
shopt -s no_empty_cmd_completion # dont autocomplete on empty lines
shopt -s checkjobs # needs to double close if there are pending jobs

# Color! ...if the terminal where this subshell is running supports it
[ "$TERM" != "dumb" ] && {

    # set LS variable for ls filename colorization (see ~/.dir_colors)
    hash dircolors 2>&- && eval "$(dircolors -b ~/.dir_colors)"

    # Colorize (red) the stderr output in the terminal
    [ -f "/usr/lib/stderred.so" ] && export LD_PRELOAD="/usr/\$LIB/stderred.so"


### Formatting escape codes
# 00: none
# 01: bold
# 04: undeline
# 05-6: blink (slow-fast)
# 07: invert colors
# 08: concealed
# 38: next argument "5;x", "x" is a fg 0-256 color
# 48: next argument "5;x", "x" is a bg 0-256 color
# 30-37: fg color (dark)
# 40-47: bg color (dark)
# 90-97: fg color (bright)
# 100-107: bg color (bright)
## *0-*7 colors:
# 0:black 1:red 2:green 3:yellow 4:blue 5:purple 6:cyan 7:white

    ###
    # Fancy Prompt

    # Different color according to error value
    ERRCOLOR='eval [[ $? = 0 ]] && echo -ne "\e[32m" || echo -ne "\e[31m";'
    PS1='\[\e[33m\]\t \[$($ERRCOLOR)\]\u\[\e[0m\]:\[\e[94m\]\w\[\e[0m\]\$ '


    [ "$DISPLAY" ] && {
        # Show current running command in window title (but not $PROMPT_COMMAND)
	on_debug() { printf "\e]2;%s\a" "${BASH_COMMAND/\\/\\\\}"; }
	trap on_debug DEBUG
        # If not running a program, show this title instead
	PROMPT_COMMAND='echo -ne "\e]2;${PWD/$HOME/~} - ${TERM}\a"'

       # # set iconname
       # echo -ne "\e]1;gnome-terminal\a"
    }
}

# Separate alias file
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases
# Custom programmable completion features 
[[ -f ~/.bash_completion ]] && . ~/.bash_completion


# Show Version Control status after cd'ing to a versioned directory
if hash vcprompt 2>&-; then 
    VCPS='vcprompt'
    export VCPROMPT_FORMAT="Version control: %n %b (%r%m) "
elif hash __git_ps1 2>&-; then 
    VCPS='__git_ps1'
fi
[[ "$VCPS" ]] && cd() {
    builtin cd "$1" "$2" "$3" && {
	${VCPS} && echo 
        #ls | fmt -w $COLUMNS | head -n 2 | sed '$s/$/ .../'
    }
}

#############################
# display login messages
echo -e "\e[36m $(uptime)"
#last -3 | head -n $(expr $(last -3 | wc -l) - 2)
echo -e '\e[33m'
fortune -cs
echo -e '\e[00m'

# mkdir -m 0700 /sys/fs/cgroup/cpu/user/$$
# echo $$ > /sys/fs/cgroup/cpu/user/$$/tasks

source /home/ferk/Source/ToolChain_STM32/ToolChain/scripts/SourceMe.sh
source /home/ferk/Source/ToolChain_STM32_1.0.34/ToolChain/scripts/SourceMe.sh
