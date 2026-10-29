#!/bin/sh

# Some events send additional information specific to the event in the $INFO
# variable. E.g. the front_app_switched event sends the name of the newly
# focused application in the $INFO variable:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

if [ "$SENDER" = "front_app_switched" ]; then
    APP_ICON=""

    case "$INFO" in
        "WezTerm")
            APP_ICON=
            APP_NAME="WezTerm"
            ;;
        "Google Chrome")
            APP_ICON=
            APP_NAME="Chrome"
            ;;
        "ミュージック")
            APP_ICON=
            APP_NAME="Music"
            ;;
        "Slack")
            APP_ICON=
            APP_NAME="Slack"
            ;;
        "Discord")
            APP_ICON=
            APP_NAME="Discord"
            ;;
        *)
            APP_NAME=$INFO

    esac
    sketchybar --set "$NAME" label="$APP_NAME" icon="$APP_ICON"
fi

