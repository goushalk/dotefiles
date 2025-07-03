#!/bin/bash

# Path to your Hyprland config
HYPRCONF="${HOME}/.config/hypr/hyprland.conf"

# Grab mainMod (the mod key, usually SUPER)
mainMod=$(grep -E '^ *\$mainMod *= *' "$HYPRCONF" | awk -F '=' '{gsub(/ /, "", $2); print $2}')

# Function to replace $mainMod with 
parse_binds() {
    grep -E '^\s*bind' "$HYPRCONF" | while read -r line; do
        raw="${line#*=}" # Remove up to and including '='
        # Split by ',' into array
        IFS=',' read -r mod key action args <<< "$raw"

        # Replace $mainMod with icon
        mod="${mod//\$mainMod/}"

        # Output in a clean format
        printf "%-15s → %-15s : %s %s\n" "$mod + $key" "$action" "$args"
    done
}

# Run and show in wofi
{
    echo "󰌌 Hyprland Hotkeys"
    echo "---------------------------"
    parse_binds
} | wofi --dmenu --prompt "Your Hotkeys" --width 600 --height 500 --insensitive

