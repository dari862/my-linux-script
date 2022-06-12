#!/usr/bin/env bash

## Copyright (C) 2020-2022 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3

## Files and Directories
Pdir="$HOME/.config/polybar"
Pscriptdir="$HOME/.local/bin/polybar"
PEscriptdir="$HOME/.local/bin/polybar_extra"
WM_common_config="$HOME/.config/WM_common_config"


if [[ ! -f "${WM_common_config}/Polybar_style" ]]; then
	echo "old" > ${WM_common_config}/Polybar_style
fi

P_style="$(cat ${WM_common_config}/Polybar_style)"
SFILE="$Pdir/system.ini"

## Launch Polybar with selected style
launch_bar() {
	bash "$Pscriptdir"/launch-style.sh $P_style $Pdir
}

# Execute functions
if [[ ! -f "$SFILE" ]]; then
	bash "$Pscriptdir"/fixer.sh
fi

if [[ "$P_style" != "extra" ]]; then
	launch_bar
else
	# Execute functions
	bash "$PEscriptdir"/polybar_extra.sh
fi
