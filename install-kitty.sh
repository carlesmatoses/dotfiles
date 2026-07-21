#!/usr/bin/env bash
set -e

echo "=== Installing Kitty (Terminal) ==="

echo "-> Installing Kitty..."
sudo pacman -S --needed --noconfirm kitty

echo "-> Linking Kitty configuration..."
mkdir -p ~/.config/kitty
rm -f ~/.config/kitty/kitty.conf
ln -sf ~/github/dotfiles/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf

echo "✅ Kitty installed successfully!"
