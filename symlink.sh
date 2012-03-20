#!/bin/bash

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.cache}


echo -e "\e[36m** Creating symlinks to HOME...\e[0m"
ln -sv $@ ${XDG_CONFIG_HOME}/HOME/.??* $HOME

echo -e "\e[36m** Creating symlinks to XDG_DATA_HOME...\e[0m"
ln -sv $@ ${XDG_CONFIG_HOME}/DATA/* ${XDG_DATA_HOME:-"$HOME/.local/share"}


