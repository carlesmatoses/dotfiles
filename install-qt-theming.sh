#!/usr/bin/env bash
set -e

echo "=== Installing Qt Theming Components ==="

# 1. Install Kvantum (Qt theming engine)
echo "-> Installing Kvantum..."
sudo pacman -S --needed --noconfirm kvantum

# 2. Install qt5ct and qt6ct (Qt configuration tools)
echo "-> Installing qt5ct and qt6ct..."
sudo pacman -S --needed --noconfirm qt5ct qt6ct

# 3. Install Qt Wayland support
echo "-> Installing Qt Wayland support..."
sudo pacman -S --needed --noconfirm qt5-wayland qt6-wayland

echo "✅ Qt theming components installed successfully!"
