#!/usr/bin/env bash
exec 2>"$XDG_RUNTIME_DIR/waybar-playerctl.log"
IFS=$'\n\t'

while true; do

	while read -r playing position length name artist title arturl hpos hlen; do
		# remove leaders
		playing=${playing:1} position=${position:1} length=${length:1} name=${name:1}
		artist=${artist:1} title=${title:1} arturl=${arturl:1} hpos=${hpos:1} hlen=${hlen:1}

		# build line
		line="${hpos:+$hpos${hlen:+|}}$hlen / ${artist:+$artist ${title:+- }}${title:+$title }"

		# json escaping
		line="${line//\"/\\\"}"
		((percentage = length ? (100 * (position % length)) / length : 0))
		case $playing in
		⏸️ | Paused) text='<span size=\"smaller\">'"$line"'</span>' ; class='paused' ;;
		▶️ | Playing) text="<small>$line</small>" ; class='playing' ;;
		*) text='<span foreground=\"#073642\">⏹</span>' ;;
		esac

		# exit if print fails
		printf '{"text":"%s","tooltip":"%s","class":"%s","percentage":%s}\n' \
			"$text" "$line" "$class" "$percentage" || break 2

	done < <(
		# requires playerctl>=2.0
		# Add non-space character ":" before each parameter to prevent 'read' from skipping over them
		playerctl --follow metadata --player playerctld --format \
			$':{{emoji(status)}}\t:{{position}}\t:{{mpris:length}}\t:{{playerName}}\t:{{markup_escape(artist)}}\t:{{markup_escape(title)}}\t:{{mpris:artUrl}}\t:{{duration(position)}}\t:{{duration(mpris:length)}}' &
		echo $! >"$XDG_RUNTIME_DIR/waybar-playerctl.pid"
	)

	# no current players
	# exit if print fails
	echo '<span foreground=#dc322f>⏹</span>' || break
	sleep 15

done

kill "$(<"$XDG_RUNTIME_DIR/waybar-playerctl.pid")"

