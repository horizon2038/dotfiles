#!/bin/sh

clock=(
   update_freq=10 script="$PLUGIN_DIR/clock.sh" \
   background.color="$TRANSPARENT"
   background.corner_radius=$CORNER_RADIUS
   # background.border_color="$TRANSPARENT"
   # background.border_width=$BORDER_WIDTH
   icon.padding_left=0
   icon.padding_right=0
   label.padding_left=12
   label.padding_right=12
)

sketchybar --add item clock right \
           --set clock "${clock[@]}"
