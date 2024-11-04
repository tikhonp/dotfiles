#!/bin/bash

layout=$(swaymsg -t get_inputs -r | jq '.[] | select(.identifier == "1452:850:Apple_MTP_keyboard" and .type == "keyboard") | .xkb_active_layout_name' -r --unbuffered)

if [ "$layout" = "English (US)" ]; then
    systemctl --user stop xremap.service
    sway input "1452:850:Apple_MTP_keyboard" xkb_switch_layout next 
else
    systemctl --user start xremap.service
    sway input "1452:850:Apple_MTP_keyboard" xkb_switch_layout next 
fi

