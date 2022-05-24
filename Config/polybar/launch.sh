#!/usr/bin/env bash

## Copyright (C) 2020-2022 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3

## Files and Directories
Rdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
Extra_Polybar_dir="$HOME/.config/polybar_extra"

## Launch Polybar with selected style
launch_bar() {
	STYLE="$(cat $Rdir/style)"
	bash "$Rdir"/launch-style.sh $STYLE $Rdir
}

# Execute functions
if [[ ! -f "$SFILE" ]]; then
	bash "$Rdir"/fixer.sh
	bash "$Extra_Polybar_dir"/fixer.sh
fi
launch_bar
