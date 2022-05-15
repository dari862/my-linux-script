#!/usr/bin/env bash

rofi_dir="$HOME/.config/rofi"
styles_script_dir="$HOME/.config/My_styles"
default_panel="polybar"
default_style="old"


case "$1" in
	which_panel) 
		if [ $(command -v polybar) ] && [ $(command -v xfce4-panel) ]
		then	
			# Launch Rofi
			which_panel_MENU="$(rofi -no-config -no-lazy-grab -sep "|" -dmenu -i -p '' -no-click-to-exit \
			-theme "$rofi_dir"/old/launcher.rasi \
			<<< "polybar|xfce4-panel")"
			if [ ! -z "$which_panel_MENU" ]
			then
				echo "$which_panel_MENU" > ~/.config/openbox/which_panel
        	else
        		echo "$default_panel" > ~/.config/openbox/which_panel
			fi
		else
			if command -v polybar &> /dev/null
			then
				echo "polybar" > ~/.config/openbox/which_panel
			fi
			
			if command -v xfce4-panel &> /dev/null
			then
				echo "xfce4" > ~/.config/openbox/which_panel
			fi
		fi
	;;
	style)
		list_styles="$(ls -p $styles_script_dir | sed "s/.sh/|/g" | tr -d "\n" | sed 's/.$//')"
		# Launch Rofi
		style_MENU="$(rofi -no-config -no-lazy-grab -sep "|" -dmenu -i -p '' -no-click-to-exit \
		-theme "$rofi_dir"/old/launcher.rasi \
		<<< "$list_styles")"
		if [ ! -z "$style_MENU" ]
		then
        		$styles_script_dir/${style_MENU}.sh
        	else
        		$styles_script_dir/${default_style}.sh
		fi
	;;
esac
