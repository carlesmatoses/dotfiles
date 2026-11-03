#!/usr/bin/env bash
set -e

echo "=== Installing Hyprland Core Components ==="

# 1. Install Hyprland (Wayland compositor)
echo "-> Installing Hyprland..."
sudo pacman -S --needed --noconfirm hyprland

# 4. Install Hyprlock (screen locker for Hyprland)
echo "-> Installing Hyprlock..."
sudo pacman -S --needed --noconfirm hyprlock

echo "-> Linking Hyprland configuration..."
rm -rf ~/.config/hypr
ln -sf ~/github/dotfiles/.config/hypr ~/.config/hypr

echo "✅ Hyprland core components installed successfully!"
