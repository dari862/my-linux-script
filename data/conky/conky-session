#!/bin/bash
#===================================================================================
# FILE: conky-session
# DESCRIPTION: manage conky processes for start, restart and stop all conky instances
# AUTHOR: Leonardo Marco
# VERSION: 1.0
# CREATED: 2020.04.09
# LICENSE: GNU General Public License v3.0
#===================================================================================

conkys_path="$HOME/.config/conky/"
conky_theme_now=$(cat $HOME/.conky/conky_theme.conky)

#=== FUNCTION ======================================================================
# NAME: stop
# DESCRIPTION: stop all conky process
#===================================================================================
function stop() {
	if [ "$(pidof conky)" ]; then
		killall conky
		killall -9 conky
	fi
}


#=== FUNCTION ======================================================================
# NAME: start
# DESCRIPTION: load conkyrc2core file in user conky path based on conky_theme_now var
#===================================================================================
function start() {
  sleep 10
  conky -c ~/.conky/$conky_theme_now/conkyrc2core
}


# EXEC ACTION ACCORDING $1
case "${1,,}" in
	""|start|restart)
		stop
		start		
	;;
	stop)	
		stop	
	;;
	*)	
		echo "Usage: conky-session [start|stop|restart]"
	;;
esac
