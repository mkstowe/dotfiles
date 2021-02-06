#!/usr/bin/env bash 

# Terminate already running bar instances
killall -q polybar

## Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

#wm_file = ""
if [ "$XDG_CURRENT_DESKTOP" = 'i3' ]; then
	wm_file="i3-config"
else
	wm_file="bspwm-config"
fi

echo $wm_file

## Launch
polybar -c ~/.config/polybar/$wm_file volume &
polybar -c ~/.config/polybar/$wm_file controls &
polybar -c ~/.config/polybar/$wm_file spotify &
polybar -c ~/.config/polybar/$wm_file wm &
polybar -c ~/.config/polybar/$wm_file date &
polybar -c ~/.config/polybar/$wm_file top &
