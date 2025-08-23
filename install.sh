#!/usr/bin/env bash
set -e

echo "=== Installing modules for Hyprland setup ==="

# Update system
sudo pacman -Syu --noconfirm

# 1. Install Kvantum (Qt theming engine)
echo "-> Installing Kvantum..."
sudo pacman -S --needed --noconfirm kvantum

# 2. Install Waybar (status bar for Wayland compositors)
echo "-> Installing Waybar..."
sudo pacman -S --needed --noconfirm waybar

# 3. Install JetBrainsMono Nerd Font
echo "-> Installing JetBrainsMono Nerd Font..."
sudo pacman -S --needed --noconfirm ttf-jetbrains-mono-nerd

echo "✅ All modules installed successfully!"
