#! /usr/bin/env sh

set -eu

__dotfiles_silent_terminate() { # $1 = pkill expression (i.e. executable name)
  pkill "${1}" || true >/dev/null 2>&1
}

# https://github.com/swaywm/sway/wiki#gtk-applications-take-20-seconds-to-start
if command -v dbus-update-activation-environment >/dev/null; then
  dbus-update-activation-environment DISPLAY SWAYSOCK WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE
fi
if command -v systemctl >/dev/null; then
  systemctl --user import-environment DISPLAY SWAYSOCK WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE
fi

# __dotfiles_silent_terminate blueman-applet
# blueman-applet &

# setup polkit integration
# requires `pacman -S polkit-gnome`
__dotfiles_silent_terminate /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
