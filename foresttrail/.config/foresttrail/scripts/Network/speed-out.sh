#!/bin/bash

OUTFILE="/tmp/waybar_net_speed"
DEFAULT="0.00 MB/s ↓ | 0.00 MB/s ↑"

if [[ ! -s "$OUTFILE" ]]; then
    DATA="$DEFAULT"
else
    DATA=$(cat "$OUTFILE")
fi

# This wraps the icon and traffic data in spans, then wraps everything in JSON
echo "{\"text\": \"<span> 󰓅 </span><span>${DATA}</span>\"}"

