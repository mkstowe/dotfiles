#!/usr/bin/env bash

zscroll -l 32 --delay 0.3 \
		--update-check true "playerctl metadata --format \"{{ artist }} - {{ title }}\"" &

wait
