#!/bin/bash

status=$(playerctl status 2>/dev/null)
track=$(playerctl metadata --format '{{artist}} - {{title}}' 2>/dev/null)

if [ "$status" = "Playing" ]; then
    echo "{\"text\": \"⏮  ⏸  ⏭\", \"tooltip\": \"$track\"}"
elif [ "$status" = "Paused" ]; then
    echo "{\"text\": \"⏮  ▶  ⏭\", \"tooltip\": \"$track\"}"
else
    echo "{\"text\": \"\", \"tooltip\": \"Nothing playing\"}"
fi

