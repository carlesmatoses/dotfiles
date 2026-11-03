#!/usr/bin/env bash
# Toggles wf-recorder: stops+saves if already recording, otherwise starts a new one.
# Usage: screenrecord.sh [region]   ("region" prompts a slurp selection instead of full screen)

OUT_DIR="$HOME/Videos/Recordings"
mkdir -p "$OUT_DIR"

if pgrep -x wf-recorder >/dev/null; then
    pkill -INT -x wf-recorder
    notify-send "Screen Recording" "Stopped and saved"
    exit 0
fi

file="$OUT_DIR/$(date +'%Y-%m-%d_%H-%M-%S').mp4"

if [ "$1" = "region" ]; then
    geometry=$(slurp) || exit 1
    wf-recorder -g "$geometry" -f "$file" </dev/null &
else
    # wf-recorder needs an explicit output on multi-monitor setups, otherwise it
    # blocks on an interactive prompt and exits immediately when run from a keybind.
    monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused==true) | .name')
    wf-recorder -o "$monitor" -f "$file" </dev/null &
fi
disown

notify-send "Screen Recording" "Started: $(basename "$file")"
