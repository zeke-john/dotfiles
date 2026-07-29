#!/bin/bash
# Toggle the player that's currently shown in the waybar module
player=$(cat /tmp/waybar-media-active-player 2>/dev/null)
if [ -n "$player" ]; then
    playerctl -p "$player" play-pause
fi
