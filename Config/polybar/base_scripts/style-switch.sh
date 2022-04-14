#!/usr/bin/env bash
Theme_name="$1" 
SDIR="$HOME/.config/polybar/base_scripts/$Theme_name"
RDIR="$HOME/.config/polybar/Rofi/$Theme_name"

# Launch Rofi
MENU="$(rofi -no-config -no-lazy-grab -sep "|" -dmenu -i -p '' \
-theme $RDIR/styles.rasi \
<<< " Default| Nord| Gruvbox| Dark| Cherry|")"
            case "$MENU" in
				*Default) "$SDIR"/styles.sh --default ;;
				*Nord) "$SDIR"/styles.sh --nord ;;
				*Gruvbox) "$SDIR"/styles.sh --gruvbox ;;
				*Dark) "$SDIR"/styles.sh --dark ;;
				*Cherry) "$SDIR"/styles.sh --cherry ;;
            esac
