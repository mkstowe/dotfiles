#!/usr/bin/env sh
#
# Rofi powered menu to take a screenshot of the whole screen, a selected area or
# the active window. The image is then saved and copied to the clipboard.
# Uses: date maim notify-send rofi xclip xdotool

save_location="$HOME/Pictures/screenshots"
screenshot_path="$save_location/$(date +'%Y-%m-%d-%H%M%S').png"

screen=''
area=''
window=''

chosen=$(printf '%s;%s;%s\n' "$screen" "$area" "$window" \
    | rofi -theme-str '@import "screenshot.rasi"' \
           -dmenu \
           -sep ';' \
           -selected-row 1)

case "$chosen" in
    "$screen") extra_args='screen' ;;
    "$area")   extra_args='area' ;;
    "$window") extra_args="active" ;;
    *)         exit 1 ;;
esac

grimblast --notify save $extra_args $screenshot_path
