#!/bin/bash

# Get list of all files in ~/wallpaper directory
files=(~/wallpapers/)

wallpaper=$(ls "$files")

selected_wall=$(echo "$wallpaper"| wofi -I --dmenu --cache-file /dev/null)
echo "ur wallpaper is : $selected_wall"
echo "the full fullPath is :$files$selected_wall"

swww img "$files$selected_wall" --transition-type grow --transition-duration 1 && wpg -s "$files$selected_wall" && wal -i "$files$selected_wall"
~/.config/waybar/update.sh
# fullPath=$("$files$selected_walls")

# ~/.config/foresttrail/scripts/swww/wallManexec.sh "$fullPath

