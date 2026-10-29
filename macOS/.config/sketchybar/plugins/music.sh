#!/bin/bash

PLAYER_STATE="$(echo $INFO | jq -r '.state')"

if [ "$PLAYER_STATE" = "playing" ]; then
	ICON=
else
	ICON=
fi

update_music_info()
{
    # main
    CURRENT_SONG="$(echo $INFO | jq -r '.title + " - " + .artist')"
    sketchybar --set $NAME label="$CURRENT_SONG" drawing=on

    # popup
    TITLE_NAME="$(echo $INFO | jq -r '.title')"
    ARTIST_NAME="$(echo $INFO | jq -r '.artist')"
    ALBUM_NAME="$(echo $INFO | jq -r '.album')"
    sketchybar --set "$NAME" popup.drawing=$1 \
        --set music_popup_title \
            label="$TITLE_NAME" \
        --set music_popup_artist \
            label="$ARTIST_NAME" \
        --set music_popup_album \
            label="$ALBUM_NAME"
}

popup()
{
    # say $INFO
    sketchybar --set "$NAME" popup.drawing=$1
}

case "$SENDER" in
    "media_change")
        update_music_info
        ;;
    "mouse.exited" | "mouse.exited.global")
        popup off
        ;;
    "mouse.clicked")
        popup toggle
        ;;
esac
