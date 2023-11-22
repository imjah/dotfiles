#!/bin/bash

init() {
	[ -z $BULBS_IP ] && echo "IP not found" && exit 1
}

get() {
	curl -s "$BULBS_IP/$1"
}

put() {
	curl -s -X PUT "$BULBS_IP/$1"
}

get_power_status_reversed() {
	grep -q "0" <<< $(get "led/on") && echo "on" || echo "off"
}

parse_brightness() {
	s=${1:0:1}

	if [ $s == "+" ] || [ $s == "-" ]; then
		b=$(get "led/brightness")
		echo $(python -c "print(((${b:15:-2}*100+$1)/100)%1)")
	else
		echo $1
	fi
}

main() {
	init
	
	case "$1" in
		-c)
			put "led/color/$2"
		;;
		-b)
			put "led/brightness/$(parse_brightness $2)"
		;;
		-o)
			put "led/on"
		;;
		-f)
			put "led/off"
		;;
		-t)
			put "led/$(get_power_status_reversed)"
		;;
		-h)
			echo "Usage: $(basename $0) [<option>] [value]"
			echo
			echo "Options:"
			echo "  -c  Set color"
			echo "  -b  Set brightness"
			echo "  -o  Turn on the light"
			echo "  -f  Turn off the light"
			echo "  -t  Toggle the light"
			echo "  -l  Show status (default)"
			echo "  -h  Show help"
		;;
		*)
			get "led"
		;;
	esac
}; main $@
