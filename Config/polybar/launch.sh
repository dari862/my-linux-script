#!/usr/bin/env bash

## Copyright (C) 2020-2022 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3

## Files and Directories
Pdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
P_style="$(cat $Pdir/style)"

## Launch Polybar with selected style
launch_bar() {
	bash "$Pdir"/launch-style.sh $P_style $Pdir
}

# Execute functions
if [[ ! -f "$SFILE" ]]; then
	bash "$Pdir"/fixer.sh
fi

if [[ "$P_style" != "extra" ]]; then
	launch_bar
else
	Extra_Polybar_dir="$HOME/.config/polybar_extra"
	# Execute functions
	if [[ ! -f "$SFILE" ]]; then
		bash "$Extra_Polybar_dir"/fixer.sh
	fi
	bash "$Pdir"/polybar_extra.sh
fi
