#!/usr/bin/env bash

# Get device hostname
DEVICE=$(cat /etc/hostname)
MONITORS_DIR="$HOME/.config/hypr/monitors"

# Return the path to the correct monitor config for this device
if [ -f "$MONITORS_DIR/$DEVICE.conf" ]; then
    echo "$MONITORS_DIR/$DEVICE.conf"
else
    echo "# No monitor config found for device: $DEVICE" >&2
    echo "# Please create: $MONITORS_DIR/$DEVICE.conf" >&2
    # Return empty/fallback config
    echo ""
fi
