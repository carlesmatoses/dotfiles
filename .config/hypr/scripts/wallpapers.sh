#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers/"

# Get all supported wallpaper files (jpg, jpeg, png, webp)
WALLPAPERS=($(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \)))

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    echo "No supported wallpaper files found!"
    exit 1
fi

# Get a random wallpaper
WALLPAPER="$(printf "%s\n" "${WALLPAPERS[@]}" | shuf -n1)"

echo "Setting wallpaper: $(basename "$WALLPAPER")"

# Preload and set the wallpaper
hyprctl hyprpaper preload "$WALLPAPER"
hyprctl hyprpaper wallpaper ",$WALLPAPER"

# Also update hyprlock background
HYPRLOCK_CONFIG="$HOME/.config/hypr/hyprlock.conf"
sed -i '/^background {/,/^}/ s|^    path = .*|    path = '"$WALLPAPER"'|' "$HYPRLOCK_CONFIG"
echo "Hyprlock background also updated to match!"

# set colors with pywal
wal -i "$WALLPAPER" -n

# restart waybar
pkill waybar
waybar &
echo "Waybar restarted to apply new colors!"