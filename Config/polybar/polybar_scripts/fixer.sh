#!/usr/bin/env bash

## Copyright (C) 2020-2022 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3

Laptop_Name="$(cat /sys/class/dmi/id/product_version)"

if [[ "$Laptop_Name" ]]; then
	Laptop_Thinkpad_X1="$(echo ${Laptop_Name,,} | grep 'thinkpad')"
fi

## Files and Directories
P_Dir="$HOME/.config/polybar"
PE_Dir="$HOME/.config/polybar_extra"
SFILE="$P_Dir/system.ini"

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
;; temperature = ${system.temperature}

[system]
adapter = ACAD
battery = BAT1
graphics_card = amdgpu_bl0
network_interface = ens32
AC_only_prefix = "  "
AC_only_content = " AC only "
temperature = temperature_path

;; _-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
EOF
}

## Get system variable values for various modules
get_values() {
	if command -v light >/dev/null
	then
		CARD=$(light -L | grep 'backlight' | head -n1 | cut -d'/' -f3)
	fi
	
	if command -v upower >/dev/null
	then
		BATTERY=$(upower -i `upower -e | grep 'BAT'` | grep 'native-path' | cut -d':' -f2 | tr -d '[:blank:]')
		ADAPTER=$(upower -i `upower -e | grep 'AC'` | grep 'native-path' | cut -d':' -f2 | tr -d '[:blank:]')
	fi
	
	INTERFACE=$(ip link | awk '/state UP/ {print $2}' | tr -d :)
	
	#varibale TemperaturePath are set at the end
	TemperaturePath="$((for i in /sys/class/hwmon/hwmon*/temp*_input; do echo "$(<$(dirname $i)/name): $(cat ${i%_*}_label 2>/dev/null || echo $(basename ${i%_*})) $(readlink -f $i)"; done) | grep "coretemp" | grep "temp1" | awk '{print $5}')"
	
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
	
	if [[ "$TemperaturePath" ]]; then
		sed -i -e "s|temperature = .*|temperature = $TemperaturePath|g" 	${SFILE}
	fi
}

# Fix backlight and network modules
fix_modules() {
	if [[ -z "$CARD" ]]; then
		find $P_Dir -mindepth 1 -type d -not -name 'scripts' -exec sed -i -e 's/ backlight / bna /g' {}/config.ini \;
	elif [[ "$CARD" != *"intel_"* ]] || [[ "$Laptop_Thinkpad_X1" ]] ; then
		find $P_Dir -mindepth 1 -type d -not -name 'scripts' -exec sed -i -e 's/ backlight / brightness /g' {}/config.ini \;
	fi

	if [[ "$INTERFACE" == e* ]]; then
		find $P_Dir -mindepth 1 -type d -not -name 'scripts' -exec sed -i -e 's/ network / ethernet /g' {}/config.ini \;
	fi
	
	if [[ "$(cat /sys/class/dmi/id/chassis_type)" != @(8|9|10|14) ]]; then
		find $P_Dir -mindepth 1 -type d -not -name 'scripts' -exec sed -i -e 's/ battery / AC_only /g' {}/config.ini \;
	fi
	
	if [[ -d "$PE_Dir" ]]; then
		if [[ -z "$CARD" ]]; then
			find $PE_Dir -mindepth 1 -type d -not -name 'scripts' -not -name 'panels' -not -name 'pwidgets' -exec sed -i -e 's/ backlight / bna /g' {}/config.ini \;
			find $PE_Dir/panels -type f -exec sed -i -e 's/ backlight / bna /g' {} \;
			find $PE_Dir/pwidgets -type f -exec sed -i -e 's/ backlight / bna /g' {} \;
		elif [[ "$CARD" != *"intel_"* ]]; then
			find $PE_Dir -mindepth 1 -type d -not -name 'scripts' -not -name 'panels' -not -name 'pwidgets' -exec sed -i -e 's/ backlight / brightness /g' {}/config.ini \;
			find $PE_Dir/panels -type f -exec sed -i -e 's/ backlight / brightness /g' {} \;
			find $PE_Dir/pwidgets -type f -exec sed -i -e 's/ backlight / brightness /g' {} \;
		fi
	
		if [[ "$INTERFACE" == e* ]]; then
			find $PE_Dir -mindepth 1 -type d -not -name 'scripts' -not -name 'panels' -not -name 'pwidgets' -exec sed -i -e 's/ network / ethernet /g' {}/config.ini \;
			find $PE_Dir/panels -type f -exec sed -i -e 's/ network / ethernet /g' {} \;
			find $PE_Dir/pwidgets -type f -exec sed -i -e 's/ network / ethernet /g' {} \;
		fi
		
		if [[ "$(cat /sys/class/dmi/id/chassis_type)" != @(8|9|10|14) ]]; then
			find $PE_Dir -mindepth 1 -type d -not -name 'scripts' -not -name 'panels' -not -name 'pwidgets' -exec sed -i -e 's/ battery / AC_only /g' {}/config.ini \;
			find $PE_Dir/panels -type f -exec sed -i -e 's/ battery / AC_only /g' {} \;
			find $PE_Dir/pwidgets -type f -exec sed -i -e 's/ battery / AC_only /g' {} \;
		fi
	fi	
}

create_system_file_ini
get_values
set_values
fix_modules
