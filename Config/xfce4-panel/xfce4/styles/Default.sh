#!/usr/bin/env bash

## Dirs #############################################
terminal_path="$HOME/.config/xfce4/terminal"
geany_path="$HOME/.config/geany"

# wallpaper ---------------------------------
set_wall() {
	nitrogen --save --set-zoom-fill /usr/share/backgrounds/"$1"
}

# xfce terminal ---------------------------------
change_xfterm () {
	sed -i -e "s/FontName=.*/FontName=$1/g" "$terminal_path"/terminalrc
	sed -i -e 's/ColorForeground=.*/ColorForeground=#ababb2b2bfbf/g' 	"$terminal_path"/terminalrc
	sed -i -e 's/ColorBackground=.*/ColorBackground=#1e1e21212828/g' 	"$terminal_path"/terminalrc
	sed -i -e 's/ColorCursor=.*/ColorCursor=#ababb2b2bfbf/g' 			"$terminal_path"/terminalrc
	sed -i -e 's/ColorPalette=.*/ColorPalette=#323236363d3d;#e0e06b6b7474;#9898c3c37979;#e5e5c0c07a7a;#6262aeaeefef;#c7c77878dddd;#5555b6b6c2c2;#ababb2b2bfbf;#505054545b5b;#eaea75757e7e;#a2a2cdcd8383;#efefcaca8484;#6c6cb8b8f9f9;#d2d28282e7e7;#5f5fc0c0cccc;#b5b5bcbcc9c9/g' "$terminal_path"/terminalrc
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

## Execute Script -----------------------
notify_user

# Set Wallpaper
set_wall 'default.jpg'

## Change colors in funct (xfce4-terminal)
change_xfterm 'JetBrainsMono Nerd Font 10'

# SCHEME | FONT
change_geany 'arc' 'JetBrains Mono 10'

# WM THEME | THEME | ICON | CURSOR | FONT
change_gtk 'Arc-Dark' 'Arc-Dark' 'Arc-Circle' 'Qogirr' 'Noto Sans 9'
