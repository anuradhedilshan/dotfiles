#!/bin/bash
# =========================================
# Arch Linux Backup & Config Setup Script
# =========================================

set -e
echo "=== Starting setup script ==="

# --- 1) Update system ---
echo "Updating system..."
sudo pacman -Syu --noconfirm

# --- 2) Install essential base-devel tools ---
echo "Installing base-devel..."
sudo pacman -S --needed base-devel --noconfirm

# --- 3) Install git if missing ---
if ! command -v git &>/dev/null; then
    echo "Installing git..."
    sudo pacman -S --needed git --noconfirm
fi

# --- 4) Install paru (AUR helper) ---
if ! command -v paru &>/dev/null; then
    echo "Installing paru (AUR helper)..."
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    cd /tmp/paru
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/paru
fi

# --- 5) Install packages from official repos ---
PACKAGES=(cronie zenity vdirsyncer lsof)
echo "Installing official packages: ${PACKAGES[*]}"
sudo pacman -S --needed "${PACKAGES[@]}" --noconfirm

# --- 6) Enable cronie service ---
echo "Enabling cronie service..."
sudo systemctl enable --now cronie.service

# --- 7) Setup for easy patch/package additions ---
PATCH_DIR="$HOME/setup-patches"
mkdir -p "$PATCH_DIR"
echo "You can drop scripts or patch files in $PATCH_DIR and run them manually."

# --- 8) Optional: notify user ---
echo "Setup complete. You can now add your custom patches in $PATCH_DIR."
echo "Cronic service is running, Zenity is installed, vdirsyncer and lsof ready."
echo "Use crontab -e to add backup jobs."

# --- End of script ---

