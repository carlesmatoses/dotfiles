#!/usr/bin/env bash
set -e

echo "=== Installing wlogout (Wayland Logout Dialog) ==="

# 1. Install wlogout
echo "-> Installing wlogout..."
if command -v paru &> /dev/null; then
    paru -S --needed --noconfirm wlogout
else
    sudo pacman -S --needed --noconfirm wlogout
fi

echo "-> Linking wlogout configuration..."
rm -rf ~/.config/wlogout
ln -sf ~/github/dotfiles/.config/wlogout ~/.config/wlogout

echo "✅ wlogout installed successfully!"
