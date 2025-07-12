#!/bin/bash

set -e

GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

# === 1. Clone Dotfiles ===
DOTFILES_DIR="$HOME/.dotfiles"
REPO_URL="https://github.com/goushalk/dotfiles.git"

if [ ! -d "$DOTFILES_DIR" ]; then
    echo "${GREEN}=> Cloning dotfiles repo into $DOTFILES_DIR...${RESET}"
    git clone "$REPO_URL" "$DOTFILES_DIR"
else
    echo "${GREEN}=> Dotfiles already cloned. Pulling latest changes...${RESET}"
    cd "$DOTFILES_DIR" && git pull
fi

cd "$DOTFILES_DIR"

# === 2. Install yay if missing ===
if ! command -v yay &>/dev/null && ! command -v paru &>/dev/null; then
    echo "${RED}!! No AUR helper found. Installing yay...${RESET}"
    
    sudo pacman -S --needed --noconfirm git base-devel

    temp_dir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$temp_dir"
    cd "$temp_dir"
    makepkg -si --noconfirm
    cd "$DOTFILES_DIR"
    rm -rf "$temp_dir"

    AUR_HELPER="yay"
else
    if command -v yay &>/dev/null; then
        AUR_HELPER="yay"
    else
        AUR_HELPER="paru"
    fi
fi

# === 3. Install Official Packages ===
echo "${GREEN}=> Installing Pacman packages...${RESET}"

PACMAN_PKGS=(
    hyprland
    wofi
    dunst
    kitty
    ripgrep
    git
    stow
)

sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"

# === 4. Install AUR Packages ===
echo "${GREEN}=> Installing AUR packages with $AUR_HELPER...${RESET}"

AUR_PKGS=(
    oh-my-posh
    nerd-fonts-terminus
)

$AUR_HELPER -S --needed --noconfirm "${AUR_PKGS[@]}"

# === 5. Stow with Conflict Cleanup ===
echo "${GREEN}=> Cleaning conflicts and stowing dotfiles...${RESET}"

for dir in */ ; do
    [[ "$dir" == ".git/" ]] && continue

    echo "${GREEN}--> Processing $dir${RESET}"
    conflicts=$(stow -nv "$dir" 2>&1 | grep -oE 'existing target is not a link: (.+)' | awk -F': ' '{print $2}' || true)

    for path in $conflicts; do
        full_path="$HOME/$path"
        if [ -e "$full_path" ] || [ -L "$full_path" ]; then
            echo "${RED}⚠ Removing conflict: $full_path${RESET}"
            rm -rf "$full_path"
        fi
    done

    stow "$dir"
done

echo "${GREEN}✅ Setup complete! Dotfiles linked, system ready to rizz.${RESET}"

