#!/usr/bin/env bash

## Copyright (C) 2020-2022 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3

Pdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
Style="$(cat $Rdir/style)"

if [ ! -z "$1" ]
then
	echo "$1" > "${Pdir}/style"
fi

style_dir="$Pdir/$style"

# Launch the bar
launch_bar() {
	# Terminate already running bar instances
	killall -q polybar

	# Wait until the processes have been shut down
	while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

	# Launch the bar
	if [[ "$style" == "hack" || "$style" == "cuts" ]]; then
		polybar -q top -c "${style_dir}/config.ini" &
		polybar -q bottom -c "${style_dir}/config.ini" &
	elif [[ "$style" == "panels" ]]; then
		panel="$(cat ${dir}/scripts/panels/panel )"
		polybar -q main -c "${style_dir}/$panel.ini" &
	elif [[ "$style" == "pwidgets" ]]; then
		bash "${style_dir}"/launch.sh --main
	else
		polybar -q main -c "${style_dir}/config.ini" &	
	fi
}

launch_bar
