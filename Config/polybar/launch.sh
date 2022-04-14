#!/usr/bin/env bash

export backlight_Driver_name=""
export battery_Driver_name=""
export adapter_Driver_name=""

dir="$HOME/.config/polybar/Themes"
launch_bar() {
	# Terminate already running bar instances
	killall -q polybar

	# Wait until the processes have been shut down
	while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

	# Launch the bar
	if [[ "$style" == "hack" ]]; then
		polybar -q top -c "$dir/$style/config.ini" &
		polybar -q bottom -c "$dir/$style/config.ini" &
	elif [[ "$style" == "pwidgets" ]]; then
		style2="main"
		polybar -q primary -c "$dir/$style/$style2.ini" &
		polybar -q secondary -c "$dir/$style/$style2.ini" &
		polybar -q top -c "$dir/$style/main.ini" &
	elif [[ "$style" == "Titus" ]]; then
		polybar -q bar -c "$dir/$style/config.ini" &
	else
		polybar -q main -c "$dir/$style/config.ini" &	
	fi
}
	style="$(cat $HOME/.config/polybar/Picked_Theme)"
	launch_bar
