# ~/.profile
#
#  Fernando Carmona Varo

#
# This is the standard Bourne/Korn shell configuration file
# it will be read only once on each login shell session.
# Any change will be applied after re-login, subshells won't
# reload the changes.
#
# Here should be the initial set-up commands, which create 
# environment variables that can be passed down to child processes.
#

# add personal executables directory to system PATH
export PATH="$PATH:$HOME/bin/"
# other executable folders wanted
##export PATH="$PATH:/root/.gem/ruby/1.9.1/bin"
export PATH="$PATH:$HOME/.gem/ruby/1.9.1/bin"

# In a mac, use coreutils
if [ "$(uname -s)" = "Darwin" ]
then
    export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
    export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
fi


# search path for "cd", for faster directory switching
export CDPATH=".:$HOME"

#export LANG="es_ES.utf8"
export LANG="C"
export LC_ALL=
export LC_COLLATE="C"

# Find the preferred basic tools and hash them for faster access
for cmd in "emacsclient --alternate-editor=emacs " "emacs" "nano" "vi"; do
    EDITOR="$cmd"
    hash ${EDITOR%% *} 2>&- && break
done
for cmd in "less" "more"; do
    PAGER="$cmd"
    hash ${PAGER%% *} 2>&- && break
done
#for cmd in "firefox" "chromium --purge-memory-button" "links"; do
for cmd in "chromium --purge-memory-button" "firefox" "links"; do
    BROWSER="$cmd"
    hash ${BROWSER%% *} 2>&- && break
done
for cmd in "st" "urxvt" "rxvt" "xterm"; do
    XTERM="$cmd"
    hash ${XTERM%% *} 2>&- && break
done
export EDITOR PAGER BROWSER XTERM

# Freedesktop.org variables
export XDG_CONFIG_HOME=$HOME/.config/
export XDG_DATA_HOME=$HOME/.local/share/
export XDG_CACHE_HOME=$HOME/.cache/

# Load separate file with some aliases
[ -f $HOME/.sh_aliases ] && . $HOME/.sh_aliases

###
# "less" configuration
export LESS="-Rq -XF -P ?c<- .?f%f:Standard input.  ?n:?eEND:?p%pj\%.. .?c%ccol . ?mFile %i of %m  .?xNext\ %x.%t (h for help)"

#       ?f%f .?n?m(file %i of %m) ..?ltlines %lt-%lb?L/%L. : byte %bB?s/%s. .?e(END) ?x- Next\: %x.:?pB%pB\%..%t

# make less more friendly for non-text input, see lesspipe(1)
hash lesspipe.sh 2>&- && eval "$(lesspipe.sh)"

# long running ssh/gpg session (don't ask passwords every time)
hash keychain 2>&- && eval $(keychain --eval --quiet)

##### More colors for Less ;)
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

export LESS_TERMCAP_mb=$'\e[01;31m'       # blinking markout
export LESS_TERMCAP_md=$'\e[01;38;5;74m'  # bold markout
export LESS_TERMCAP_so=$'\e[1;104m'       # standout, info box
export LESS_TERMCAP_us=$'\e[04;38;5;146m' # underline

export LESS_TERMCAP_me=$'\e[0m'           # markout end
export LESS_TERMCAP_se=$'\e[0m'           # standout end
export LESS_TERMCAP_ue=$'\e[0m'           # underline end



# If bash, load the subshell configuration for it to be used in login shells too.
test $BASH && test -f ~/.bashrc && . ~/.bashrc

