#!/bin/bash

su - tikhon

# tty font
sudo sed -i 's/^FONT=.*/FONT=latarcyrheb-sun32/' /etc/vconsole.conf

sudo pacman -S --needed --noconfirm \
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
    lua-language-server \
    wl-mirror \
    man \
    easyeffects \
    lsp-plugins-lv2 \
    unrar \
    kicad kicad-library kicad-library-3d kicad-demos \
    freecad \

# Install paru AUR helper:
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm
cd ..
rm -rf paru

# Install google-chrome:
paru -S --needed --noconfirm google-chrome sing-box

mkdir ~/src
mkdir ~/projects
mkdir ~/projects/sandbox

# ssh-key for clonning
eval "$(ssh-agent -s)"
# Create temp file for key
TEMP_KEY="/tmp/temp_ssh_key_$RANDOM"
# Prompt for key content (multi-line)
echo "Paste your SSH private key content (end with empty line):"
cat > "$TEMP_KEY"
# Add to ssh-agent
ssh-add "$TEMP_KEY"

cd ~/projects
git clone --recurse-submodules git@github.com:tikhonp/dotfiles.git

ssh-add -d "$TEMP_KEY"
rm -f "$TEMP_KEY"

cd dotfiles
stow --target="$HOME" . --dotfiles

# to start sway link custom desktop file:
sudo ln -s /home/tikhon/projects/dotfiles/usr/share/wayland-sessions/dotfiles-sway.desktop \
    /usr/share/wayland-sessions/dotfiles-sway.desktop

# tailscale 
curl -fsSL https://tailscale.com/install.sh | sh

# docker
sudo usermod -aG docker $USER

# install gopls and templ 
go install golang.org/x/tools/gopls@latest
go install github.com/a-h/templ/cmd/templ@latest

# oppo remote control:
cd "$HOME/.config/personal/oppo_controller"
python -m venv env
. env/bin/activate
pip install -U pip
pip install -r requirements.txt

bash -c "$(curl -fsSL https://raw.githubusercontent.com/JackHack96/EasyEffects-Presets/master/install.sh)"

bash -c "$(curl -fsSL https://raw.githubusercontent.com/tikhonp/dotfiles/refs/heads/main/setup-scripts/setup-hibernate.sh)"

cd ~/src
git clone https://github.com/Leadaxe/singbox-launcher.git
cd singbox-launcher
./build/build_linux.sh
chmod +x singbox-launcher

cd
