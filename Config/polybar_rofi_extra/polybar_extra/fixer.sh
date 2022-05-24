#!/usr/bin/env bash

## Copyright (C) 2020-2022 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3

## Files and Directories
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

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
