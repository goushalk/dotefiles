#!/bin/bash

# Nerd Font Icons
ICON_WIFI="󰖩"
ICON_WIFI_LOCKED="󰌾"
ICON_CONNECTED="󰄬"
ICON_DISCONNECT="󰍃"
ICON_ETH="󰈁"
ICON_HOTSPOT="󰖩"
ICON_ERROR="󰅙"
ICON_SETTINGS="󰒓"
ICON_TOGGLE="󰤨"
ICON_INFO="󰋽"

# Network info
CURRENT_WIFI=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
CURRENT_ETH=$(nmcli -t -f DEVICE,STATE dev | grep ethernet | grep connected)
ACTIVE_HS=$(nmcli -t -f TYPE,DEVICE con show --active | grep wifi-hotspot)
WIFI_DEVICE=$(nmcli -t -f DEVICE,TYPE dev | grep wifi | cut -d: -f1)
WIFI_ENABLED=$(nmcli radio wifi)

# Build the menu

MENU=""
MENU+="$ICON_TOGGLE Toggle Hotspot [$([[ -n $ACTIVE_HS ]] && echo on || echo off)]\n"
MENU+="$ICON_TOGGLE Toggle Wi-Fi [$WIFI_ENABLED]\n"
[[ -n "$CURRENT_WIFI" ]] && MENU+="$ICON_DISCONNECT Disconnect from $CURRENT_WIFI\n"
MENU+="$ICON_INFO Network Info\n"

# Wi-Fi Networks
while read -r line; do
    SSID=$(echo "$line" | cut -d: -f1)
    SECURITY=$(echo "$line" | cut -d: -f2)

    [[ -z "$SSID" ]] && continue

    if [[ "$SSID" == "$CURRENT_WIFI" ]]; then
        MENU+="$ICON_CONNECTED $ICON_WIFI $SSID\n"
    elif [[ "$SECURITY" != "--" ]]; then
        MENU+="   $ICON_WIFI_LOCKED $SSID\n"
    else
        MENU+="   $ICON_WIFI $SSID\n"
    fi
done < <(nmcli -t -f SSID,SECURITY dev wifi | sort -u)

# Ethernet
if [[ -n "$CURRENT_ETH" ]]; then
    MENU+="\n$ICON_CONNECTED $ICON_ETH Wired Connected"
elif nmcli device status | grep -q ethernet; then
    MENU+="\n   $ICON_ETH Wired (disconnected)"
fi

# Show Wofi
CHOICE=$(echo -e "$MENU" | wofi --dmenu -i -p "󰖩 Network Manager")

# Cleanup selection
RAW=$(echo "$CHOICE" | sed 's/.*󰖩 //' | sed 's/.*󰌾 //' | sed 's/.*󰄬 //' | sed 's/.*󰈁 //' | sed 's/ (disconnected)//' | sed 's/Disconnect from //' | sed 's/Toggle Wi-Fi.*//')

# Exit if nothing selected
[[ -z "$CHOICE" ]] && exit

### Handle Special Options ###

# 🔥 Start wifi-hotspot

# Toggle Hotspot
if [[ "$CHOICE" == *"Toggle Hotspot"* ]]; then
  if [[ -n $ACTIVE_HS ]]; then
    nmcli connection down "$(echo $ACTIVE_HS | cut -d: -f2)" \
      && notify-send "$ICON_HOTSPOT Hotspot stopped" \
      || notify-send "$ICON_ERROR Failed to stop hotspot"
  else
    HOTSPOT_SSID="arch_user"
    HOTSPOT_PASS="goushal888"
    nmcli dev wifi hotspot ssid "$HOTSPOT_SSID" password "$HOTSPOT_PASS" \
      && notify-send "$ICON_HOTSPOT Hotspot started" \
      || notify-send "$ICON_ERROR Failed to start hotspot"
  fi
  exit 0
fi


# 🔁 Toggle Wi-Fi
if [[ "$CHOICE" == *"Toggle Wi-Fi"* ]]; then
    if [[ "$WIFI_ENABLED" == "enabled" ]]; then
        nmcli radio wifi off && notify-send "󰤫 Wi-Fi disabled"
    else
        nmcli radio wifi on && notify-send "󰤨 Wi-Fi enabled"
    fi
    exit 0
fi

# ❌ Disconnect
if [[ "$CHOICE" == *"Disconnect from"* ]]; then
    nmcli con down id "$RAW" && notify-send "$ICON_DISCONNECT Disconnected from $RAW"
    exit 0
fi

# 📊 Show Network Info
if [[ "$CHOICE" == *"Network Info"* ]]; then
    INFO=$(ip addr | grep -A2 "$WIFI_DEVICE" | grep inet | awk '{print $2}')
    notify-send "$ICON_INFO IP Address: $INFO"
    exit 0
fi

# 🔌 Ethernet Clicked
if [[ "$CHOICE" == *"Wired Connected"* ]]; then
    notify-send "$ICON_ETH Ethernet already connected."
    exit 0
fi

# 🔄 Already connected
if [[ "$RAW" == "$CURRENT_WIFI" ]]; then
    notify-send "$ICON_CONNECTED Already connected to '$RAW'"
    exit 0
fi

# 🔐 Connect to known or new
if nmcli -t -f NAME connection show | grep -q "^$RAW$"; then
    nmcli connection up "$RAW" && \
        notify-send "$ICON_CONNECTED Connected to '$RAW'" || \
        notify-send "$ICON_ERROR Failed to connect to '$RAW'"
else
    PASS=$(wofi --dmenu -P -i -p "󰌾 Password for '$RAW'")
    [[ -z "$PASS" ]] && exit
    nmcli device wifi connect "$RAW" password "$PASS" && \
        notify-send "$ICON_CONNECTED Connected to '$RAW'" || \
        notify-send "$ICON_ERROR Failed to connect to '$RAW'"
fi

