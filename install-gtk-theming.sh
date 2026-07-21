#!/usr/bin/env bash
set -e

echo "=== Linking GTK Theming Configuration ==="

echo "-> Linking GTK 3 configuration..."
rm -rf ~/.config/gtk-3.0
ln -sf ~/github/dotfiles/.config/gtk-3.0 ~/.config/gtk-3.0

echo "-> Linking GTK 4 configuration..."
rm -rf ~/.config/gtk-4.0
ln -sf ~/github/dotfiles/.config/gtk-4.0 ~/.config/gtk-4.0

echo "✅ GTK theming configuration linked successfully!"
