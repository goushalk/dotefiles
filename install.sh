#!/bin/bash

set -e

GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

echo "${GREEN}=> Installing packages with pacman...${RESET}"

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

echo "${GREEN}=> Checking for AUR helper (yay or paru)...${RESET}"

if command -v yay &> /dev/null; then
    AUR_HELPER="yay"
elif command -v paru &> /dev/null; then
    AUR_HELPER="paru"
else
    echo "${RED}!! No AUR helper found (yay or paru). Install one first.${RESET}"
    exit 1
fi

echo "${GREEN}=> Installing AUR packages with $AUR_HELPER...${RESET}"

AUR_PKGS=(
    oh-my-posh
    nerd-fonts-terminus
)

$AUR_HELPER -S --needed --noconfirm "${AUR_PKGS[@]}"

echo "${GREEN}=> Force-clean stow setup...${RESET}"

for dir in */ ; do
    [[ "$dir" == ".git/" ]] && continue

    # Check what files would be symlinked
    echo "${GREEN}--> Processing $dir${RESET}"
    conflicts=$(stow -nv "$dir" 2>&1 | grep -oE 'existing target is not a link: (.+)' | awk -F': ' '{print $2}')

    # Delete conflicting files/folders
    for path in $conflicts; do
        echo "${RED}Removing conflicting path: $HOME/$path${RESET}"
        rm -rf "$HOME/$path"
    done

    # Now safe to stow
    stow "$dir"
done

echo "${GREEN}✅ Dotfiles successfully stowed!${RESET}"

