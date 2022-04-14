#!/usr/bin/env bash
Theme_name="$1"
PDIR="$HOME/.config/polybar"
RDIR="$HOME/.config/polybar/Rofi/$Theme_name"

# Launch Rofi
MENU="$(rofi -no-config -no-lazy-grab -sep "|" -dmenu -i -p '' \
-theme $RDIR/styles.rasi \
<<< " forest| grayblocks| hack| material| pwidgets| shades| shapes| Titus")"
echo "${MENU// }" > "$PDIR"/Picked_Theme && "$PDIR"/launch.sh &
