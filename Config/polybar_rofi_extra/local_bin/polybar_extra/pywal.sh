#!/usr/bin/env bash

# Color files

#polybar
PEdir="$HOME/.config/polybar_extra"
Style="$(cat ${PEdir}/style)"
PFILE="$PEdir/$Style/colors.ini"

#rofi
REdir="$HOME/.config/rofi_extra"
RFILE="$REdir/$Style/scripts/rofi/colors.rasi"

# Get colors
pywal_get() {
	wal -i "$1" -q -t
}

# Change colors
change_color() {
	if [ "$Style" == "shapes" ] || [ "$Style" == "colorblocks" ] || [ "$Style" == "shades" ]
	then
		# polybar
		sed -i -e "s/background = #.*/background = $BG/g" $PFILE
		sed -i -e "s/foreground = #.*/foreground = $FG/g" $PFILE
		sed -i -e "s/foreground-alt = #.*/foreground-alt = $FGA/g" $PFILE
		sed -i -e "s/shade1 = #.*/shade1 = $SH1/g" $PFILE
		sed -i -e "s/shade2 = #.*/shade2 = $SH2/g" $PFILE
		sed -i -e "s/shade3 = #.*/shade3 = $SH3/g" $PFILE
		sed -i -e "s/shade4 = #.*/shade4 = $SH4/g" $PFILE
		sed -i -e "s/shade5 = #.*/shade5 = $SH5/g" $PFILE
		sed -i -e "s/shade6 = #.*/shade6 = $SH6/g" $PFILE
		sed -i -e "s/shade7 = #.*/shade7 = $SH7/g" $PFILE
		sed -i -e "s/shade8 = #.*/shade8 = $SH8/g" $PFILE
	elif [ "$Style" == "pwidgets" ]; then
		sed -i -e "s/bg = #.*/bg = ${BG}/g" $PFILE
		sed -i -e "s/fg = #.*/fg = ${FG}/g" $PFILE
		sed -i -e "s/fga = #.*/fga = ${RFG}/g" $PFILE
		sed -i -e "s/ac = #.*/ac = ${AC}/g" $PFILE
	elif [ "$Style" == "docky" ] || [ "$Style" == "material" ]; then
		sed -i -e "s/background = #.*/background = $BG/g" $PFILE
		sed -i -e "s/foreground = #.*/foreground = $FG/g" $PFILE
		sed -i -e "s/foreground-alt = #.*/foreground-alt = $FGA/g" $PFILE
		sed -i -e "s/module-fg = #.*/module-fg = $MF/g" $PFILE
		sed -i -e "s/primary = #.*/primary = $AC/g" $PFILE
		sed -i -e "s/secondary = #.*/secondary = $SC/g" $PFILE
		sed -i -e "s/alternate = #.*/alternate = $AL/g" $PFILE
	elif [ "$Style" == "cuts" ]; then
		sed -i -e "s/background = #.*/background = ${BG}/g" $PFILE
		sed -i -e "s/background-alt = #.*/background-alt = #8C${BG:1}/g" $PFILE
		sed -i -e "s/foreground = #.*/foreground = ${FG}/g" $PFILE
		sed -i -e "s/foreground-alt = #.*/foreground-alt = #33${FG:1}/g" $PFILE
		sed -i -e "s/primary = #.*/primary = $AC/g" $PFILE
	elif [ "$Style" == "hack" ]; then
		sed -i -e "s/background = #.*/background = $BG/g" $PFILE
		sed -i -e "s/foreground = #.*/foreground = $FG/g" $PFILE
		sed -i -e "s/primary = #.*/primary = $AC/g" $PFILE
	elif [ "$Style" == "grayblocks" ] || [ "$Style" == "blocks" ]; then
		sed -i -e "s/background = #.*/background = $BG/g" $PFILE
		sed -i -e "s/background-alt = #.*/background-alt = $BGA/g" $PFILE
		sed -i -e "s/foreground = #.*/foreground = $FG/g" $PFILE
		sed -i -e "s/foreground-alt = #.*/foreground-alt = $FGA/g" $PFILE
		sed -i -e "s/primary = #.*/primary = $AC/g" $PFILE
		sed -i -e 's/red = #.*/red = #B71C1C/g' $PFILE
		sed -i -e 's/yellow = #.*/yellow = #F57F17/g' $PFILE
	elif [ "$Style" == "forest" ]; then
		sed -i -e "s/background = #.*/background = $BG/g" $PFILE
		sed -i -e "s/foreground = #.*/foreground = $FG/g" $PFILE
		sed -i -e "s/sep = #.*/sep = $AC/g" $PFILE
	fi
	
	# rofi
	sed -i -e "s/al:.*/al:    #00000000;/g" $RFILE
	sed -i -e "s/bg:.*/bg:    ${BG}FF;/g" $RFILE
	sed -i -e "s/ac:.*/ac:   ${AC}FF;/g" $RFILE
	sed -i -e "s/fg:.*/fg:    ${FG}FF;/g" $RFILE
	if [ "$Style" == "shapes" ] || [ "$Style" == "shades" ]; then
		sed -i -e "s/bg1:.*/bg1:   ${SH2}FF;/g" $RFILE
		sed -i -e "s/bg2:.*/bg2:   ${SH3}FF;/g" $RFILE
		sed -i -e "s/bg3:.*/bg3:   ${SH4}FF;/g" $RFILE
		sed -i -e "s/bg4:.*/bg4:   ${SH5}FF;/g" $RFILE
	elif [ "$Style" == "colorblocks" ]; then
		sed -i -e "s/bg1:.*/bg1:   ${SH8}FF;/g" $RFILE
		sed -i -e "s/bg2:.*/bg2:   ${SH7}FF;/g" $RFILE
		sed -i -e "s/bg3:.*/bg3:   ${SH6}FF;/g" $RFILE
		sed -i -e "s/fg:.*/fg:    ${FGA}FF;/g" $RFILE
	elif [ "$Style" == "pwidgets" ]; then
		sed -i -e "s/fg:.*/fg:   ${RFG}FF;/g" $RFILE
	elif [ "$Style" == "docky" ] || [ "$Style" == "material" ]; then
		sed -i -e "s/bga:.*/bga:   ${AC}33;/g" $RFILE
		sed -i -e "s/bar:.*/bar:    ${MF}FF;/g" $RFILE
	elif [ "$Style" == "cuts" ]; then
		sed -i -e "s/bg:.*/bg:   ${BG}BF;/g" $RFILE
		sed -i -e "s/bga:.*/bga:  ${BG}FF;/g" $RFILE
		sed -i -e "s/se:.*/se:   ${AC}1A;/g" $RFILE
	elif [ "$Style" == "hack" ]; then
		sed -i -e "s/se:.*/se:   ${AC}26;/g" $RFILE
	elif [ "$Style" == "grayblocks" ]; then
		sed -i -e "s/bga:.*/bga:  ${BGA}FF;/g" $RFILE
		sed -i -e "s/fga:.*/fga:  ${FGA}FF;/g" $RFILE
	elif [ "$Style" == "blocks" ]; then
		sed -i -e "s/bga:.*/bga:  ${BGA}FF;/g" $RFILE
		sed -i -e "s/fga:.*/fga:  ${FGA}FF;/g" $RFILE
		sed -i -e "s/se:.*/se:   ${AC}40;/g" $RFILE
	elif [ "$Style" == "forest" ]; then
		sed -i -e "s/bga:.*/bga:  ${BGA}FF;/g" $RFILE
		sed -i -e "s/se:.*/se:   ${AC}FF;/g" $RFILE
	fi
	
	polybar-msg cmd restart
}

hex_to_rgb() {
    # Convert a hex value WITHOUT the hashtag (#)
    R=$(printf "%d" 0x${1:0:2})
    G=$(printf "%d" 0x${1:2:2})
    B=$(printf "%d" 0x${1:4:2})
}

get_fg_color(){
    INTENSITY=$(calc "$R*0.299 + $G*0.587 + $B*0.114")
    
    if [ $(echo "$INTENSITY>186" | bc) -eq 1 ]; then
        MF="#202020"
    else
        MF="#F5F5F5"
    fi
}

# Main
if [[ -f "/usr/bin/wal" ]]; then
	if [[ "$1" ]]; then
		pywal_get "$1"

		# Source the pywal color file
		. "$HOME/.cache/wal/colors.sh"

		BG=`printf "%s\n" "$background"`
		if [ "$Style" == "colorblocks" ]; then
			FG=`printf "%s\n" "$color0"`
		elif [ "$Style" == "grayblocks" ]; then
			FG=`printf "%s\n" "$background"`
		else
			FG=`printf "%s\n" "$foreground"`
		fi
		
		RFG=`printf "%s\n" "$color8"`
		AC=`printf "%s\n" "$color1"`  
		SC=`printf "%s\n" "$color2"` 
		AL=`printf "%s\n" "$color3"`
		BGA=`printf "%s\n" "$color7"`
		SH1=`printf "%s\n" "$color1"`
		SH2=`printf "%s\n" "$color2"`
		SH3=`printf "%s\n" "$color1"`
		SH4=`printf "%s\n" "$color2"`
		SH5=`printf "%s\n" "$color1"`
		SH6=`printf "%s\n" "$color2"`
		SH7=`printf "%s\n" "$color1"`
		if [ "$Style" == "colorblocks" ]; then
			FGA=`printf "%s\n" "$color7"`
			SH8=`printf "%s\n" "$color2"`
		elif [ "$Style" == "shades" ]; then
			FGA=`printf "%s\n" "$color8"`
			SH8=`printf "%s\n" "$color7"`
		elif [ "$Style" == "shapes" ]; then
			FGA=`printf "%s\n" "$foreground"`
			SH8=`printf "%s\n" "$color7"`
		elif [ "$Style" == "grayblocks" ] || [ "$Style" == "blocks" ]; then
			FGA=`printf "%s\n" "$color7"`
		elif [ "$Style" == "docky" ] || [ "$Style" == "material" ]; then
			FGA=`printf "%s\n" "$color8"`
			HEX=${AC:1}
			hex_to_rgb $HEX
			get_fg_color
		fi	

		change_color
	else
		echo -e "[!] Please enter the path to wallpaper. \n"
		echo "Usage : ./pywal.sh path/to/image"
	fi
else
	echo "[!] 'pywal' is not installed."
fi
