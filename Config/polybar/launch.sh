#!/usr/bin/env bash

## Copyright (C) 2020-2022 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3

## Files and Directories
Rdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
R_style="$(cat $Rdir/style)"

## Launch Polybar with selected style
launch_bar() {
	bash "$Rdir"/launch-style.sh $R_style $Rdir
}

# Execute functions
if [[ ! -f "$SFILE" ]]; then
	bash "$Rdir"/fixer.sh
fi

if [[ "$R_style" != "extra" ]]; then
	launch_bar
else
	Extra_Polybar_dir="$HOME/.config/polybar_extra"
	# Execute functions
	if [[ ! -f "$SFILE" ]]; then
		bash "$Extra_Polybar_dir"/fixer.sh
	fi
	bash "$Rdir"/polybar_extra.sh
fi
