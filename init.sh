#!/usr/bin/env bash

set -euo pipefail

LOG_FILE="arch-init.log"
PACKAGES=(
  git
  base-devel
  curl
  wget
  vim
  nvim
  mpv
  zathura
  zathura-pdf-poppler 
  htop
)

SETUP_SCRIPT="./.config/anuradhe_arch/setup-patches.sh"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "=== Arch Initialization Started ==="

# Ensure running as root
if [[ "$EUID" -ne 0 ]]; then
  echo "Error: This script must be run as root."
  exit 1
fi

# Sync and update system
echo "Updating system..."
pacman -Syu --noconfirm

# Install required packages
echo "Installing packages..."
pacman -S --needed --noconfirm "${PACKAGES[@]}"

# Validate installations
echo "Validating installed packages..."
for pkg in "${PACKAGES[@]}"; do
  if ! pacman -Qi "$pkg" >/dev/null 2>&1; then
    echo "Package installation failed: $pkg"
    exit 1
  fi
done

echo "All packages installed successfully."

# Run setup script
if [[ -f "$SETUP_SCRIPT" ]]; then
  echo "Executing setup-patches.sh..."
  chmod +x "$SETUP_SCRIPT"
  "$SETUP_SCRIPT"
else
  echo "Error: setup-patches.sh not found."
  exit 1
fi

echo "=== Arch Initialization Completed Successfully ==="
