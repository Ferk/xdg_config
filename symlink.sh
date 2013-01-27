#!/bin/bash

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"


echo -e "\e[36m** Creating symlinks to HOME...\e[0m"
for f in $(ls -A "${XDG_CONFIG_HOME}/HOME")
do
    ln -sv $@ "${XDG_CONFIG_HOME}/HOME/$f" "$HOME"
done

echo -e "\e[36m** Creating symlinks to XDG_DATA_HOME...\e[0m"
mkdir -p "$XDG_DATA_HOME"
for f in $(ls -A "${XDG_CONFIG_HOME}/DATA")
do
    ln -sv $@ "${XDG_CONFIG_HOME}/DATA/$f" "$XDG_DATA_HOME"
done

