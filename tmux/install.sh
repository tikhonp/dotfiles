#!/usr/bin/env bash

if [ -z "$XDG_CONFIG_HOME" ]
then
    echo "$XDG_CONFIG_HOME is not set";
    exit 1;
fi

if [ -d $XDG_CONFIG_HOME/tmux ] then 
    cp -rf $XDG_CONFIG_HOME/tmux $DOTFILES_OLD_CONFS_PATH/tmux
fi

rm -rf $XDG_CONFIG_HOME/tmux
cp -r $(pwd) $XDG_CONFIG_HOME/tmux
