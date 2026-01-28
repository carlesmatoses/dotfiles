#!/usr/bin/env bash
set -e

echo "=== Installing Networking ==="

# 1. Install NetworkManager (network controller)
echo "-> Installing NetworkManager..."
sudo pacman -S --needed --noconfirm networkmanager networkmanager-applet
sudo systemctl enable NetworkManager

# 2. Install clipboard utilities
echo "-> Installing clipboard utilities..."
sudo pacman -S --needed --noconfirm wl-clipboard

echo "✅ Networking components installed successfully!"
