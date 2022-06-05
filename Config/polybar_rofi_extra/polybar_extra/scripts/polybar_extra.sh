#!/usr/bin/env bash

## Copyright (C) 2020-2022 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3

WM_common_config="$HOME/.config/WM_common_config"
PEdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if [ "$1" ]
then
	echo "$1" > "${WM_common_config}/Polybar_Extra_style"
fi

if [ ! $(cat "${WM_common_config}/Polybar_Extra_style") ]
then
	echo "material" > "${WM_common_config}/Polybar_Extra_style"
fi

Style="$(cat ${WM_common_config}/Polybar_Extra_style)"
style_dir="${PEdir}/${Style}"

# Launch the bar
launch_bar() {
	# Terminate already running bar instances
	killall -q polybar

	# Wait until the processes have been shut down
	while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

	# Launch the bar
	if [[ "$Style" == "hack" || "$Style" == "cuts" ]]; then
		polybar -q top -c "${style_dir}/config.ini" &
		polybar -q bottom -c "${style_dir}/config.ini" &
	elif [[ "$Style" == "panels/"* ]]; then
		polybar -q main -c "${PEdir}/${Style}.ini" &
	elif [[ "$Style" == "pwidgets" ]]; then
		bash "${style_dir}"/launch.sh --main
	else
		polybar -q main -c "${style_dir}/config.ini" &	
	fi
}

launch_bar
