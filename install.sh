#!/usr/bin/env bash

# params: dir
function install {
    install_file=$1/install.sh
    if [ ! -f $install_file ] then
        return
    fi
    echo "Installing $install_file..."
    install_file
}

export DOTFILES_OLD_CONFS_PATH=$HOME/old_dotfiles

for d in */ ; do 
   install $d 
done
