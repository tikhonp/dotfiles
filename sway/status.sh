#!/usr/bin/env sh

# Date
date_string=$(date +'%d %b %k:%M')

# Battery
battery_string="Battery $(cat /sys/class/power_supply/macsmc-battery/status): $(cat /sys/class/power_supply/macsmc-battery/capacity)%"

# WIFI
wifi_status=$(nmcli radio  wifi)
if [ "$wifi_status" = "enabled" ]; then
    wifi_ssid=$(nmcli -t -f active,ssid dev wifi | egrep '^yes' | cut -d ':' -f 2)
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

# Status bar
echo $volume_string "|" $wifi_string "|" $battery_string "|" $date_string
