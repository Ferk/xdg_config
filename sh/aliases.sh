#  -*- Shell-Script -*-
#
# Shell aliases
#
# Should be kept as compatible as possible, so that it can be used not just for bash
# but for other interactive shells too (zsh, fish, dash, etc).
#
# Fernando Carmona Varo


# alias cd='pushd'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias cd..='..'
alias cd...='...'
alias cd....='....'

# md() { mkdir -p "$1" && eval cd "\"\$$#\""; }


alias ff='find . -name $*'

alias du='du -h'
alias dusage='du -s -B M * | sort -nr | $PAGER'

alias notify-send-finish='notify-send "Operation finished" || notify-send "Error on Operation"'

# alias aptitude=' aptitude -r '
# alias agu='sudo aptitude update'
# agg() { sudo aptitude safe-upgrade -y && notify-send-finish; }
# agi() { sudo aptitude install $* && notify-send-finish; }
# agr() { sudo aptitude remove $* && notify-send-finish; }
# alias acs='apt-cache search'
# alias afs='apt-file -x search'
# alias aps='aptitude search'
# alias ach='aptitude show'
# alias a='sudo aptitude'


#alias pac="sudo pacman"

alias o="xdg-open"

alias mp="mplayer"

alias cp="cp -v"
alias mv="mv -v"
alias ln="ln -v"

alias grep='grep --color=always '
alias g='grep'
alias gi='g -i '

alias grexp='grep --exclude=*[~#] --exclude-dir=.svn -nIHr . -e '

alias ls='ls --color=always --group-directories-first --classify'
alias ll='ls -hl'
alias la='ls -A'

alias unp='unp -U'

alias e="${EDITOR:=$({ which emacs || which nano || which vi; } 2>/dev/null)}"

alias h=' history | tail '
alias history.top="cat $HISTFILE | sort | uniq -c | sort -rn | head"
#alias hg=' history | gi '
alias j=' jobs -l '

alias cmi="./configure && make && sudo make install"

# Networking
alias networking='sudo /etc/init.d/networking'
alias sshuco='sshfs q22cavaf@gongora.uco.es: /media/uco'
alias ucodev='ucocp () { cp $@ /media/uco/www-docs/dev/ ; ls /media/uco/www-docs/dev/ ; } ; ucocp '

#
alias df='df -h'
alias bc='bc -lw'
alias ln='ln -i'

alias dmenu='dmenu -nb "#333" -nf "#ccc" -sb "#111" -sf "#ff0"'

# CDargs Aliases
alias cv='cdb'

# Get ls to show only today's changed files:
alias lsnew="ls -alh --time-style=+%D | /bin/grep `date +%D`"

# tail the latest modofied file on the current directory
alias taill='tail -f `ls -t1 | head -n1`' 

# youtube-dl
alias youtube-dl='youtube-dl -t'
alias youtube-dl-low='youtube-dl -f 17'
alias youtube-dl-mp3='youtube-dl --extract-audio --audio-format mp3'

alias update-usplash='sudo update-alternatives --config usplash-artwork.so'

alias nm-start='sudo  /etc/rc.d/networkmanager start; sudo nm-applet'

# source /usr/share/doc/cdargs/examples/cdargs-bash.sh > /dev/null

alias unp=aunpack

# async () { nohup $@  > /tmp/nohup-$(date +%H%M%S).out  }

#bash ~/bin/pacman_aliases.sh

alias wifi="sudo wifi-select wlan0"
#alias off="gksudo poweroff"
alias rmorphans='sudo pacman -Rs $(pacman -Qtdq)'

alias engage="play -n -c1 synth whitenoise band -n 100 20 band -n 50 20 gain +25  fade h 1 864000 1"



