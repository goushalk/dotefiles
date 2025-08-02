#!/bin/bash

# Get list of all files in ~/wallpaper directory
files=(~/wallpapers/)

wallpaper=$(ls "$files")

selected_wall=$(echo "$wallpaper"| wofi -I --dmenu --cache-file /dev/null)
echo "ur wallpaper is : $selected_wall"
echo "the full fullPath is :$files$selected_wall"

 wpg -s "$files$selected_wall" 


#~/.config/waybar/update.sh


