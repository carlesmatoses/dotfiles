#!/usr/bin/env bash
set -e

echo "=== Installing Mako (Notification Daemon) ==="

echo "-> Installing Mako..."
sudo pacman -S --needed --noconfirm mako

echo "-> Linking Mako configuration..."
rm -rf ~/.config/mako
ln -sf ~/github/dotfiles/.config/mako ~/.config/mako

echo "✅ Mako installed successfully!"
