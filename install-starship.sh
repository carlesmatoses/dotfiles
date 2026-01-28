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

echo "✅ Starship prompt installed successfully!"
echo ""
echo "ℹ️  Starship configuration will be linked from .config/starship.toml"
echo "   This happens automatically when sym-link.sh is executed."
