#!/bin/bash

function notification() {
  notify-send -t 1000 \
    -h string:synchronous:volume \
    -h int:value:$PERCENTAGE \
    -h string:hlcolor:#FFFFFF \
    "$MESSAGE"
}

function volume() {
  case "$1" in
    up)
      pactl set-sink-volume @DEFAULT_SINK@ +5%
      VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | sed 's/%//')
      MESSAGE="Volume: $VOLUME"
      PERCENTAGE=$VOLUME
      ;;
    down)
      pactl set-sink-volume @DEFAULT_SINK@ -5%
      VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | sed 's/%//')
      MESSAGE="Volume: $VOLUME"
      PERCENTAGE=$VOLUME
      ;;
    mute)
      pactl set-sink-mute @DEFAULT_SINK@ toggle
      MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
      if [ "$MUTED" = "yes" ]; then
        MESSAGE="🔇 Muted"
        PERCENTAGE=0
      else
        VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | sed 's/%//')
        MESSAGE="🔊 Unmuted ($VOLUME%)"
        PERCENTAGE=$VOLUME
      fi
      ;;
  esac
  notification
}

function brightness() {
  case "$1" in
    up)
      brightnessctl set 5%+
      BRIGHTNESS=$(brightnessctl -m | sed 's/.*,\([0-9]*\)%.*/\1/')
      MESSAGE="Brightness: $BRIGHTNESS"
      PERCENTAGE=$BRIGHTNESS
      ;;
    down)
      brightnessctl set 5%-
      BRIGHTNESS=$(brightnessctl -m | sed 's/.*,\([0-9]*\)%.*/\1/')
      MESSAGE="Brightness: $BRIGHTNESS"
      PERCENTAGE=$BRIGHTNESS
      ;;
  esac
  notification
}

case "$1" in
  volume)
    volume "$2"
    ;;
  brightness)
    brightness "$2"
    ;;
esac
