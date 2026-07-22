#!/usr/bin/env bash
set -e

echo "=== Installing Lazygit ==="

echo "-> Installing Lazygit..."
sudo pacman -S --needed --noconfirm lazygit

echo "-> Linking Lazygit configuration..."
rm -rf ~/.config/lazygit
ln -sf ~/github/dotfiles/.config/lazygit ~/.config/lazygit

echo "✅ Lazygit installed successfully!"
