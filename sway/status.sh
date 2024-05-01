#!/usr/bin/env bash

# Date
date_string=$(date +'%d %b %k:%M')

# Keyboard layout
layout=$(swaymsg -t get_inputs -r | jq '.[] | select(.identifier == "1452:641:Apple_Internal_Keyboard_/_Trackpad" and .type == "keyboard") | .xkb_active_layout_name' -r --unbuffered)

# Battery
battery_string="Battery $(cat /sys/class/power_supply/macsmc-battery/status): $(cat /sys/class/power_supply/macsmc-battery/capacity)%"

# WIFI
wifi_status=$(nmcli radio  wifi)
if [ "$wifi_status" = "enabled" ]; then
    wifi_ssid=$(nmcli -t -f active,ssid dev wifi | grep -E '^yes' | cut -d ':' -f 2)
    if [ -z "$wifi_ssid" ]; then
        wifi_string="Wifi: Not Connected"
    else
        wifi_string="Wifi: $wifi_ssid"
    fi
else
    wifi_string="Wifi: ${wifi_status^}"
fi

# Volume
is_muted=$(amixer get Master | tail -n1 | grep -oE "\[off\]")
if [ -z "$is_muted" ]; then
    volume=$(amixer get Master | tail -n1 | sed -r 's/.*\[(.*)%\].*/\1/')
    volume_string="Volume: $volume%"
else
    volume_string="Volume: Muted"
fi

playing_status=$(playerctl status)
if [ "$playing_status" ] && [ "$playing_status" != "No players found" ]; then

    # get sample rate
    headphones_running=$(grep RUNNING /proc/asound/card0/pcm0p/sub0/status | tr -d ' ')
    speakers_running=$(grep RUNNING /proc/asound/card0/pcm1p/sub0/status | tr -d ' ')
    if [[ $headphones_running != "" ]]; then
        raw_sample_rate=$(grep rate /proc/asound/card0/pcm0p/sub0/hw_params | awk '{print $2}')
        sample_rate="$(bc <<< "scale=1; $raw_sample_rate / 1000" | sed 's/\.0$//')kHz "
    elif [[ $speakers_running != "" ]]; then
        raw_sample_rate=$(grep rate /proc/asound/card0/pcm1p/sub0/hw_params | awk '{print $2}')
        sample_rate="$(bc <<< "scale=1; $raw_sample_rate / 1000" | sed 's/\.0$//')kHz "
    else
        sample_rate=""
    fi

    playing_artist=$(playerctl metadata artist)
    playing_title=$(playerctl metadata title)
    playing_string="$playing_status: $playing_artist - $playing_title $sample_rate|"
else
    playing_string=""
fi

# Status bar
echo "$playing_string" "$volume_string" "|" "$wifi_string" "|" "$battery_string" "|" "$layout" "|" "$date_string"
