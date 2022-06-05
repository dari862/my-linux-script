#!/usr/bin/env bash

WM_common_config="$HOME/.config/WM_common_config"
style="$(cat ${WM_common_config}/Polybar_Extra_style)"
Rdir="$HOME/.config/rofi_extra/$style"


if [ "$style" == "blocks" ]
then
	FILE="$Rdir/colors.rasi"
	
	# random accent color
	COLORS=('#EC7875' '#EC6798' '#BE78D1' '#75A4CD' '#00C7DF' '#00B19F' '#61C766' \
			'#B9C244' '#EBD369' '#EDB83F' '#E57C46' '#AC8476' '#6C77BB' '#6D8895')
	AC="${COLORS[$(( $RANDOM % 14 ))]}"
	sed -i -e "s/ac: .*/ac:   ${AC}FF;/g" $FILE
	sed -i -e "s/se: .*/se:   ${AC}40;/g" $FILE
elif [ "$style" == "forest" ]
then
	#FILE="$Rdir/colors.rasi"
	## random accent color
	#COLORS=('#EC7875' '#EC6798' '#BE78D1' '#75A4CD' '#00C7DF' '#00B19F' '#61C766' \
	#		'#B9C244' '#EBD369' '#EDB83F' '#E57C46' '#AC8476' '#6C77BB' '#6D8895')
	#AC="${COLORS[$(( $RANDOM % 14 ))]}"
	#SE="${COLORS[$(( $RANDOM % 14 ))]}"
	#sed -i -e "s/ac: .*/ac:   ${AC}FF;/g" $FILE
	#sed -i -e "s/se: .*/se:   ${SE}FF;/g" $FILE
	:
fi

rofi -no-config -no-lazy-grab -show drun -modi drun -theme $Rdir/launcher.rasi

