#!/usr/bin/env bash

## Copyright (C) 2020-2022 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3

Style="$1"
DIR="${2}/$1"

# Launch the bar
# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar
if [ "$Style" == "hack" ]
then
	polybar -q top -c "$DIR"/config.ini &
	polybar -q bottom -c "$DIR"/config.ini &
else
	polybar -q main -c "$DIR"/config.ini &
fi
