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

# Configuration
REPO="${DOTFILES_REPO:-goushalk/dotfiles}"

# -----------------------------------------------------------------------------
#  Helpers
# -----------------------------------------------------------------------------
need() {
  command -v "$1" &>/dev/null || fail "$1 is required but not installed!"
}

# Additional helper functions for bootstrap mode
_latest_release() {
  curl -s "https://api.github.com/repos/$REPO/releases/latest" \
    | grep -m1 '"tag_name":' | sed -E 's/.*"([^\"]+)".*/\1/'
}

install_yay() {
  if command -v yay &>/dev/null; then
    say "yay already installed."
    return
  fi
  say "Installing yay AUR helper …"
  sudo pacman -Sy --needed --noconfirm base-devel git
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  (cd /tmp/yay && makepkg -si --noconfirm)
}

confirm() {
  while true; do
    read -rp "$1 (y/n): " yn
    case $yn in
      [Yy]*) return 0 ;;
      [Nn]*) return 1 ;;
      *) echo "Please answer y or n." ;;
    esac
  done
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

# If the script is executed outside its repository, bootstrap by cloning.
if [[ ! -d .git && ! -f README.md ]]; then
  clear
  cat <<'EOF'
  ____             _           _      _     _
 / ___|___  _ __  | |__   ___ | |_ __| | __| |
| |   / _ \| '_ \ | '_ \ / _ \| __/ _` |/ _` |
| |__| (_) | | | || |_) | (_) | || (_| | (_| |
 \____\___/|_| |_|||_.__/ \___/ \__\__,_|\__,_|
EOF
  printf "goushalk Dotfiles installer\n\n"

  confirm "Do you want to start the installation now?" || { echo "Cancelled."; exit 0; }

  say "Synchronising pacman …"
  sudo pacman -Sy

  say "Ensuring yay AUR helper …"
  install_yay

  LATEST_TAG=$(_latest_release)
  echo
  echo "Select release to install:"
  PS3="> "
  select CHOICE in "latest ($LATEST_TAG)" "rolling (main)" "cancel"; do
    case $CHOICE in
      "latest ($LATEST_TAG)")
        BRANCH="$LATEST_TAG"
        break ;;
      "rolling (main)")
        BRANCH="main"
        break ;;
      "cancel")
        echo "Cancelled."; exit 0 ;;
    esac
  done

  DOWNLOAD_DIR="$HOME/.goushalk"
  DOTFILES_DIR="$DOWNLOAD_DIR/dotfiles"
  mkdir -p "$DOWNLOAD_DIR"

  say "Cloning branch $BRANCH …"
  if [[ "$BRANCH" == "main" ]]; then
    git clone --depth 1 "https://github.com/$REPO.git" "$DOTFILES_DIR"
  else
    git clone --branch "$BRANCH" --depth 1 "https://github.com/$REPO.git" "$DOTFILES_DIR"
  fi

  cd "$DOTFILES_DIR"
  exec ./install.sh "$@"   # re-execute inside repo
fi

main "$@" 
