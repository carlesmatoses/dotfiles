#!/usr/bin/env bash
# Click a window to screenshot it, saving to file AND copying to the clipboard.
# Usage: screenshot-window.sh [active]   ("active" grabs the focused window, no click)

# grim -T captures the window's own buffer via the foreign-toplevel protocol, so
# overlapping windows never bleed in (unlike a grim -g screen rectangle).
# Hyprland's stableId is that toplevel identifier -- .address does NOT work here.

OUT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$OUT_DIR"

clients=$(hyprctl clients -j)

if [ "$1" = "active" ]; then
    id=$(hyprctl activewindow -j | jq -r '.stableId')
else
    # Feed every on-screen window as a box to slurp -r, so one click snaps to a
    # whole window, then map the chosen geometry back to its stableId.
    geometry=$(printf '%s' "$clients" \
        | jq -r '.[] | select(.mapped and .visible and (.hidden | not))
                 | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' \
        | slurp -r) || exit 1

    id=$(printf '%s' "$clients" | jq -r --arg g "$geometry" '
        .[] | select("\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])" == $g)
            | .stableId' | head -1)
fi

if [ -z "$id" ] || [ "$id" = "null" ]; then
    notify-send "Screenshot" "No window found"
    exit 1
fi

file="$OUT_DIR/$(date +'%Y-%m-%d_%H-%M-%S').png"

if grim -T "$id" - | tee "$file" | wl-copy; then
    notify-send "Screenshot" "Window saved: $(basename "$file")"
else
    notify-send "Screenshot" "Capture failed"
    exit 1
fi
