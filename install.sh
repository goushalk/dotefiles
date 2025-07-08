#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  dotfiles install script
# -----------------------------------------------------------------------------
#  This script installs all required packages (Arch/Manjaro), clones git
#  submodules and symlinks the dotfiles using GNU Stow.
# -----------------------------------------------------------------------------
set -euo pipefail

# Colours for pretty output
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
NC="\033[0m"

say()  { printf "%b\n" "${GREEN}==>${NC} $*"; }
warn() { printf "%b\n" "${YELLOW}==>${NC} $*"; }
fail() { printf "%b\n" "${RED}Error:${NC} $*" >&2; exit 1; }

# -----------------------------------------------------------------------------
#  Helpers
# -----------------------------------------------------------------------------
need() {
  command -v "$1" &>/dev/null || fail "$1 is required but not installed!"
}

# -----------------------------------------------------------------------------
#  1. Install packages
# -----------------------------------------------------------------------------
install_packages() {
  # Core package list (official repos)
  local packages=(
    hyprland hyprlock swayidle swww
    waybar wofi dunst
    kitty fastfetch tmux neovim
    zsh oh-my-posh eza ripgrep fzf
    python-pywal git stow
    nerd-fonts-terminus
  )

  if command -v pacman &>/dev/null; then
    say "Installing packages with pacman …"
    sudo pacman -Sy --needed --noconfirm "${packages[@]}"
  else
    warn "pacman not found – please install the above packages manually."
  fi
}

# -----------------------------------------------------------------------------
#  2. Install Oh-My-Zsh (if missing)
# -----------------------------------------------------------------------------
install_oh_my_zsh() {
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    say "Installing Oh-My-Zsh …"
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else
    say "Oh-My-Zsh already present. Skipping."
  fi
}

# -----------------------------------------------------------------------------
#  3. Fetch git submodules (tmux plugins etc.)
# -----------------------------------------------------------------------------
init_submodules() {
  say "Updating git submodules …"
  git submodule update --init --recursive --depth 1
}

# -----------------------------------------------------------------------------
#  4. Symlink dotfiles via GNU Stow
# -----------------------------------------------------------------------------
stow_dotfiles() {
  need stow
  say "Stowing dotfiles …"
  local dirs=(
    zsh poshthemes hypr waybar kitty nvim tmux fastfetch wal wofi cava gtk-2.0 gtk-3.0 gtk-4.0
  )
  stow -v "${dirs[@]}"
}

# -----------------------------------------------------------------------------
#  Workflow
# -----------------------------------------------------------------------------
main() {
  need git
  need curl
  install_packages
  install_oh_my_zsh
  init_submodules
  stow_dotfiles
  say "All done! Log out and back in to apply your new environment."
}

main "$@" 