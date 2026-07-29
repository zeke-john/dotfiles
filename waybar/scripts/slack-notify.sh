#!/bin/bash
title=$(hyprctl clients -j | jq -r '.[] | select(.class == "Slack" or .initialClass == "Slack") | .title' 2>/dev/null)

if [ -z "$title" ]; then
    echo '{"text": "", "class": "idle"}'
elif echo "$title" | grep -qP '^\*|^\(\d+\)'; then
    echo '{"text": "󰒱", "class": "notification", "tooltip": "Slack: Unread messages"}'
else
    echo '{"text": "", "class": "idle"}'
fi
