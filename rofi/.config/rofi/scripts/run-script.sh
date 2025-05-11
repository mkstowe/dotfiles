#!/bin/bash

selected=$(ls ~/bin | rofi -theme-str '@import "~/.config/rofi/app-menu.rasi"' -dmenu -p "Run: ")
/bin/bash ~/bin/$selected
