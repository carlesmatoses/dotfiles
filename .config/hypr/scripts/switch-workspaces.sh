#!/bin/bash
# Switch to paired workspaces on both monitors
# Usage: switch-workspaces.sh <monitor0_workspace> <monitor1_workspace>

WS1=$1
WS2=$2

hyprctl dispatch "hl.dsp.focus({ workspace = $WS1 })"
hyprctl dispatch "hl.dsp.focus({ monitor = 1 })"
hyprctl dispatch "hl.dsp.focus({ workspace = $WS2 })"
hyprctl dispatch "hl.dsp.focus({ monitor = 0 })"
