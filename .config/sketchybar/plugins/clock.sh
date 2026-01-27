#!/bin/sh

# The $NAME variable is passed from sketchybar and holds the name of
# the item invoking this script:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

source $HOME/.config/sketchybar/theme.sh

sketchybar --set "$NAME" label="$(date '+%Y-%m-%dT%H:%M [%a]')"
