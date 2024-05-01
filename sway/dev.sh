#!/usr/bin/env bash

if [ -z "$XDG_CONFIG_HOME" ]
then
    echo "$XDG_CONFIG_HOME is not set";
    exit 1;
fi

rm -rf "$XDG_CONFIG_HOME"/sway
ln -s "$(pwd)" "$XDG_CONFIG_HOME"/sway
