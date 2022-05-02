#!/usr/bin/env bash

## Dirs #############################################
terminal_path="$HOME/.config/xfce4/terminal"
geany_path="$HOME/.config/geany"
openbox_path="$HOME/.config/openbox"
rofi_path="$HOME/.config/rofi"
dunst_path="$HOME/.config/dunst"

# wallpaper ---------------------------------
set_wall() {
	nitrogen --save --set-zoom-fill /usr/share/backgrounds/"$1"
}

# rofi --------------------------------------
change_rofi() {
	sed -i -e "s/STYLE=.*/STYLE=\"$1\"/g" 						${rofi_path}/bin/music ${rofi_path}/bin/network ${rofi_path}/bin/screenshot ${rofi_path}/bin/runner
	sed -i -e "s/STYLE=.*/STYLE=\"$1\"/g" 						${rofi_path}/bin/launcher ${rofi_path}/bin/powermenu
	sed -i -e "s/font:.*/font:				 	\"$2\";/g" 		${rofi_path}/"$1"/font.rasi

	sed -i -e "s/font:.*/font:				 	\"$2\";/g" 			${rofi_path}/dialogs/askpass.rasi ${rofi_path}/dialogs/confirm.rasi
	sed -i -e "s/border:.*/border:					$3;/g" 			${rofi_path}/dialogs/askpass.rasi ${rofi_path}/dialogs/confirm.rasi
	sed -i -e "s/border-radius:.*/border-radius:          $4;/g" 	${rofi_path}/dialogs/askpass.rasi ${rofi_path}/dialogs/confirm.rasi

	if [[ -f "$HOME"/.config/rofi/config.rasi ]]; then
		sed -i -e "s/icon-theme:.*/icon-theme:         \"$5\";/g" 	"$HOME"/.config/rofi/config.rasi
	fi

	cat > ${rofi_path}/dialogs/colors.rasi <<- _EOF_
	/* Color-Scheme */

	* {
	    BG:    #212B30ff;
	    FG:    #C4C7C5ff;
	    BDR:   #EC407Aff;
	}
	_EOF_
}


# openbox -----------------------------------
obconfig () {
	namespace="http://openbox.org/3.4/rc"
	config="$openbox_path/rc.xml"
	theme="$1"
	layout="$2"
	font="$3"
	fontsize="$4"

	# Theme
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:name' -v "$theme" "$config"

	# Title
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:titleLayout' -v "$layout" "$config"

	# Fonts
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:weight' -v Bold "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:weight' -v Normal "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:weight' -v Bold "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:weight' -v Normal "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:weight' -v Bold "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:slant' -v Normal "$config"

	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:name' -v "$font" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:size' -v "$fontsize" "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:weight' -v Normal "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:slant' -v Normal "$config"

	# Openbox Menu Style
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:menu/a:file' -v "$5" "$config"

	# Margins
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:margins/a:top' -v 0 "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:margins/a:bottom' -v 10 "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:margins/a:left' -v 10 "$config"
	xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:margins/a:right' -v 10 "$config"
}


# dunst -------------------------------------
change_dunst() {
	sed -i -e "s/width = .*/width = $1/g" 						${dunst_path}/dunstrc
	sed -i -e "s/height = .*/height = $2/g" 					${dunst_path}/dunstrc
	sed -i -e "s/offset = .*/offset = $3/g" 					${dunst_path}/dunstrc
	sed -i -e "s/origin = .*/origin = $4/g" 					${dunst_path}/dunstrc
	sed -i -e "s/font = .*/font = $5/g" 						${dunst_path}/dunstrc
	sed -i -e "s/frame_width = .*/frame_width = $6/g" 			${dunst_path}/dunstrc
	sed -i -e "s/separator_height = .*/separator_height = 4/g" 	${dunst_path}/dunstrc
	sed -i -e "s/line_height = .*/line_height = 4/g" 			${dunst_path}/dunstrc

	sed -i '/urgency_low/Q' ${dunst_path}/dunstrc
	cat >> ${dunst_path}/dunstrc <<- _EOF_
		[urgency_low]
		timeout = 2
		background = "#212B30"
		foreground = "#C4C7C5"
		frame_color = "#4DD0E1"

		[urgency_normal]
		timeout = 5
		background = "#212B30"
		foreground = "#C4C7C5"
		frame_color = "#4DD0E1"

		[urgency_critical]
		timeout = 0
		background = "#212B30"
		foreground = "#EC407A"
		frame_color = "#EC407A"
	_EOF_

	pkill dunst && dunst &
}

# xfce terminal ---------------------------------
change_xfterm () {
	sed -i -e "s/FontName=.*/FontName=$1/g" "$terminal_path"/terminalrc
	sed -i -e 's/ColorForeground=.*/ColorForeground=#f1f1fcfcf9f9/g'	"$terminal_path"/terminalrc
	sed -i -e 's/ColorBackground=.*/ColorBackground=#28282f2f3737/g'	"$terminal_path"/terminalrc
	sed -i -e 's/ColorCursor=.*/ColorCursor=#f1f1fcfcf9f9/g' 			"$terminal_path"/terminalrc
	sed -i -e 's/ColorPalette=.*/ColorPalette=#202026262c2c;#dbdb8686baba;#7474dddd9191;#e4e491918686;#7575dbdbe1e1;#b4b4a1a1dbdb;#9e9ee9e9eaea;#f1f1fcfcf9f9;#464654546363;#d0d04e4e9d9d;#4b4bc6c66d6d;#dbdb69695b5b;#3d3dbabac2c2;#82825e5ecece;#6262cdcdcdcd;#e0e0e5e5e5e5/g' "$terminal_path"/terminalrc
}

# geany ---------------------------------
change_geany() {
	sed -i -e "s/color_scheme=.*/color_scheme=$1.conf/g" "$geany_path"/geany.conf
	sed -i -e "s/editor_font=.*/editor_font=$2/g" "$geany_path"/geany.conf
}

# gtk theme, icons and fonts ---------------------------------
change_gtk() {
	xfconf-query -c xfwm4 -p /general/theme -s "${1}"
	xfconf-query -c xsettings -p /Net/ThemeName -s "${2}"
	xfconf-query -c xsettings -p /Net/IconThemeName -s "${3}"
	xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "${4}"
	xfconf-query -c xsettings -p /Gtk/FontName -s "${5}"
}

# notify ---------------------------------
notify_user () {
	local style=`basename $0` 
	notify-send -u normal -i /usr/share/icons/Archcraft/actions/24/channelmixer.svg "Applying Style : ${style%.*}"
}

# run this function in openbox --------------
if_wm_is_openbox_()
{
if [[ ! -z "$(pidof openbox)" ]]; then
	change_rofi 
	obconfig 
	change_dunst 
fi
}

## Execute Script -----------------------
notify_user

# set dunst rofi and openbox if wm is openbox
#if_wm_is_openbox_

# Set Wallpaper
set_wall 'manhattan.jpg'

## Change colors in funct (xfce4-terminal)
change_xfterm 'JetBrainsMono Nerd Font 10'

# SCHEME | FONT
change_geany 'manhattan' 'JetBrains Mono 10'

# WM THEME | THEME | ICON | CURSOR | FONT
change_gtk 'Manhattan' 'Manhattan' 'Luv-Folders-Dark' 'Vimix-dark' 'Noto Sans 9'
