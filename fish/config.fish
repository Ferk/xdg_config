#!/usr/bin/fish
# -*- sh -*-
# Friendly Interactive Shell - Configuration file
#
# Fernando Carmona Varo


set PATH $PATH ~/bin


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

function fish_prompt -d "Write out the prompt"
	echo -en "\e[0;33m"(date +%T) (set_color $fish_color_cwd)(whoami)"\e[0m:\e[94m"(prompt_pwd)"\e[0m> "
end 

function fish_greeting -d "Greets the user after initialization"
	 echo -e "\e[0;36m"(uptime)"\e[33m"
	 fortune -cs
	 echo -e "\e[0m"
end
