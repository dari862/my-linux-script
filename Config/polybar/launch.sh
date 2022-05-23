#!/usr/bin/env bash

## Copyright (C) 2020-2022 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3

## Files and Directories
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

## Launch Polybar with selected style
launch_bar() {
	STYLE="$(cat $DIR/style)"
	bash "$DIR"/launch-style.sh $STYLE $DIR
}

# Execute functions
if [[ ! -f "$SFILE" ]]; then
	bash "$DIR"/fixer.sh
fi
launch_bar
