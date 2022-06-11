#!/usr/bin/env bash

dir="$HOME/.config/polybar_extra"
style="$(cat $dir/style)"
SDIR="$HOME/.local/bin/polybar_extra"
RDIR="$HOME/.config/rofi_extra"

if [ $style == "grayblocks" ] || [ $style == "docky" ] || [ $style == "cuts" ]
then
	symbol_for_themes_=""
else
	symbol_for_themes_="♥"
fi

# Launch Rofi
MENU="$(rofi -no-config -no-lazy-grab -sep "|" -dmenu -i -p '' \
-theme $RDIR/styles.rasi \
<<< "$symbol_for_themes_ amber|$symbol_for_themes_ blue|$symbol_for_themes_ blue-gray|$symbol_for_themes_ brown|$symbol_for_themes_ cyan|$symbol_for_themes_ deep-orange|\
$symbol_for_themes_ deep-purple|$symbol_for_themes_ green|$symbol_for_themes_ gray|$symbol_for_themes_ indigo|$symbol_for_themes_ blue-light|$symbol_for_themes_ green-light|\
$symbol_for_themes_ lime|$symbol_for_themes_ orange|$symbol_for_themes_ pink|$symbol_for_themes_ purple|$symbol_for_themes_ red|$symbol_for_themes_ teal|$symbol_for_themes_ yellow|$symbol_for_themes_ amber-dark|\
$symbol_for_themes_ blue-dark|$symbol_for_themes_ blue-gray-dark|$symbol_for_themes_ brown-dark|$symbol_for_themes_ cyan-dark|$symbol_for_themes_ deep-orange-dark|\
$symbol_for_themes_ deep-purple-dark|$symbol_for_themes_ green-dark|$symbol_for_themes_ gray-dark|$symbol_for_themes_ indigo-dark|$symbol_for_themes_ blue-light-dark|\
$symbol_for_themes_ green-light-dark|$symbol_for_themes_ lime-dark|$symbol_for_themes_ orange-dark|$symbol_for_themes_ pink-dark|$symbol_for_themes_ purple-dark|$symbol_for_themes_ red-dark|$symbol_for_themes_ teal-dark|$symbol_for_themes_ yellow-dark")"
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
