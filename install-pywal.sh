#!/usr/bin/env bash
set -e

echo "=== Installing Pywal ==="

if command -v paru &> /dev/null; then
    echo "-> Installing python-pywal..."
    paru -S --needed --noconfirm python-pywal
else
    echo "Error: paru not found. Please install paru first."
    exit 1
fi

echo "-> Linking wal configuration..."
rm -rf ~/.config/wal
ln -sf ~/github/dotfiles/.config/wal ~/.config/wal

echo "✅ Pywal installed successfully!"
