#!/usr/bin/env bash

## Copyright (C) 2020-2022 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3
## Files and Directories
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SFILE="$DIR/system.ini"

## create `system.ini` file
create_system_file_ini() {
cat << 'EOF' > $SFILE
## Copyright (C) 2020-2022 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3
;; _-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
;;
;; System Variables (Edit according to your system)
;;
;; Warning : DO NOT DELETE THIS FILE
;;
;; Run `ls -1 /sys/class/power_supply/` to list list batteries and adapters.
;;
;; Run `ls -1 /sys/class/backlight/` to list available graphics cards.
;;
;; Run `ip link | awk '/state UP/ {print $2}' | tr -d :` to get active network interface.
;;
;; Polybar Variables For Modules :
;; card = ${system.graphics_card}
;; battery = ${system.battery}
;; adapter = ACAD
;; interface = ${system.network_interface}

[system]
adapter = ACAD
battery = BAT1
graphics_card = amdgpu_bl0
network_interface = ens32

;; _-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
EOF
}

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

# Fix backlight and network modules
fix_modules() {
	
	Fdir="$i"
	
	if [[ -z "$CARD" ]]; then
		sed -i -e 's/backlight/bna/g' "$Fdir"/config.ini
	elif [[ "$CARD" != *"intel_"* ]]; then
		sed -i -e 's/backlight/brightness/g' "$Fdir"/config.ini
	fi

	if [[ "$INTERFACE" == e* ]]; then
		sed -i -e 's/network/ethernet/g' "$Fdir"/config.ini
	fi
}

create_system_file_ini
get_values
set_values

fix_modules


