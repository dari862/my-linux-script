#!/usr/bin/env bash

## Copyright (C) 2020-2022 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3

## Files and Directories
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SFILE="$DIR/system.ini"
RFILE="$DIR/.system"

## Get system variable values for various modules
get_values() {
	CARD=$(light -L | grep 'backlight' | head -n1 | cut -d'/' -f3)
	BATTERY=$(upower -i `upower -e | grep 'BAT'` | grep 'native-path' | cut -d':' -f2 | tr -d '[:blank:]')
	ADAPTER=$(upower -i `upower -e | grep 'AC'` | grep 'native-path' | cut -d':' -f2 | tr -d '[:blank:]')
	INTERFACE=$(ip link | awk '/state UP/ {print $2}' | tr -d :)
}

## Write values to `system.ini` file
set_values() {
	if [[ "$ADAPTER" ]]; then
		sed -i -e "s/adapter = .*/adapter = $ADAPTER/g" 						${SFILE}
	fi
	if [[ "$BATTERY" ]]; then
		sed -i -e "s/battery = .*/battery = $BATTERY/g" 						${SFILE}
	fi
	if [[ "$CARD" ]]; then
		sed -i -e "s/graphics_card = .*/graphics_card = $CARD/g" 				${SFILE}
	fi
	if [[ "$INTERFACE" ]]; then
		sed -i -e "s/network_interface = .*/network_interface = $INTERFACE/g" 	${SFILE}
	fi
}

## Launch Polybar with selected style
launch_bar() {
	STYLE="$(cat $DIR/style)"
	bash "$DIR"/launch-style.sh $STYLE $DIR
}

# Execute functions
if [[ ! -f "$RFILE" ]]; then
	get_values
	set_values
	touch ${RFILE}
fi
launch_bar



fix_modules() {
	if [[ -z "$CARD" ]]; then
		find $DIR -mindepth 1 -type d -not -name 'scripts' -not -name 'panels' -not -name 'pwidgets' -exec sed -i -e 's/ backlight / bna /g' {}/config.ini \;
		find $DIR/panels -type f -exec sed -i -e 's/ backlight / bna /g' {} \;
		find $DIR/pwidgets -type f -exec sed -i -e 's/ backlight / bna /g' {} \;
	elif [[ "$CARD" != *"intel_"* ]]; then
		find $DIR -mindepth 1 -type d -not -name 'scripts' -not -name 'panels' -not -name 'pwidgets' -exec sed -i -e 's/ backlight / brightness /g' {}/config.ini \;
		find $DIR/panels -type f -exec sed -i -e 's/ backlight / brightness /g' {} \;
		find $DIR/pwidgets -type f -exec sed -i -e 's/ backlight / brightness /g' {} \;
	fi

	if [[ "$INTERFACE" == e* ]]; then
		find $DIR -mindepth 1 -type d -not -name 'scripts' -not -name 'panels' -not -name 'pwidgets' -exec sed -i -e 's/ network / ethernet /g' {}/config.ini \;
		find $DIR/panels -type f -exec sed -i -e 's/ network / ethernet /g' {} \;
		find $DIR/pwidgets -type f -exec sed -i -e 's/ network / ethernet /g' {} \;
	fi
}
