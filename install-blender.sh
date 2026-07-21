#!/usr/bin/env bash
set -e

echo "=== Installing Blender ==="

echo "-> Installing Blender..."
if command -v paru &> /dev/null; then
    paru -S --needed --noconfirm blender
else
    sudo pacman -S --needed --noconfirm blender
fi

echo "-> Linking Blender configuration..."
rm -rf ~/.config/blender
ln -sf ~/github/dotfiles/.config/blender ~/.config/blender

echo "✅ Blender installed successfully!"
