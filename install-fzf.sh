#!/usr/bin/env bash
set -e

echo "=== Installing fzf (Fuzzy Finder) ==="

# 1. Install fzf
echo "-> Installing fzf..."
if command -v paru &> /dev/null; then
    paru -S --needed --noconfirm fzf
else
    sudo pacman -S --needed --noconfirm fzf
fi

# 2. Install fzf shell completions and key bindings
echo "-> Setting up fzf shell integration..."
if [ -d "/usr/share/fzf" ]; then
    echo "ℹ️  fzf shell integration available at /usr/share/fzf"
else
    echo "ℹ️  fzf installed"
fi

echo "✅ fzf (Fuzzy Finder) installed successfully!"
