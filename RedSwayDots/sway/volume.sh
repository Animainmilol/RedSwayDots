#!/bin/bash

VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | sed 's/%//')
MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

case "$1" in
    up)
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        VOLUME=$((VOLUME + 5))
        ;;
    down)
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        VOLUME=$((VOLUME - 5))
        ;;
    mute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        if [ "$MUTED" = "yes" ]; then
            MESSAGE="🔇 Muted"
        else
            MESSAGE="🔊 Unmuted ($VOLUME%)"
        fi
        ;;
    *)
        echo "Usage: $0 {up|down|mute}"
        exit 1
        ;;
esac

if [ "$MUTED" = "yes" ]; then
    notify-send -t 1000 \
        -h string:synchronous:volume \
        -h int:value:0 \
        -h string:hlcolor:#FFFFFF \
        "Volume: Muted" ""
else
    notify-send -t 1000 \
        -h string:synchronous:volume \
        -h int:value:$VOLUME \
        -h string:hlcolor:#FFFFFF \
        "Volume: $VOLUME%" ""
fi
