#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers/"

# Detect device by hostname
DEVICE=$(cat /etc/hostname)

# Define monitors for each device
declare -A DEVICE_MONITORS
DEVICE_MONITORS["carles-pc"]="DP-1 HDMI-A-1"
DEVICE_MONITORS["carles-lpt"]=""  # Add your laptop monitors here

# Get monitors for current device
MONITORS=(${DEVICE_MONITORS[$DEVICE]})

if [ ${#MONITORS[@]} -eq 0 ]; then
    echo "No monitors configured for device: $DEVICE"
    echo "Auto-detecting monitors..."
    # Auto-detect monitors using hyprctl
    MONITORS=($(hyprctl monitors | grep -oP 'Monitor \K[^ ]+'))
fi

echo "Device: $DEVICE"
echo "Monitors: ${MONITORS[@]}"

if [ -n "$1" ] && [ -f "$1" ]; then
    # Explicit wallpaper passed in (e.g. from wallpaper-picker.sh) - skip random pick
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

# Update hyprpaper configuration
HYPRPAPER_CONFIG="$HOME/.config/hypr/hyprpaper.conf"
cat > "$HYPRPAPER_CONFIG" << EOF
preload = $WALLPAPER

EOF

# Generate wallpaper blocks for each monitor
for MONITOR in "${MONITORS[@]}"; do
    cat >> "$HYPRPAPER_CONFIG" << EOF
wallpaper {
    monitor = $MONITOR
    path = $WALLPAPER
    fit_mode = cover
}

EOF
done

# Restart hyprpaper to apply new wallpaper
killall hyprpaper 2>/dev/null
sleep 0.2
hyprpaper >/dev/null 2>&1 &
disown

# Also update hyprlock background
HYPRLOCK_CONFIG="$HOME/.config/hypr/hyprlock.conf"
sed -i '/^background {/,/^}/ s|^    path = .*|    path = '"$WALLPAPER"'|' "$HYPRLOCK_CONFIG"
echo "Hyprlock background also updated to match!"

# set colors with pywal
wal -i "$WALLPAPER" -n

# restart waybar
pkill waybar
waybar >/dev/null 2>&1 &
disown
echo "Waybar restarted to apply new colors!"