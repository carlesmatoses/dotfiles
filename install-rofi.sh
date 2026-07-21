#!/usr/bin/env bash
set -e

echo "=== Installing Rofi (Application Launcher) ==="

echo "-> Installing Rofi..."
sudo pacman -S --needed --noconfirm rofi

echo "-> Linking Rofi configuration..."
rm -rf ~/.config/rofi
ln -sf ~/github/dotfiles/.config/rofi ~/.config/rofi

echo "✅ Rofi installed successfully!"
