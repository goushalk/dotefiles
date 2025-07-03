#!/bin/bash

chosen=$(printf "󰐥 Shutdown\n󰜉 Reboot\n󰍃 Logout\n󰗽 Lock\n󰗼 Suspend" | wofi --dmenu --cache-file /dev/null --style ~/.config/wofi/style.css)

case "$chosen" in
  *Shutdown) systemctl poweroff ;;
  *Reboot) systemctl reboot ;;
  *Logout) hyprctl dispatch exit ;;
  *Lock) hyprlock ;;
  *Suspend) systemctl suspend ;;
esac

