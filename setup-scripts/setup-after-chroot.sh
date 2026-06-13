#!/bin/bash
#
# Post-chroot provisioning for Arch + Sway.
# Run as user `tikhon` (uses sudo for the root-only steps).
# Invoked from setup_arch.sh after the base system + user exist.

set -uo pipefail

# Drop to the user account if invoked as root.
[ "$(id -un)" != tikhon ] && exec su - tikhon


# Larger TTY font for HiDPI.
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



# Bootstrap paru.
git clone https://aur.archlinux.org/paru.git
(cd paru && makepkg -si --noconfirm)
rm -rf paru

paru -S --needed --noconfirm google-chrome sing-box


# Directories
mkdir -p ~/src ~/projects/sandbox


# Dotfiles

# Load an SSH key into the agent so we can clone over git@.
eval "$(ssh-agent -s)"
TEMP_KEY="/tmp/temp_ssh_key_$RANDOM"
echo "Paste your SSH private key content (end with empty line):"
cat > "$TEMP_KEY"
ssh-add "$TEMP_KEY"

git -C ~/projects clone --recurse-submodules git@github.com:tikhonp/dotfiles.git

ssh-add -d "$TEMP_KEY"
rm -f "$TEMP_KEY"

# Deploy with stow.
(cd ~/projects/dotfiles && stow --target="$HOME" . --dotfiles)

# Register the custom Sway session for the display manager.
sudo ln -s /home/tikhon/projects/dotfiles/usr/share/wayland-sessions/dotfiles-sway.desktop \
    /usr/share/wayland-sessions/dotfiles-sway.desktop


# Tailscale.
curl -fsSL https://tailscale.com/install.sh | sh

# Docker (rootless access for the user).
sudo usermod -aG docker "$USER"


# Go language server + templ.
go install golang.org/x/tools/gopls@latest
go install github.com/a-h/templ/cmd/templ@latest

# OPPO DAC remote control venv.
(
    cd "$HOME/.config/personal/oppo_controller"
    python -m venv env
    . env/bin/activate
    pip install -U pip
    pip install -r requirements.txt
)


# EasyEffects presets.
bash -c "$(curl -fsSL https://raw.githubusercontent.com/JackHack96/EasyEffects-Presets/master/install.sh)"

# Hibernate setup.
bash -c "$(curl -fsSL https://raw.githubusercontent.com/tikhonp/dotfiles/refs/heads/main/setup-scripts/setup-hibernate.sh)"

# sing-box launcher GUI.
git -C ~/src clone https://github.com/Leadaxe/singbox-launcher.git
(
    cd ~/src/singbox-launcher
    ./build/build_linux.sh
    chmod +x singbox-launcher
)
