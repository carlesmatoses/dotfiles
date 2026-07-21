#!/usr/bin/env bash
set -e

echo "=== Installing Tmux ==="

echo "-> Installing Tmux..."
sudo pacman -S --needed --noconfirm tmux

echo "-> Linking Tmux configuration..."
rm -f ~/.tmux.conf
ln -sf ~/github/dotfiles/.tmux.conf ~/.tmux.conf

echo "✅ Tmux installed successfully!"
