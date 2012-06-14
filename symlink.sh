#!/bin/bash

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.cache}


echo -e "\e[36m** Creating symlinks to HOME...\e[0m"
for f in $(ls -A "${XDG_CONFIG_HOME}/HOME")
do 
    ln -sv $@ "$f" "$HOME"
done

echo -e "\e[36m** Creating symlinks to XDG_DATA_HOME...\e[0m"
for f in $(ls -A "${XDG_CONFIG_HOME}/DATA")
do 
    ln -sv $@ "$f" "${XDG_DATA_HOME:-$HOME/.local/share}"
done

