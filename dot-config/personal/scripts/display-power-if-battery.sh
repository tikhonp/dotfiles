#!/bin/sh

ACTION="$1"

AC_PATH=/sys/class/power_supply/AC/online

ON_AC=$(cat "$AC_PATH")

# Only act if on battery
if [ "$ON_AC" = "0" ]; then
    case "$ACTION" in
        off)
            swaymsg "output * power off"
            ;;
        on)
            swaymsg "output * power on"
            ;;
        *)
            exit 1
            ;;
    esac
fi
