#!/usr/bin/env bash
set -e

echo "=== Installing Fonts ==="

# 1. Install JetBrainsMono Nerd Font
echo "-> Installing JetBrainsMono Nerd Font..."
sudo pacman -S --needed --noconfirm ttf-jetbrains-mono-nerd

echo "✅ Fonts installed successfully!"
