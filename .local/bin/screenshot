#!/bin/bash

screenshot_window() {
	IMG="$(xdg-user-dir PICTURES)/screenshot-$(date '+%Y-%m-%d-%H-%M-%S').png"

	import -window root "$IMG"
}

screenshot_region() {
	IMG="/tmp/screenshot-$RANDOM.png"

	import "$IMG" && xclip -selection clipboard -t image/png -i "$IMG"
}

case "$1" in
	-w)
		screenshot_window
	;;
	-r)
		screenshot_region
	;;
	*)
		echo "Usage: $(basename "$0") [<command>]"
		echo
		echo "  -w  Capture window to file"
		echo "  -r  Capture region to clipboard"
		echo "  -h  Show this help"
	;;
esac
