#!/bin/bash

# Set tty fontset
# availible tty fonts stored in /usr/lib/kbd/consolefonts
setfont latarcyrheb-sun32.psfu.gz # permanently
sudo cp -v /etc/vconsole.conf /etc/vconsole.original
sudo vi /etc/vconsole.conf

# connect to wifi
nmcli device wifi connect <ssid> --ask

# install sway-de
sudo dnf install sway-config-fedora xdg-desktop-portal-wlr
# open DE: /usr/bin/start-sway OR start-sway 
# cmd+enter opens foot terminal

# install chromium
sudo dnf install fedora-workstation-repositories
sudo dnf install chromium
# AND:
# chrome://flags/#ozone-platform-hint set to "Wayland"
# chrome://flags/#enable-webrtc-pipewire-camera set to "Enabled"

sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

# most wanted packages
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
    xxd \
    cmus \
    transmission \
    zsh \
    telegram \

# sway desktop packages
sudo dnf install \
    wob \
    brightnessctl \
    wtype \
    mako \
    alsa-utils \
    pavucontrol \
    google-noto-emoji-fonts \
    nemo \

# dark mode for GTK
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark

# new ssh key to add to github
ssh-keygen -t ed25519 -C "tikhon.petrishchev@gmail.com"
wl-copy < ~/.ssh/id_ed25519.pub 

# creating folder for configs
mkdir ~/src
mkdir ~/projects
mkdir ~/projects/sandbox
mkdir -p ~/.config/systemd/user

cd ~/projects
git clone --recurse-submodules git@github.com:tikhonp/dotfiles.git
cd dotfiles
stow --target="$HOME" . --dotfiles

chsh -s $(which zsh)

# restart needed here

rm ~/.bash_history ~/.bash_logout ~/.bash_profile ~/.bashrc

# install gopls and templ 
go install golang.org/x/tools/gopls@latest
go install github.com/a-h/templ/cmd/templ@latest

# install luals
curl -L https://github.com/LuaLS/lua-language-server/releases/latest/download/lua-language-server-3.15.0-linux-arm64.tar.gz | tar x -C ~/.local/bin

# install neovim python headers
pip install -U pip && pip install neovim 

# YEAH:))))))))))))))))))
sudo dnf remove nano

# Install qobuz-player (hifi-rs) https://github.com/iamdb/hifi.rs but SofusA version is so much better: at least hi-res works
curl -L https://github.com/SofusA/qobuz-player/releases/latest/download/qobuz-player-aarch64-unknown-linux-gnu.tar.gz | tar x -C ~/.local/bin

# Install rescrobbled
# https://github.com/InputUsername/rescrobbled
sudo dnf install cargo rust-libdbus-sys-devel.noarch openssl-devel
cargo install rescrobbled
mkdir -p ~/.config/rescrobbled/ && cp dot-config/local/rescrobbled-config.toml ~/.config/rescrobbled/config.toml
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
# fix linux DNS: https://tailscale.com/kb/1188/linux-dns#networkmanager--systemd-resolved

# Install docker
# https://docs.docker.com/engine/install/fedora/
sudo dnf -y install dnf-plugins-core
sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# sudo systemctl enable --now docker
sudo usermod -a -G docker "$USER" # log out -> log in after
# Docker ZSH completions
# https://docs.docker.com/engine/cli/completion/#zsh
mkdir -p ~/.docker/completions
docker completion zsh > ~/.docker/completions/_docker

# Install apple pkl
curl -Lo ~/.local/bin/pkl 'https://github.com/apple/pkl/releases/latest/download/pkl-linux-aarch64'
chmod +x ~/.local/bin/pkl

# install jetbrains toolbox and datagrip
# https://www.jetbrains.com/toolbox-app/
sudo dnf install fuse fuse-libs
vpn connect
# https://www.jetbrains.com/toolbox-app/download/download-thanks.html?platform=linuxARM64
cd ~/Downloads
tar xvf jetbrains-toolbox-...tar.gz
mv jetbrains-toolbox-.../ ~/src
cd ~/src/jetbrains-toolbox-.../
# run it as:
SKIKO_RENDER_API=DIRECT_SOFTWARE ./bin/jetbrains-toolbox
# enable wayland support for idea:
# https://blog.jetbrains.com/platform/2024/07/wayland-support-preview-in-2024-2/

# setup DRM
sudo widevine-installer

# Disable Power BUTTON:
sudo nvim /etc/systemd/logind.conf
# Place in it:
#   [Login]
#   HandlePowerKey=ignore
#
# Then restart logind:
sudo systemctl restart systemd-logind
