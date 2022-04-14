#!/usr/bin/env bash

if [[ "$(cat /sys/class/dmi/id/chassis_type)" == @(8|9|10|14) ]] # check if laptop
then 
	export backlight_Driver_name="$(ls -1 /sys/class/backlight/ | head -n 1 || :)" 
	export battery_Driver_name="$(ls -1 /sys/class/power_supply/ | grep --ignore-case -e 'BAT' | head -n 1 || :)" 
	export adapter_Driver_name="$(ls -1 /sys/class/power_supply/ | grep --ignore-case -e 'AC' | head -n 1 || :)" 
fi

export eth_Driver_name="$(ls -1 /sys/class/net/ | grep -v 'lo' | grep --ignore-case -e 'e' | head -n 1 || :)" 
export wlan_Driver_name="$(ls -1 /sys/class/net/ | grep -v 'lo' | grep --ignore-case -e 'w' | head -n 1 || :)"
export normal_network_Driver_name="$wlan_Driver_name"

if [ -z "$wlan_Driver_name" ]
then
	export normal_network_Driver_name="$eth_Driver_name"
fi


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
