#!/usr/bin/env bash
Theme_name="$1"
SDIR="$HOME/.config/polybar/base_scripts/$Theme_name"
RDIR="$HOME/.config/polybar/Rofi/$Theme_name"

if [ "$Theme_name" == "shapes" ]
then
dash_p=""
symply_of_choices="♥"
fi

if [ "$Theme_name" == "shades" ]
then
dash_p=""
symply_of_choices="♥"
fi


if [ "$Theme_name" == "material" ]
then
dash_p=""
symply_of_choices="♥"
fi


if [ "$Theme_name" == "hack" ]
then
dash_p=""
symply_of_choices="♥"
fi

if [ "$Theme_name" == "grayblocks" ]
then
dash_p=""
symply_of_choices=""
fi

# Launch Rofi
MENU="$(rofi -no-config -no-lazy-grab -sep "|" -dmenu -i -p '$dash_p' \
-theme $RDIR/styles.rasi \
<<< "$symply_of_choices amber|$symply_of_choices blue|$symply_of_choices blue-gray|$symply_of_choices brown|$symply_of_choices cyan|$symply_of_choices deep-orange|\
$symply_of_choices deep-purple|$symply_of_choices green|$symply_of_choices gray|$symply_of_choices indigo|$symply_of_choices blue-light|$symply_of_choices green-light|\
$symply_of_choices lime|$symply_of_choices orange|$symply_of_choices pink|$symply_of_choices purple|$symply_of_choices red|$symply_of_choices teal|$symply_of_choices yellow|$symply_of_choices amber-dark|\
$symply_of_choices blue-dark|$symply_of_choices blue-gray-dark|$symply_of_choices brown-dark|$symply_of_choices cyan-dark|$symply_of_choices deep-orange-dark|\
$symply_of_choices deep-purple-dark|$symply_of_choices green-dark|$symply_of_choices gray-dark|$symply_of_choices indigo-dark|$symply_of_choices blue-light-dark|\
$symply_of_choices green-light-dark|$symply_of_choices lime-dark|$symply_of_choices orange-dark|$symply_of_choices pink-dark|$symply_of_choices purple-dark|$symply_of_choices red-dark|$symply_of_choices teal-dark|$symply_of_choices yellow-dark|")"
            case "$MENU" in
				## Light Colors
				*amber) "$SDIR"/colors-light.sh --amber ;;
				*blue) "$SDIR"/colors-light.sh --blue ;;
				*blue-gray) "$SDIR"/colors-light.sh --blue-gray ;;
				*brown) "$SDIR"/colors-light.sh --brown ;;
				*cyan) "$SDIR"/colors-light.sh --cyan ;;
				*deep-orange) "$SDIR"/colors-light.sh --deep-orange ;;
				*deep-purple) "$SDIR"/colors-light.sh --deep-purple ;;
				*green) "$SDIR"/colors-light.sh --green ;;
				*gray) "$SDIR"/colors-light.sh --gray ;;
				*indigo) "$SDIR"/colors-light.sh --indigo ;;
				*blue-light) "$SDIR"/colors-light.sh --light-blue ;;
				*green-light) "$SDIR"/colors-light.sh --light-green ;;
				*lime) "$SDIR"/colors-light.sh --lime ;;
				*orange) "$SDIR"/colors-light.sh --orange ;;
				*pink) "$SDIR"/colors-light.sh --pink ;;
				*purple) "$SDIR"/colors-light.sh --purple ;;
				*red) "$SDIR"/colors-light.sh --red ;;
				*teal) "$SDIR"/colors-light.sh --teal ;;
				*yellow) "$SDIR"/colors-light.sh --yellow ;;
				## Dark Colors
				*amber-dark) "$SDIR"/colors-dark.sh --amber ;;
				*blue-dark) "$SDIR"/colors-dark.sh --blue ;;
				*blue-gray-dark) "$SDIR"/colors-dark.sh --blue-gray ;;
				*brown-dark) "$SDIR"/colors-dark.sh --brown ;;
				*cyan-dark) "$SDIR"/colors-dark.sh --cyan ;;
				*deep-orange-dark) "$SDIR"/colors-dark.sh --deep-orange ;;
				*deep-purple-dark) "$SDIR"/colors-dark.sh --deep-purple ;;
				*green-dark) "$SDIR"/colors-dark.sh --green ;;
				*gray-dark) "$SDIR"/colors-dark.sh --gray ;;
				*indigo-dark) "$SDIR"/colors-dark.sh --indigo ;;
				*blue-light-dark) "$SDIR"/colors-dark.sh --light-blue ;;
				*green-light-dark) "$SDIR"/colors-dark.sh --light-green ;;
				*lime-dark) "$SDIR"/colors-dark.sh --lime ;;
				*orange-dark) "$SDIR"/colors-dark.sh --orange ;;
				*pink-dark) "$SDIR"/colors-dark.sh --pink ;;
				*purple-dark) "$SDIR"/colors-dark.sh --purple ;;
				*red-dark) "$SDIR"/colors-dark.sh --red ;;
				*teal-dark) "$SDIR"/colors-dark.sh --teal ;;
				*yellow-dark) "$SDIR"/colors-dark.sh --yellow				
            esac
