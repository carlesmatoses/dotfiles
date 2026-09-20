#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers/"

# The per-monitor list that used to live here only existed to generate
# hyprpaper's per-output wallpaper blocks. Quickshell renders one background
# surface per screen off Quickshell.screens, so no monitor list is needed.

if [ -n "$1" ] && [ -f "$1" ]; then
    # Explicit wallpaper passed in (e.g. from the Quickshell picker) - skip random pick
    WALLPAPER="$1"
else
    # Get all supported wallpaper files (jpg, jpeg, png, webp)
    WALLPAPERS=($(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \)))

    if [ ${#WALLPAPERS[@]} -eq 0 ]; then
        echo "No supported wallpaper files found!"
        exit 1
    fi

    # Get a random wallpaper
    WALLPAPER="$(printf "%s\n" "${WALLPAPERS[@]}" | shuf -n1)"
fi

echo "Setting wallpaper: $(basename "$WALLPAPER")"

# The wallpaper itself is drawn by Quickshell (.config/quickshell/Wallpaper.qml),
# which reads the `wallpaper` key out of ~/.cache/wal/colors.json. `wal -i`
# below writes that file, so setting the colors sets the wallpaper - there is
# no separate config to regenerate and no daemon to restart.

# Also update hyprlock background
HYPRLOCK_CONFIG="$HOME/.config/hypr/hyprlock.conf"
sed -i '/^background {/,/^}/ s|^    path = .*|    path = '"$WALLPAPER"'|' "$HYPRLOCK_CONFIG"
echo "Hyprlock background also updated to match!"

# set colors with pywal
wal -i "$WALLPAPER" -n

# Quickshell reads ~/.cache/wal/colors.json through a watched FileView, so the
# bar, launcher, notifications and wallpaper picker recolor on their own - no
# restart needed. (Waybar used to be restarted here; it is no longer the bar,
# and relaunching it would put a second bar on screen.)
echo "Colors regenerated; Quickshell picks them up automatically."