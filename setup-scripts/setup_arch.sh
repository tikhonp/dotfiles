#!/bin/bash

# Partitioning:
#
# Device            Start        End   Sectors   Size Type
# /dev/nvme0n1p1     2048    2099199   2097152     1G EFI System
# /dev/nvme0n1p2  2099200   69208063  67108864    32G Linux swap
# /dev/nvme0n1p3 69208064 1000214527 931006464 443.9G Linux root (x86-64)

# Im starting setup arch script for know just to save some notes

pacman -S --needed \
    base-devel \
    git \
    less \
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
    opencode \
    wob \
    wtype \
    docker \
    docker-compose \
    docker-buildx \
    brightnessctl \
    foot \
    grim \
    i3status \
    libpulse \
    mako \
    polkit \
    sway-contrib swaybg \
    swayidle \
    swaylock \
    wmenu \
    xdg-desktop-portal-gtk \
    xdg-desktop-portal-wlr \
    xorg-xwayland \
    zsh-completions \
    npm \
    tree-sitter \
    tree-sitter-cli \

# Install paru AUR helper:
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ..
rm -rf paru

# Install google-chrome:
paru -S --needed google-chrome

mkdir ~/src
mkdir ~/projects
mkdir ~/projects/sandbox

# setup bitwarden
#  export SSH_AUTH_SOCK=/home/tikhon/.bitwarden-ssh-agent.sock
#  ssh -L
git clone --recurse-submodules git@github.com:tikhonp/dotfiles.git
cd dotfiles
stow --target="$HOME" . --dotfiles

# to start sway link custom desktop file:
ln -s /home/tikhon/projects/dotfiles/usr/share/wayland-sessions/dotfiles-sway.desktop \
    /usr/share/wayland-sessions/dotfiles-sway.desktop

# tailscale 
curl -fsSL https://tailscale.com/install.sh | sh

# 86 is ID of OPPO DAC in sinks:
#  86. OPPO HA-1 USB AUDIO 2.0 DAC Analog Stereo [vol: 0.40]
#  wpctl status
#
# wpctl set-volume 86 1.0

# VPN 
paru -S sing-box
# and sungbox launcher

sudo usermod -aG docker $USER

# install gopls and templ 
go install golang.org/x/tools/gopls@latest
go install github.com/a-h/templ/cmd/templ@latest
