#!/bin/bash

EXTERNAL="HDMI1"
export DISPLAY=":0"
User_=$(who | grep $DISPLAY | head -1 | cut -f 1 -d ' ')
sleep 1
INTERNAL=$(su $User_ -c "xrandr --current | head -2 | tail -1 | awk '{print $1}'")

INTERNAL_STATUS=$(su $USER -c "xrandr --current | grep $INTERNAL | cut -d \  -f 2")
EXTERNAL_STATUS=$(su $USER -c "xrandr --current | grep $EXTERNAL | cut -d \  -f 2")

if [[ "$EXTERNAL_STATUS" == "disconnected" ]] && [[ "$INTERNAL_STATUS" == "disconnected" ]]; then
	su $User_ -c "/usr/local/bin/hotplug_usr.sh"
fi
