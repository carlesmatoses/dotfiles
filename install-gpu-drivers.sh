#!/usr/bin/env bash
set -e

echo "=== Installing GPU Drivers ==="

# Detect NVIDIA graphics and install driver if present
if lspci | grep -i 'nvidia' >/dev/null; then
    echo "-> NVIDIA graphics detected. Installing NVIDIA driver..."
    if command -v paru &> /dev/null; then
        paru -S --needed --noconfirm nvidia
    else
        sudo pacman -S --needed --noconfirm nvidia
    fi
    echo "✅ NVIDIA driver installed successfully!"
else
    echo "ℹ️  No NVIDIA graphics detected. Skipping driver installation."
fi
