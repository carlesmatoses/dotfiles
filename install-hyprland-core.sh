#!/usr/bin/env bash
set -e

echo "=== Installing Hyprland Core Components ==="

# 1. Install Hyprland (Wayland compositor)
echo "-> Installing Hyprland..."
sudo pacman -S --needed --noconfirm hyprland

# 2. Install Waybar (status bar for Wayland compositors)
echo "-> Installing Waybar..."
sudo pacman -S --needed --noconfirm waybar

# 3. Install Rofi (application launcher/window switcher)
echo "-> Installing Rofi..."
sudo pacman -S --needed --noconfirm rofi

# 4. Install Hyprpaper (wallpaper utility for Hyprland)
echo "-> Installing Hyprpaper..."
sudo pacman -S --needed --noconfirm hyprpaper

# 5. Install Hyprlock (screen locker for Hyprland)
echo "-> Installing Hyprlock..."
sudo pacman -S --needed --noconfirm hyprlock

echo "✅ Hyprland core components installed successfully!"
