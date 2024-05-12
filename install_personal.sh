#!/usr/bin/env bash

if [ -z "$XDG_CONFIG_HOME" ]
then
    echo "$XDG_CONFIG_HOME is not set";
    exit 1;
fi

if [ -d "$XDG_CONFIG_HOME/personal" ]; then
    mv $XDG_CONFIG_HOME/personal $XDG_CONFIG_HOME/personal.bak
fi
rm -rf $XDG_CONFIG_HOME/personal
cp -r $(pwd)/personal $XDG_CONFIG_HOME/personal
