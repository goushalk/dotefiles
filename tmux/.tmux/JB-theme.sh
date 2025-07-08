#!/bin/bash

# Load pywal colors
WAL="$HOME/.cache/wal/colors.sh"
[ -f "$WAL" ] && . "$WAL" || exit 1
. "$WAL"

# Define color shortcuts
bg="$color0"
fg="$color7"
accent="$color2"
alt="$color6"
hi="$color3"
dim="$color8"
red="$color1"

# Helper fns
set() { tmux set-option -gq "$1" "$2"; }
setw() { tmux set-window-option -gq "$1" "$2"; }

# Global status bar
set status on
set status-interval 5
set status-justify centre
set status-left-length 30
set status-right-length 50
set status-bg "$bg"
set status-fg "$fg"
set status-attr dim

# Message styling
set message-style "fg=$fg,bg=$bg"
set message-command-style "fg=$fg,bg=$bg"

# Pane borders
set pane-border-style "fg=$dim"
set pane-active-border-style "fg=$accent"

# Window styles
setw window-status-format "#[fg=$fg,bg=$bg] #I:#W "
setw window-status-current-format "#[fg=$accent,bg=$bg]#[fg=$fg,bg=$accent,bold] #I:#W #[fg=$accent,bg=$bg]"
set window-style "fg=$dim,bg=$bg"
set window-active-style "fg=$fg,bg=$bg"

# Left (logo + session)
set status-left "#[fg=$alt,bg=$bg]#[fg=$fg,bg=$alt,bold]   #S #[fg=$alt,bg=$bg]"

# Right (clock + hostname)
set status-right "#[fg=$red,bg=$bg]#[fg=$bg,bg=$red,bold] #h #[fg=$red,bg=$bg]"

