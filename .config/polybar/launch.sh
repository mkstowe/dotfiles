#!/usr/bin/env bash 

# Terminate already running bar instances
killall -q polybar

## Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

## Launch
polybar -c ~/.config/polybar/config volume &
polybar -c ~/.config/polybar/config controls &
polybar -c ~/.config/polybar/config spotify &
polybar -c ~/.config/polybar/config wm &
polybar -c ~/.config/polybar/config date &
