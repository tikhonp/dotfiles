#!/bin/bash

# Im starting setup arch script for know just to save some notes

# Install paru AUR helper:
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ..
rm -rf paru

# Install google-chrome:
paru -S --needed google-chrome

pacman -S --needed \
    git \
    sl \
    cmatrix \
    cowsay \
    stow \
    fd fzf ripgrep \
    bash-language-server \
    neovim \
    tmux \
    go \
    python-pip \
    kitty \
    luarocks \
    fastfetch \
    imagemagick \
    clang-tools-extra \
    xxd \
    zsh \
    transmission-gtk \
    telegram-desktop \
    pavucontrol \
    bitwarden \
    firefox \
    wob \
    wtype \
    mako \
    i3status \
    wmenu \
    
    # brightnessctl \
    # foot \
    # grim \
    # polkit \

mkdir ~/src
mkdir ~/projects
mkdir ~/projects/sandbox

cd ~/projects
git clone --recurse-submodules git@github.com:tikhonp/dotfiles.git
cd dotfiles
stow --target="$HOME" . --dotfiles

# to start sway link custom desktop file:
ln -s /home/tikhon/projects/dotfiles/usr/share/wayland-sessions/dotfiles-sway.desktop \
    /usr/share/wayland-sessions/dotfiles-sway.desktop

# tailscale 
curl -fsSL https://tailscale.com/install.sh | sh
