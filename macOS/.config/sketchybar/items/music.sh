#!/bin/bash

music=(
	script="$PLUGIN_DIR/music.sh"
	# icon=􁁒
    label="Yukiho HAGIWARA"
	background.image=media.artwork
	background.image.scale=0.8
	background.image.corner_radius=8
	background.image.border_color="$TRANSPARENT"
    background.image.padding_left=6
    background.color="$TRANSPARENT"
    background.corner_radius=$CORNER_RADIUS
    # background.border_color="$TRANSPARENT"
    # background.border_width=$BORDER_WIDTH
	label.max_chars=20
	scroll_texts=true
    label.scroll_duration=400
    icon.drawing=off
    label.padding_left=44
    label.padding_right=12
	--subscribe music \
        media_change system_woke \
        mouse.entered mouse.exited mouse.exited.global mouse.clicked

)

music_popup_title=(
    icon=󰝚
    label="loading ..."
    background.color="$TRANSPARENT"
	label.max_chars=40
	scroll_texts=true
    label.scroll_duration=100
)

music_popup_artist=(
    icon=󰠃
    label="loading ..."
    background.color="$TRANSPARENT"
	label.max_chars=40
	scroll_texts=true
    label.scroll_duration=100
)

music_popup_album=(
    icon=󰀥
    label="loading ..."
    background.color="$TRANSPARENT"
	label.max_chars=40
	scroll_texts=true
    label.scroll_duration=100
)


sketchybar \
	--add item music right \
	--set music "${music[@]}" \
    --add item music_popup_title popup.music \
    --set music_popup_title "${music_popup_title[@]}" \
    --add item music_popup_artist popup.music \
    --set music_popup_artist "${music_popup_artist[@]}" \
    --add item music_popup_album popup.music \
    --set music_popup_album "${music_popup_album[@]}" \
