#!/bin/bash
# Switch to paired workspaces on both monitors
# Usage: switch-workspaces.sh <monitor0_workspace> <monitor1_workspace>

WS1=$1
WS2=$2

hyprctl dispatch workspace $WS1
hyprctl dispatch focusmonitor 0
hyprctl dispatch workspace $WS2
hyprctl dispatch focusmonitor 1
