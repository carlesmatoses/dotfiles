#!/usr/bin/env bash
set -e

echo "=== Installing Extra Applications ==="

# 1. Install Sioyek (PDF reader)
echo "-> Installing Sioyek (PDF reader)..."
if command -v paru &> /dev/null; then
    paru -S --needed --noconfirm sioyek
fi

# 2. Install OpenSSH
echo "-> Installing OpenSSH..."
if command -v paru &> /dev/null; then
    paru -S --needed --noconfirm openssh
else
    sudo pacman -S --needed --noconfirm openssh
fi

echo "✅ Extra applications installed successfully!"
