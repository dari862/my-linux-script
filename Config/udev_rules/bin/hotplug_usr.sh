#!/bin/bash

if [ "$(ls -A ~/.screenlayout)" ] 
then
	"$(ls ~/.screenlayout/*.sh | head -1)"	
elif [ "$(ls -A ~/.local/screenlayout)" ]
then
	case "$(xrandr -q | grep "connected" | awk '/ connected/ {print $1}' | wc -l)" in
		1) ~/.local/screenlayout/singale.sh ;;
		2) ~/.local/screenlayout/multi-monitor.sh ;;
		*) ~/.local/screenlayout/multi-monitor.sh ;;
	esac
else
	~/.local/bin/hub displayselect auto
fi
