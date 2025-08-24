#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers/"

# Get all supported wallpaper files (jpg, jpeg, png, webp)
WALLPAPERS=($(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \)))

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    echo "No supported wallpaper files found!"
    exit 1
fi

# Get a random wallpaper
WALLPAPER="${WALLPAPERS[RANDOM % ${#WALLPAPERS[@]}]}"

echo "Setting wallpaper: $(basename "$WALLPAPER")"

# Preload and set the wallpaper
hyprctl hyprpaper preload "$WALLPAPER"
hyprctl hyprpaper wallpaper ",$WALLPAPER"