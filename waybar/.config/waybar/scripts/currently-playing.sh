#!/bin/bash

status=$(playerctl status)
track=$(playerctl metadata title)
artist=$(playerctl metadata artist)

if [ $status == "Playing" ]
then
  echo "$artist - $track"
else
  echo "-"
fi
