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

# pacman: Pac-Man progress bar (ILoveCandy easter egg). Idempotent.
if ! grep -q '^ILoveCandy' /etc/pacman.conf; then
    sudo sed -i '/^\[options\]/a ILoveCandy' /etc/pacman.conf
fi


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

# Go modules may be not available
export GOPROXY=https://goproxy.cn,direct
export GOSUMDB=off
paru -S --needed --noconfirm google-chrome sing-box


# Directories
mkdir -p ~/src ~/projects/sandbox


# Dotfiles

# Pin GitHub's host key up front so the clone never blocks on an interactive
# yes/no prompt during an unattended run.
mkdir -p ~/.ssh && chmod 700 ~/.ssh
if ! ssh-keygen -F github.com >/dev/null 2>&1; then
    ssh-keyscan -t ed25519 github.com 2>/dev/null >> ~/.ssh/known_hosts
fi

# Start an agent and guarantee the temp key + agent get torn down on ANY exit.
eval "$(ssh-agent -s)"
TEMP_KEY="$(mktemp)"                       # 0600 from birth
cleanup() {
    ssh-add -d "$TEMP_KEY" 2>/dev/null || true
    rm -f "$TEMP_KEY"
    ssh-agent -k >/dev/null 2>&1 || true
}
trap cleanup EXIT

echo "Paste your SSH private key (finish with Ctrl-D on an empty line):"
cat > "$TEMP_KEY"
chmod 600 "$TEMP_KEY"                       # belt-and-suspenders

ssh-add "$TEMP_KEY" \
    || { echo "ERROR: ssh-add rejected the key." >&2; exit 1; }

git -C ~/projects clone --recurse-submodules git@github.com:tikhonp/dotfiles.git \
    || { echo "ERROR: dotfiles clone failed — does the key have repo access?" >&2; exit 1; }

# Done with SSH; tear it down now rather than waiting for script exit.
cleanup
trap - EXIT

# Deploy (guard so we never stow from a missing dir).
[ -d ~/projects/dotfiles ] \
    || { echo "ERROR: ~/projects/dotfiles missing after clone." >&2; exit 1; }
(cd ~/projects/dotfiles && stow --target="$HOME" --dotfiles .)

# Register the custom Sway session (-f so a re-run doesn't choke on an existing link).
sudo ln -sf /home/tikhon/projects/dotfiles/usr/share/wayland-sessions/dotfiles-sway.desktop \
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

# Default login shell -> zsh.
ZSH_PATH="$(command -v zsh)"
if [ -n "$ZSH_PATH" ] && [ "$(getent passwd tikhon | cut -d: -f7)" != "$ZSH_PATH" ]; then
    sudo chsh -s "$ZSH_PATH" tikhon
fi
