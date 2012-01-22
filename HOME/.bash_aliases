#  -*- Shell-Script -*-
#
# Bash aliases
#
# Fernando Carmona Varo


# alias cd='pushd'
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cd.....='cd ../../../..'

function md () { 
    mkdir -p "$@" && eval cd "\"\$$#\""; 
}


alias ff='find . -name $*'

alias du='du -h'
alias dusage='du -s -B M * | sort -nr | $PAGER'

alias notify-send-finish='notify-send "Operation finished" || notify-send "Error on Operation"'

alias aptitude=' aptitude -r '
alias agu='sudo aptitude update'
agg() { sudo aptitude safe-upgrade -y && notify-send-finish; }
agi() { sudo aptitude install $* && notify-send-finish; }
agr() { sudo aptitude remove $* && notify-send-finish; }
alias acs='apt-cache search'
alias aps='aptitude search'
alias ach='aptitude show'
alias afs='apt-file -x search'

#alias pac="sudo pacman"

alias a='sudo aptitude'
# permitir autocompletado aptitude
complete -F _aptitude $default a

# Add autocompletion to pac
complete -F _pacman pac

alias o="xdg-open"

alias mp="mplayer"

alias cp="cp -v"
alias mv="mv -v"
alias ln="ln -v"

alias grep='grep --color=always '
alias g='grep'
alias gi='g -i '

alias grexp='grep --exclude=*[~#] --exclude-dir=.svn -nIHr . -e '

alias ls='ls --color=always -F '
alias ll='ls -hl'
alias la='ls -A'

alias unp='unp -U'

alias e='$EDITOR'

alias h=' history | tail '
alias history.top="history | cut -c 8- | sort | uniq -c | sort -rn | head"
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

alias update-usplash='sudo update-alternatives --config usplash-artwork.so'

alias nm-start='sudo  /etc/rc.d/networkmanager start; sudo nm-applet'

# source /usr/share/doc/cdargs/examples/cdargs-bash.sh > /dev/null


# async () { nohup $@  > /tmp/nohup-$(date +%H%M%S).out  }

#bash ~/bin/pacman_aliases.sh

alias wifi="sudo wifi-select wlan0"
#alias off="gksudo poweroff"
alias rmorphans='sudo pacman -Rs $(pacman -Qtdq)'

alias engage="play -n -c1 synth whitenoise band -n 100 20 band -n 50 20 gain +25  fade h 1 864000 1"

function netp() {
	sudo /etc/rc.d/net-profiles start
	while [ $? != 0 ]
	do
		sudo /etc/rc.d/net-profiles start
	done
}

#######
#
function pack() {
     if [ $# -lt 2 ] ; then
        echo -e "\npack() usage:"
        echo -e "\tpack archive_file_name file1 file2 ... fileN"
        echo -e "\tcreates archive of files 1-N\n"
     else 
       DEST=$1
       shift

       case $DEST in 
        *.tar.bz2)      tar -cvjf $DEST "$@" ;;  
        *.tar.gz)       tar -cvzf $DEST "$@" ;;  
        *.zip)          zip -r $DEST "$@" ;;
        *.xpi)          zip -r $DEST "$@" ;;
        *)              echo "Unknown file type - $DEST" ;;
       esac
     fi
}

#complete -G "Flash*" mplayer
