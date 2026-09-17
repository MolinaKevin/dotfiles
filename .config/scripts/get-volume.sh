#!/usr/bin/env bash

status="$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)"

if [ -z "$status" ]; then
    echo "N/A"
    exit 0
fi

if echo "$status" | grep -q "MUTED"; then
    echo "<fc=#ff5555><fn=2>󰝟</fn> MUTED</fc>"
    exit 0
fi

vol="$(echo "$status" | awk '/Volume:/ {printf "%d", $2 * 100}')"

if [ -z "$vol" ]; then
    echo "N/A"
    exit 0
fi

if [ "$vol" -eq 0 ]; then
    icon="󰕿"
elif [ "$vol" -lt 35 ]; then
    icon="󰖀"
else
    icon="󰕾"
fi

echo "<fn=2>$icon</fn> ${vol}%"
