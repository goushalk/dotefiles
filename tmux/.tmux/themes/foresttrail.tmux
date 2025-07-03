##### 🌲 Foresttrail+ Theme — Bright Text Version #####

# Use Ctrl+a as prefix
unbind C-b
set-option -g prefix C-a
bind C-a send-prefix

# Ensure true color support
set-option -ga terminal-overrides ",xterm-256color:Tc"

# General Settings
set-option -g status on
set-option -g status-interval 5
set-option -g status-justify centre
set-option -g status-position bottom
set-option -g status-keys vi
set-option -g history-limit 10000
set -g mouse on

# 🟢 Light Mint Font Color
set -g @main-fg '#60cc9f'     # or try #b4ff9f for brighter
set -g @main-bg '#0F2521'

# Status Bar
set-option -g status-bg '#0F2521'
set-option -g status-fg '#60cc9f'
set-option -g status-left-style bold
set-option -g status-right-style none

# Session name (🌿 on the left)
set -g status-left "#[fg=#60cc9f,bold] 🌿 #S #[default] "

# Right status (📁 path ⚡ window)
set -g status-right "#[fg=#60cc9f]📁 #{pane_current_path} #[fg=#60cc9f]| ⚡ #W #[default]"

# Window list
setw -g window-status-format " #[fg=#60cc9f]#I #[fg=#60cc9f]#W "
setw -g window-status-current-format " #[bg=#60cc9f,fg=colour235,bold]#I:#W#F #[default]"

# Activity indicators
setw -g monitor-activity on
set -g visual-activity on

# Pane borders
set-option -g pane-border-style fg=#60cc9f
set-option -g pane-active-border-style fg=#b4ff9f

# Message box (like prompts, copy mode notifications)
set-option -g message-style bg=colour235,fg=#b4ff9f

# Copy / scroll mode
set-option -g mode-style bg=#60cc9f,fg=colour235
setw -g mode-keys vi

