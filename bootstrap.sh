#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  goushalk dotfiles bootstrap installer (inspired by ML4W script)
# -----------------------------------------------------------------------------
#  • Fetches either the latest tagged release or the rolling main branch
#  • Ensures required packages + yay (Arch) are installed
#  • Clones dotfiles into ~/.goushalk and launches repo's install.sh
# -----------------------------------------------------------------------------
set -euo pipefail

# -----------------------------------------------------
# CONFIGURATION
# -----------------------------------------------------
REPO="goushalk/dotfiles"            # GitHub repo
DOWNLOAD_DIR="$HOME/.goushalk"     # Temporary workspace
DOTFILES_DIR="$DOWNLOAD_DIR/dotfiles"

# Required packages for this bootstrap script
REQUIRED_PKGS=(wget unzip gum rsync git stow curl)

# -----------------------------------------------------
# COLOR UTILS
# -----------------------------------------------------
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

say()  { printf "%b\n" "${GREEN}==>${NC} $*"; }
warn() { printf "%b\n" "${YELLOW}==>${NC} $*"; }

# -----------------------------------------------------
# HELPER FUNCTIONS
# -----------------------------------------------------
_latest_release() {
  curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
}

_pkg_installed() {
  local pkg="$1"
  pacman -Qq "$pkg" &>/dev/null && return 0 || return 1
}

_install_pkgs() {
  local install_list=()
  for p in "$@"; do
    _pkg_installed "$p" && { say "$p already installed"; continue; }
    install_list+=("$p")
  done
  [[ ${#install_list[@]} -eq 0 ]] && return
  say "Installing missing packages: ${install_list[*]}"
  sudo pacman -Sy --needed --noconfirm "${install_list[@]}"
}

_install_yay() {
  if command -v yay &>/dev/null; then
    say "yay already installed"
    return
  fi
  _install_pkgs base-devel
  git clone https://aur.archlinux.org/yay.git "$DOWNLOAD_DIR/yay"
  pushd "$DOWNLOAD_DIR/yay" >/dev/null
  makepkg -si --noconfirm
  popd >/dev/null
}

_clean_workspace() {
  rm -rf "$DOWNLOAD_DIR"/*
}

# -----------------------------------------------------
# HEADER BANNER
# -----------------------------------------------------
clear
cat <<'EOF'
  ____             _           _      _     _
 / ___|___  _ __  | |__   ___ | |_ __| | __| |
| |   / _ \| '_ \ | '_ \ / _ \| __/ _` |/ _` |
| |__| (_) | | | || |_) | (_) | || (_| | (_| |
 \____\___/|_| |_||_.__/ \___/ \__\__,_|\__,_|
EOF
printf "goushalk Dotfiles bootstrap installer\n\n"

# -----------------------------------------------------
# INTERACTIVE PROMPT
# -----------------------------------------------------
while true; do
  read -rp "Do you want to start the installation now? (y/n): " yn
  case $yn in
    [Yy]*) break ;;
    [Nn]*) echo "Cancelled."; exit 0 ;;
    *) echo "Please answer y or n." ;;
  esac
done

# -----------------------------------------------------
# PREP
# -----------------------------------------------------
mkdir -p "$DOWNLOAD_DIR"
_clean_workspace

say "Synchronising pacman…"
sudo pacman -Sy

say "Ensuring required packages…"
_install_pkgs "${REQUIRED_PKGS[@]}"

say "Ensuring yay AUR helper…"
_install_yay

# -----------------------------------------------------
# CHOOSE RELEASE TYPE
# -----------------------------------------------------
LATEST_TAG=$(_latest_release)
CHOICE=$(gum choose "latest-release ($LATEST_TAG)" "rolling-release" "cancel")
case $CHOICE in
  "latest-release ($LATEST_TAG)")
    say "Cloning latest release $LATEST_TAG…"
    git clone --branch "$LATEST_TAG" --depth 1 "https://github.com/$REPO.git" "$DOTFILES_DIR" ;;
  "rolling-release")
    say "Cloning main branch…"
    git clone --depth 1 "https://github.com/$REPO.git" "$DOTFILES_DIR" ;;
  *)
    echo "Cancelled."; exit 0 ;;
esac

say "Repository downloaded to $DOTFILES_DIR"

# -----------------------------------------------------
# RUN THE PROJECT'S install.sh
# -----------------------------------------------------
cd "$DOTFILES_DIR"
say "Launching dotfiles install.sh…"
chmod +x install.sh
./install.sh

say "All done! Enjoy your new setup." 