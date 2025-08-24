#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers/"
HYPRLOCK_CONFIG="$HOME/.config/hypr/hyprlock.conf"

# Get all supported wallpaper files (jpg, jpeg, png, webp)
WALLPAPERS=($(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \)))

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    echo "No supported wallpaper files found!"
    exit 1
fi

# Get a random wallpaper
WALLPAPER="${WALLPAPERS[RANDOM % ${#WALLPAPERS[@]}]}"

echo "Setting hyprlock background: $(basename "$WALLPAPER")"

# Update only the background wallpaper path (not the profile picture)
# This targets the path line that's inside the background section
sed -i '/^background {/,/^}/ s|^    path = .*|    path = '"$WALLPAPER"'|' "$HYPRLOCK_CONFIG"

echo "Hyprlock background updated successfully!"
