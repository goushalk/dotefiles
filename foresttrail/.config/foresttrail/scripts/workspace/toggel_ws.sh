#!/bin/bash

TARGET=$1
CACHE="$HOME/.config/foresttrail/scripts/workspace/.last_ws"
CURRENT=$(hyprctl activeworkspace -j | jq '.id')
LAST=$(cat "$CACHE" 2>/dev/null)

# Save current to cache
echo "$CURRENT" > "$CACHE"

# If current is target, go back to previous
if [ "$CURRENT" == "$TARGET" ]; then
    if [ -n "$LAST" ] && [ "$LAST" != "$CURRENT" ]; then
        hyprctl dispatch workspace "$LAST"
    fi
else
    hyprctl dispatch workspace "$TARGET"
fi

