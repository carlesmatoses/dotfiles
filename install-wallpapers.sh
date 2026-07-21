#!/usr/bin/env bash
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WALLPAPER_DIR="$SCRIPT_DIR/.config/hypr/wallpapers"

echo "=== Installing Wallpapers ==="

existing=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" -o -name "*.gif" \) -print -quit)

if [ -n "$existing" ]; then
    echo "ℹ️  Wallpapers already present, skipping download."
else
    echo "-> Downloading wallpapers..."
    chmod +x "$WALLPAPER_DIR/downloader.sh"
    (cd "$WALLPAPER_DIR" && ./downloader.sh)
fi

echo "✅ Wallpapers installed successfully!"
