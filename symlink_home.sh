#!/bin/bash

DIR=${XDG_CONFIG_HOME:-"$HOME/.cache"}/HOME/

ln -s ${DIR}/.??* $HOME
