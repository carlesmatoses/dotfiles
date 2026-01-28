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

echo "✅ wlogout installed successfully!"
echo ""
echo "ℹ️  wlogout configuration will be linked from .config/wlogout"
echo "   This happens automatically when sym-link.sh is executed."
