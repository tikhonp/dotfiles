#!/bin/bash

# Set tty fontset
# availible tty fonts stored in /usr/lib/kbd/consolefonts
setfont latarcyrheb-sun32.psfu.gz # permanently
sudo cp -v /etc/vconsole.conf /etc/vconsole.original
sudo vi /etc/vconsole.conf

# connect to wifi
nmcli device wifi connect <ssid> --ask

# install sway-de
sudo dnf install sway-config-fedora
# IMPORTAMT check in next reinstall check if xdg-desktop-env-wlr installed 
# after this

# install chromium
sudo dnf install fedora-workstation-repositories
sudo dnf install chromium
# WAYLAND SUPORT
# 1. Go to chrome://flags
# 2. Search "Preferred Ozone platform"
# 3. Set it to "Wayland"
# 4. Restart chromium
#
# ALSO
# Type chrome://flags/#chrome-labs in the address bar, disable "Chrome Labs", and enable the "Hide Side Panel Button".
# Type chrome://flags/#enable-webrtc-pipewire-camera enable it

sudo dnf install \
	git \
	sl \
	cmatrix \
	cowsay \
	stow \
	fd-find fzf ripgrep \
	nodejs-bash-language-server \
	neovim \
	tmux \
	tldr \
	go \
	python3-pip \
	speedtest-cli \
	kitty \
    thefuck \
    luarocks \
    asahi-bless \
    fastfetch \
    ImageMagick-devel \
    clang-tools-extra \

# install gopls
go install golang.org/x/tools/gopls@latest

pip install -U pip
pip install neovim # install neovim python headers

sudo dnf remove nano

# sway desktop packages
sudo dnf install \
    wob \
    brightnessctl \
    wtype \
    mako \
    alsa-utils \
    google-noto-emoji-fonts \


# new ssh key
ssh-keygen -t ed25519 -C "your_email@example.com"
wl-copy < ~/.ssh/id_ed25519.pub 

# creating folder for configs
mkdir ~/projects
mkdir ~/projects/sandbox
mkdir -p ~/.config/systemd/user

git clone --recurse-submodules git@github.com:tikhonp/dotfiles.git
cd dotfiles
stow --target=$HOME . --dotfiles

sudo dnf install zsh
chsh -s $(which zsh)

# restart needed here

rm ~/.bash_history ~/.bash_logout ~/.bash_profile ~/.bashrc

# install telegram
sudo dnf upgrade --refresh
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install telegram

# copy secrets and servers.txt files to ~/.config/local

mkdir ~/src

# install launcher
# https://github.com/Biont/sway-launcher-desktop
cd ~/src
git clone git@github.com:Biont/sway-launcher-desktop.git

# hifi-rs
# https://github.com/iamdb/hifi.rs
curl -Lo hifi-rs-aarch64-unknown-linux-gnu.tar.gz https://github.com/iamdb/hifi.rs/releases/latest/download/hifi-rs-aarch64-unknown-linux-gnu.tar.gz
tar xvf hifi-rs-aarch64-unknown-linux-gnu.tar.gz
rm hifi-rs-aarch64-unknown-linux-gnu.tar.gz
mv hifi-rs ~/.local/bin

# install rescrobbled
# https://github.com/InputUsername/rescrobbled
sudo dnf install cargo rust-libdbus-sys-devel.noarch openssl-devel
cargo install rescrobbled
cp dot-config/local/rescrobbled-config.toml ~/.config/rescrobbled/config.toml
# then run `rescrobbled` in terminal and auth with lastfm
systemctl --user daemon-reload
systemctl --user enable rescrobbled.service

# Setup vpn
# https://github.com/Kir-Antipov/outline-cli
cd ~/src
git clone git@github.com:Kir-Antipov/outline-cli.git
cd outline-cli
sudo ./install.sh -y

# Setup tailscale
vpn connect
curl -fsSL https://tailscale.com/install.sh | sh

# Install docker
# https://docs.docker.com/engine/install/fedora/
sudo dnf -y install dnf-plugins-core
sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# sudo systemctl enable --now docker
sudo usermod -a -G docker $USER # log out -> log in after
# ZSH completions
# https://docs.docker.com/engine/cli/completion/#zsh
mkdir -p ~/.docker/completions
docker completion zsh > ~/.docker/completions/_docker

# Install apple pkl
curl -Lo ~/.local/bin/pkl 'https://github.com/apple/pkl/releases/download/0.27.2/pkl-linux-aarch64'
chmod +x ~/.local/bin/pkl

# install jetbrains toolbox and datagrip
# https://www.jetbrains.com/toolbox-app/
sudo dnf install fuse fuse-libs
vpn connect
# https://www.jetbrains.com/toolbox-app/download/download-thanks.html?platform=linuxARM64
cd ~/Downloads
tar xvf jetbrains-toolbox-2.5.2.35332-arm64.tar.gz
mv jetbrains-toolbox-2.5.2.35332/jetbrains-toolbox ~/.local/bin
rm -r jetbrains-toolbox-2.5.2.35332 jetbrains-toolbox-2.5.2.35332-arm64.tar.gz
# run it as:
SKIKO_RENDER_API=DIRECT_SOFTWARE jetbrains-toolbox
# enable wayland support for idea:
# https://blog.jetbrains.com/platform/2024/07/wayland-support-preview-in-2024-2/

# setup DRM
sudo widevine-installer

# Disable Power BUTTON:
#
#   /etc/systemd/logind.conf
#
#   [Login]
#   HandlePowerKey=ignore
#
#
#   Then restart logind:
   sudo systemctl restart systemd-logind

