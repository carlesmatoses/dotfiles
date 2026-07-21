#!/usr/bin/env bash
set -e

echo "=== Installing Starship Prompt ==="

# 1. Install Starship
echo "-> Installing Starship..."
if command -v paru &> /dev/null; then
    paru -S --needed --noconfirm starship
else
    sudo pacman -S --needed --noconfirm starship
fi

echo "-> Linking Starship configuration..."
rm -f ~/.config/starship.toml
ln -sf ~/github/dotfiles/.config/starship.toml ~/.config/starship.toml

echo "✅ Starship prompt installed successfully!"
