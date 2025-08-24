#!/bin/bash

killall waybar
sleep 0.2

if [[ $USER = "carles" ]]
then
	waybar -c ~/.config/waybar/config & -s ~/.config/waybar/style.css
else
	waybar &
fi
