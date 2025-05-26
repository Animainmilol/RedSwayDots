#!/bin/bash

BRIGHTNESS=$(brightnessctl -m | sed 's/.*,\([0-9]*\)%.*/\1/')

case "$1" in
    up)
        brightnessctl set 5%+
        BRIGHTNESS=$((BRIGHTNESS + 5))
        ;;
    down)
        brightnessctl set 5%-
        BRIGHTNESS=$((BRIGHTNESS - 5))
        ;;
    *)
        echo "Usage: $0 {up|down}"
        exit 1
        ;;
esac

notify-send -t 1000 \
    -h string:synchronous:volume \
    -h int:value:$BRIGHTNESS \
    -h string:hlcolor:#FFFFFF \
    "Brightness: $BRIGHTNESS%" ""
