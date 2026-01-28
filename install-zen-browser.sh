#!/usr/bin/env bash
set -e

echo "=== Installing Zen Browser ==="

if command -v paru &> /dev/null; then
    echo "-> Installing zen-browser-bin (AUR)..."
    paru -S --needed --noconfirm zen-browser-bin
else
    echo "Error: paru not found. Please install paru first."
    exit 1
fi

echo "✅ Zen Browser installed successfully!"
