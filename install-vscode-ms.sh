#!/usr/bin/env bash
set -e

echo "=== Installing Visual Studio Code (Microsoft Official) ==="

if command -v paru &> /dev/null; then
    echo "-> Installing visual-studio-code-bin (Microsoft Official)..."
    paru -S --needed --noconfirm visual-studio-code-bin
else
    echo "Error: paru not found. Please install paru first."
    exit 1
fi

echo "✅ Visual Studio Code (Microsoft Official) installed successfully!"
