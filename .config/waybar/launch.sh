#!/bin/bash

killall waybar
sleep 0.2

if [[ $USER = "carles" ]]
then
	waybar -c ~/github/dotfiles/.config/waybar/config & -s ~/github/dotfiles/.config/waybar/style.css
else
	waybar &
fi
