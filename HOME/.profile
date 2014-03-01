# -*- shell-script -*-
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
export PATH="$PATH:$HOME/bin"
# other executable folders wanted
##export PATH="$PATH:/root/.gem/ruby/1.9.1/bin"
export PATH="$PATH:$HOME/.gem/ruby/1.9.1/bin"
export PATH="$PATH:/usr/local/share/npm/bin"

# In a mac, use coreutils
if [ "$(uname -s)" = "Darwin" ]
then
    export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/sbin:/usr/local/bin:$PATH"
    export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
fi

[ -d "$HOME/perl5" ] && {
    export PERL_LOCAL_LIB_ROOT="$HOME/perl5";
    export PERL_MB_OPT="--install_base $HOME/perl5";
    export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5";
    export PERL5LIB="$HOME/perl5/lib/perl5/i686-linux-thread-multi:$HOME/perl5/lib/perl5";
    export PATH="$HOME/perl5/bin:$PATH";
}

# search path for "cd", for faster directory switching
export CDPATH=".:$HOME"

export LANG="C"
export LC_ALL="C"
export LC_COLLATE="C"

# Find the preferred basic tools and hash them for faster access
for cmd in 'emacsclient --alternate-editor= -c ' 'emacs' 'nano' 'vi'; do
    EDITOR="$cmd"
    hash ${EDITOR%% *} 2>&- && break
done
for cmd in "less" "more"; do
    PAGER="$cmd"
    hash ${PAGER%% *} 2>&- && break
done
for cmd in "chromium --purge-memory-button --proxy-pac-url=file:///home/ferk/.config/browser/proxy.pac" "firefox" "elinks"; do
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
# 0:black 1:red 2:green 3:yellow 4:blue 5:purple 6:cyan 7:white

# Markout (Blinking, bolD, End)
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2)
export LESS_TERMCAP_md=$(tput bold; tput setaf 60)
export LESS_TERMCAP_me=$(tput sgr0)

# StandOut (Used in the modeline)
export LESS_TERMCAP_so=$(tput bold; tput setaf 6; tput setab 4)
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)

# Underline
export LESS_TERMCAP_us=$(tput smul; tput setaf 7)
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)

export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)

# Colorize gcc output
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# If bash, load the subshell configuration for it to be used in login shells too
if test $BASH && test -f $HOME/.bashrc
then
    . $HOME/.bashrc
fi

