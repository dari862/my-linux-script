#!/usr/bin/env bash

dir="$HOME/.config/polybar_extra"
style="$(cat $dir/style)"
SDIR="$HOME/.local/bin/polybar_extra"
RDIR="$HOME/.config/rofi_extra"

# Launch Rofi
if [ "$style" == "blocks" ]
then
	MENU="$(rofi -no-config -no-lazy-grab -sep "|" -dmenu -i -p '' \
	-theme $RDIR/$style/styles.rasi \
	<<< " Default| Nord| Gruvbox| Adapta| Cherry|")"
				case "$MENU" in
					*Default) "$SDIR"/styles.sh --default ;;
					*Nord) "$SDIR"/styles.sh --nord ;;
					*Gruvbox) "$SDIR"/styles.sh --gruvbox ;;
					*Adapta) "$SDIR"/styles.sh --adapta ;;
					*Cherry) "$SDIR"/styles.sh --cherry ;;
				esac
elif [ "$style" == "forest" ]
then
	MENU="$(rofi -no-config -no-lazy-grab -sep "|" -dmenu -i -p '' \
	-theme $RDIR/$style/styles.rasi \
	<<< " Default| Nord| Gruvbox| Dark| Cherry|")"
				case "$MENU" in
					*Default) "$SDIR"/styles.sh --default ;;
					*Nord) "$SDIR"/styles.sh --nord ;;
					*Gruvbox) "$SDIR"/styles.sh --gruvbox ;;
					*Dark) "$SDIR"/styles.sh --dark ;;
					*Cherry) "$SDIR"/styles.sh --cherry ;;
				esac
elif [ "$style" == "cuts" ]
then
	MENU="$(rofi -no-config -no-lazy-grab -sep "|" -dmenu -i -p '' \
	-theme $RDIR/$style/styles.rasi \
	<<< " Black| Adapta| Dark| Red| Green| Teal| Gruvbox| Nord| Solarized| Cherry|")"
				case "$MENU" in
					*Black) "$SDIR"/styles.sh --mode1 ;;
					*Adapta) "$SDIR"/styles.sh --mode2 ;;
					*Dark) "$SDIR"/styles.sh --mode3 ;;
					*Red) "$SDIR"/styles.sh --mode4 ;;
					*Green) "$SDIR"/styles.sh --mode5 ;;
					*Teal) "$SDIR"/styles.sh --mode6 ;;
					*Gruvbox) "$SDIR"/styles.sh --mode7 ;;
					*Nord) "$SDIR"/styles.sh --mode8 ;;
					*Solarized) "$SDIR"/styles.sh --mode9 ;;
					*Cherry) "$SDIR"/styles.sh --mode10 ;;
				esac
elif [ "$style" == "panels" ]
then
	Theme_name_folder="$HOME/.local/bin/polybar_extra/panels"
	theme="$(cat ${Theme_name_folder}/panel )"
	RDIR="$HOME/.config/rofi_extra"

	# Launch Rofi
	MENU="$(rofi -no-config -no-lazy-grab -sep "|" -dmenu -i -p '' \
	-theme $RDIR/panels/$theme/styles.rasi \
	<<< " Budgie| Deepin| Elementary| Elementary_Dark| Gnome| KDE|\
	 KDE_Dark| Liri| Mint| Ubuntu_gnome| Ubuntu_unity| Xubuntu| Zorin|")"
				case "$MENU" in
					*Budgie) "$SDIR"/styles.sh --budgie ;;
					*Deepin) "$SDIR"/styles.sh --deepin ;;
					*Elementary) "$SDIR"/styles.sh --elight ;;
					*Elementary_Dark) "$SDIR"/styles.sh --edark ;;
					*Gnome) "$SDIR"/styles.sh --gnome ;;
					*KDE) "$SDIR"/styles.sh --klight ;;
					*KDE_Dark) "$SDIR"/styles.sh --kdark ;;
					*Liri) "$SDIR"/styles.sh --liri ;;
					*Mint) "$SDIR"/styles.sh --mint ;;
					*Ubuntu_gnome) "$SDIR"/styles.sh --ugnome ;;
					*Ubuntu_unity) "$SDIR"/styles.sh --unity ;;
					*Xubuntu) "$SDIR"/styles.sh --xubuntu ;;
					*Zorin) "$SDIR"/styles.sh --zorin ;;
				esac
elif [ "$style" == "pwidgets" ]
then
	MENU="$(rofi -no-config -no-lazy-grab -sep "|" -dmenu -i -p '' \
	-theme $RDIR/$style/styles.rasi \
	<<< " Default| Nord| Gruvbox| Dark| Cherry| White| Black|")"
				case "$MENU" in
					*Default) "$SDIR"/styles.sh --default ;;
					*Nord) "$SDIR"/styles.sh --nord ;;
					*Gruvbox) "$SDIR"/styles.sh --gruvbox ;;
					*Dark) "$SDIR"/styles.sh --dark ;;
					*Cherry) "$SDIR"/styles.sh --cherry ;;
					*White) "$SDIR"/styles.sh --white ;;
					*Black) "$SDIR"/styles.sh --black ;;
				esac
elif [ "$style" == "shapes" ]
then
	FILE="$HOME/.config/polybar_extra/shapes/glyphs.ini"

	# Replace Glyphs
	change_style() {
		sed -i -e "s/gleft = .*/gleft = $1/g" $FILE
		sed -i -e "s/gright = .*/gright = $2/g" $FILE

		polybar-msg cmd restart
	}


	# Launch Rofi
	MENU="$(rofi -no-config -no-lazy-grab -sep "|" -dmenu -i -p '' \
	-theme $HOME/.config/rofi_extra/shapes/styles.rasi \
	<<< "♥ Style-1|♥ Style-2|♥ Style-3|♥ Style-4|♥ Style-5|♥ Style-6|♥ Style-7|♥ Style-8|♥ Style-9|♥ Style-10|♥ Style-11|♥ Style-12|")"
				case "$MENU" in
					## Light Colors
					*Style-1) change_style   ;;
					*Style-2) change_style   ;;
					*Style-3) change_style   ;;
					*Style-4) change_style   ;;
					*Style-5) change_style   ;;
					*Style-6) change_style   ;;
					*Style-7) change_style   ;;
					*Style-8) change_style   ;;
					*Style-9) change_style   ;;
					*Style-10) change_style   ;;
					*Style-11) change_style   ;;
					*Style-12) change_style   ;;
				esac
else
	echo "somthing wrong"
fi
