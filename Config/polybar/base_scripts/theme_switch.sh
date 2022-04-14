#!/usr/bin/env bash
Theme_name="$1"
PDIR="$HOME/.config/polybar"
RDIR="$HOME/.config/polybar/Rofi/$Theme_name"

# Launch Rofi
MENU="$(rofi -no-config -no-lazy-grab -sep "|" -dmenu -i -p '' \
-theme $RDIR/styles.rasi \
<<< " $(echo $(ls ${PDIR}/Themes/) | sed 's/ /| /g')")"
echo "${MENU// }" > "$PDIR"/Picked_Theme && "$PDIR"/launch.sh &
