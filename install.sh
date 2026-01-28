#!/usr/bin/env bash
set -e

echo "=== System Setup and Paru Installation ==="

# Update system
echo "-> Updating system packages..."
sudo pacman -Syu --noconfirm

# Install Paru (AUR helper) if not present
if ! command -v paru &> /dev/null; then
    echo "-> Installing Paru (AUR helper)..."
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    cd /tmp/paru
    makepkg -si --noconfirm
    cd -
    rm -rf /tmp/paru
    echo "✅ Paru installed successfully!"
else
    echo "ℹ️  Paru is already installed."
fi

echo "✅ System setup completed!"
