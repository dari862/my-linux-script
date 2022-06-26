#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

## Dynamic Wallpaper : Set wallpapers according to current time.
## Created to work better with job schedulers (cron)

#[ "$(id -u)" -eq 0 ] && { echo "never run script as root. existing.."; exit 1 ;}

SETTER=""
folder_2_convert_2_Dywall=""

## ANSI Colors (FG & BG)
RED="$(printf '\033[31m')"  GREEN="$(printf '\033[32m')"  ORANGE="$(printf '\033[33m')"  BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"  CYAN="$(printf '\033[36m')"  WHITE="$(printf '\033[37m')" BLACK="$(printf '\033[30m')"
REDBG="$(printf '\033[41m')"  GREENBG="$(printf '\033[42m')"  ORANGEBG="$(printf '\033[43m')"  BLUEBG="$(printf '\033[44m')"
MAGENTABG="$(printf '\033[45m')"  CYANBG="$(printf '\033[46m')"  WHITEBG="$(printf '\033[47m')" BLACKBG="$(printf '\033[40m')"

## Wallpaper directory
wallpapers_folder_name="Dynamic_wallpapers"
DIR="/usr/share/${wallpapers_folder_name}"
HOUR=`date +%k`

## Wordsplit in ZSH
set -o shwordsplit 2>/dev/null

## Reset terminal colors
reset_color() {
	tput sgr0   # reset attributes
	tput op     # reset color
    return
}

## Script Termination
exit_on_signal_SIGINT() {
    { printf "${RED}\n\n%s\n\n" "[!] Program Interrupted." 2>&1; reset_color; }
    exit 0
}

exit_on_signal_SIGTERM() {
    { printf "${RED}\n\n%s\n\n" "[!] Program Terminated." 2>&1; reset_color; }
    exit 0
}

trap exit_on_signal_SIGINT SIGINT
trap exit_on_signal_SIGTERM SIGTERM

check_if_installed() {
	dependency=${1-}
	Do_want_to_install_not_installed_apps_are() {
			read -p "Do you want to proceed? (yes/no) " yn
			yn=${yn^^}
			case $yn in 
				YES|Y) sudo apt install -y ${dependency};;
				NO|N) echo exiting...;
					exit;;
				* ) >&2 printf '\033[31;1merror :\033[m %s\n' invalid response;
					Do_want_to_install_not_installed_apps_are;;
			esac
			reset_color
		}
	if ! type -p "$dependency" &>/dev/null;then
		echo -e ${RED}"[!] ERROR: Could not find ${GREEN}'${dependency}'${RED}, is it installed?" >&2
		reset_color
		Do_want_to_install_not_installed_apps_are
	fi
}

## Prerequisite
Prerequisite() { 
    check_if_installed crontab
    ## Choose wallpaper setter
	case "$OSTYPE" in
		linux*)	
				if [ -n "$SWAYSOCK" ]; then
					SETTER="eval ogurictl output '*' --image"
				elif [[ "$DESKTOP_SESSION" =~ ^(MATE|Mate|mate)$ ]]; then
					SETTER="gsettings set org.mate.background picture-filename"
				elif [[ "$DESKTOP_SESSION" =~ ^(Xfce Session|xfce session|XFCE|xfce|Xubuntu|xubuntu)$ ]]; then
					check_if_installed xrandr
					SCREEN="$(xrandr --listactivemonitors | awk -F ' ' 'END {print $1}' | tr -d \:)"
					MONITOR="$(xrandr --listactivemonitors | awk -F ' ' 'END {print $2}' | tr -d \*+)"
					SETTER="xfconf-query --channel xfce4-desktop --property /backdrop/screen$SCREEN/monitor$MONITOR/workspace0/last-image --set"
				elif [[ "$DESKTOP_SESSION" =~ ^(LXDE|Lxde|lxde)$ ]]; then
					SETTER="pcmanfm --set-wallpaper"
				elif [[ "$DESKTOP_SESSION" =~ ^(cinnamon|Cinnamon)$ ]]; then
					SETTER=set_cinnamon
				elif [[ "$DESKTOP_SESSION" =~ ^(/usr/share/xsessions/plasma|NEON|Neon|neon|PLASMA|Plasma|plasma|KDE|Kde|kde)$ ]]; then
					SETTER=set_kde
				elif [[ "$DESKTOP_SESSION" =~ ^(PANTHEON|Pantheon|pantheon|GNOME|Gnome|gnome|Gnome-xorg|gnome-xorg|UBUNTU|Ubuntu|ubuntu|DEEPIN|Deepin|deepin|POP|Pop|pop)$ ]]; then
					SETTER="gsettings set org.gnome.desktop.background picture-uri"
				elif type -p "feh" &>/dev/null;then
					SETTER="feh --bg-fill"
				else 
					check_if_installed xwallpaper
					SETTER="xwallpaper --stretch"
				fi
				;;
	esac
}

## Usage
usage() {
	clear
    cat <<- EOF
		${RED}╺┳┓╻ ╻┏┓╻┏━┓┏┳┓╻┏━╸   ${GREEN}╻ ╻┏━┓╻  ╻  ┏━┓┏━┓┏━┓┏━╸┏━┓
		${RED} ┃┃┗┳┛┃┗┫┣━┫┃┃┃┃┃     ${GREEN}┃╻┃┣━┫┃  ┃  ┣━┛┣━┫┣━┛┣╸ ┣┳┛
		${RED}╺┻┛ ╹ ╹ ╹╹ ╹╹ ╹╹┗━╸   ${GREEN}┗┻┛╹ ╹┗━╸┗━╸╹  ╹ ╹╹  ┗━╸╹┗╸${WHITE}
		
		Dwall V2.0   : Set wallpapers according to current time.
		Developed By : Aditya Shakya (@adi1090x)
			
		Usage : `basename $0` [-h] [-p] [-s style]

		Options:
		   -h	Show this help message
		   -p	Use pywal to set wallpaper
		   -s	Name of the style to apply
		   
	EOF

	styles=(`ls $DIR`)
	printf ${GREEN}"Available styles:  "
	printf -- ${ORANGE}'%s  ' "${styles[@]}"
	printf -- '\n\n'${WHITE}

    cat <<- EOF
		Examples: 
		`basename $0` -s beach        Set wallpaper from 'beach' style
		`basename $0` -p -s sahara    Set wallpaper from 'sahara' style using pywal
		
	EOF
}

## Set wallpaper in kde
set_kde() {
	qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
		var allDesktops = desktops();
		print (allDesktops);
		for (i=0;i<allDesktops.length;i++) {
			d = allDesktops[i];
			d.wallpaperPlugin = 'org.kde.image';
			d.currentConfigGroup = Array('Wallpaper',
										'org.kde.image',
										'General');
			d.writeConfig('Image', 'file://"$1"')
		}"
}

## Set wallpaper in cinnamon
set_cinnamon() {
	 gsettings set org.cinnamon.desktop.background picture-uri "file:///$1"
}

## Get Image
get_img() {
	image="$DIR/$STYLE/$1"

	# get image format
	if [[ -f "${image}.png" ]]; then
		FORMAT="png"
	elif [[ -f "${image}.jpg" ]]; then
		FORMAT="jpg"
	else
		echo -e ${RED}"[!] Invalid image file, Exiting..."
		{ reset_color; exit 1; }
	fi
}

## Set wallpaper with pywal
pywal_set() {
	get_img "$1"
	if [[ -x `command -v wal` ]]; then
		wal -i "$image.$FORMAT"
	else
		echo -e ${RED}"[!] pywal is not installed on your system, exiting..."
		{ reset_color; exit 1; }
	fi
}

## Wallpaper Setter
set_wallpaper() {
	cfile="$HOME/.cache/dwall_current"
	get_img "$1"

	# set wallpaper with setter
	if [[ -n "$FORMAT" ]]; then
		$SETTER "$image.$FORMAT"
	fi

	# make/update dwall cache file
	if [[ ! -f "$cfile" ]]; then
		touch "$cfile"
		echo "$image.$FORMAT" > "$cfile"
	else
		echo "$image.$FORMAT" > "$cfile"	
	fi
}

## Check valid style
check_style() {
	if [[ "$(ls $DIR/$1 2>/dev/null)" ]]; then
		echo -e ${BLUE}"[*] Using style : ${MAGENTA}$1"
		reset_color
	else
		echo -e ${RED}"[!] Invalid style name : ${GREEN}$1${RED}, exiting..."
		reset_color
		exit 1
	fi
}

## Convert choses folder to Dywall
Convert_current_folder_2_Dywall_now() {
	number_of_files="$(\ls -1 | wc -l || echo 'no files')"
	
	if [ "$number_of_files" == 1 ] || [ "$number_of_files" -gt 23 ]; then
		echo "there are $number_of_files in this folder: $folder_2_convert_2_Dywall"
		return 1
	fi
	
	fullname="$(\ls | tail -1)"
	extension="${fullname##*.}"
		
	if [ "$number_of_files" -lt 9 ]; then
		first_file="$(\ls | head -1)"
		last_file="${fullname}"
		mv ${last_file} 9999
		mv ${first_file} 0_0_0
		if [ "$number_of_files" == 3 ]; then
			mv `\ls | head -2 | tail -1` 13.${extension}
		elif [ "$number_of_files" == 4 ]; then
			mv `\ls | head -2 | tail -1` 13.${extension}
			mv `\ls | head -3 | tail -1` 17.${extension}
		elif [ "$number_of_files" == 5 ]; then
			mv `\ls | head -2 | tail -1` 7.${extension}
			mv `\ls | head -3 | tail -1` 13.${extension}
			mv `\ls | head -4 | tail -1` 17.${extension}
		elif [ "$number_of_files" == 6 ]; then
			mv `\ls | head -2 | tail -1` 7.${extension}
			mv `\ls | head -3 | tail -1` 13.${extension}
			mv `\ls | head -4 | tail -1` 17.${extension}
			mv `\ls | head -5 | tail -1` 19.${extension}
		elif [ "$number_of_files" == 7 ]; then
			mv `\ls | head -2 | tail -1` 7.${extension}
			mv `\ls | head -3 | tail -1` 13.${extension}
			mv `\ls | head -4 | tail -1` 17.${extension}
			mv `\ls | head -5 | tail -1` 19.${extension}
			mv `\ls | head -6 | tail -1` 21.${extension}
		elif [ "$number_of_files" == 8 ]; then
			mv `\ls | head -2 | tail -1` 7.${extension}
			mv `\ls | head -3 | tail -1` 13.${extension}
			mv `\ls | head -4 | tail -1` 17.${extension}
			mv `\ls | head -5 | tail -1` 19.${extension}
			mv `\ls | head -6 | tail -1` 21.${extension}
			mv `\ls | head -7 | tail -1` 4.${extension}
		fi
		
		mv 9999 0.${extension}
		mv 0_0_0 5.${extension}
		[ ! -f 19.${extension} ] && ln -s 0.${extension} 19.${extension}
	fi
	Create_links_for_folders_now
}

Create_links_for_folders_now(){
	fullname_L="$(\ls | tail -1)"
	extension_L="${fullname_L##*.}"
	folders_2_create_links_for=(`\ls | sort -n | tr '\n' ' '`)
	newName_L=1
	for filename_L in ${folders_2_create_links_for[@]}; do
		while [ "$newName_L" -lt 24 ]
		do
			if [ -f "${newName_L}.${extension_L}" ] || [ "$newName_L" -gt 24 ]; then
				break
			fi
				ln -s "$filename_L" "${newName_L}.${extension_L}"
				let newName_L=newName_L+1
		done
		let newName_L=newName_L+1
	done
}

## Install script
install_now_() {
	# Path
	[ -f /usr/local/bin/dwall ] && echo -e ${GREEN}"[*] Already exsist. Execute 'dwall' to Run."${WHITE} & exit
	SCRIPT_ABSOLATE_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/$(basename "${BASH_SOURCE[0]}")"

	## Make dirs
	mkdir_dw() {
		echo -e ${ORANGE}"[*] Installing Dynamic Wallpaper..."${WHITE}
		if [[ -d $DIR ]]; then
			# delete old directory
			sudo rm -rf $DIR
			# create new directory
			sudo mkdir -p $DIR
		else
			# create new directory
			sudo mkdir -p $DIR
		fi
	}

	## Copy files
	copy_files() {
		sudo cp "$SCRIPT_ABSOLATE_PATH" /usr/local/bin/dwall
		# make script executable
		sudo chmod +x /usr/local/bin/dwall
		echo -e ${GREEN}"[*] Installed Successfully. Execute 'dwall' to Run."${WHITE}
	}

	## Install
	mkdir_dw
	copy_files
	Download_wallpapers_now
}

Download_wallpapers_now(){
	check_if_installed git
	mkdir -p /tmp/dynamic_wallpapers
	echo "Download wallpapers for https://github.com/adi1090x/dynamic-wallpaper"
	echo "size wallpaper is 150 MB"
	read -p "Do you want to proceed? (yes/no) " yn
	yn=${yn^^}
	case $yn in 
		YES|Y) 
			echo "Downloading 1-2 urls for wallpapers"
			git clone https://github.com/adi1090x/dynamic-wallpaper			/tmp/dynamic-wallpaper
			mv /tmp/dynamic-wallpaper/images/* /tmp/dynamic_wallpapers 2>/dev/null
		;;
		NO|N) echo "skipping Download...";
		;;
		* ) >&2 printf '\033[31;1merror :\033[m %s\n' invalid response;
			Do_want_to_install_not_installed_apps_are;;
	esac
	
	echo "Download wallpapers for https://github.com/saint-13/Linux_Dynamic_Wallpapers"
	echo "size 2.5 GB"
	read -p "Do you want to proceed? (yes/no) " yn
	yn=${yn^^}
	case $yn in 
		YES|Y) 
			echo "Downloading 2-2 urls for wallpapers"
			git clone https://github.com/saint-13/Linux_Dynamic_Wallpapers	/tmp/Linux_Dynamic_Wallpapers
			cd /tmp/Linux_Dynamic_Wallpapers/Dynamic_Wallpapers
			/bin/rm -f * 2>/dev/null
			cd /tmp/Linux_Dynamic_Wallpapers/Dynamic_Wallpapers/cyberpunk-01
			extension="jpg"
			mv *-10.${extension} cyberpunk-00-0-0.0.${extension}
			mv *-11.${extension} cyberpunk-00-0-0.1.${extension}
			mv *-12.${extension} cyberpunk-00-0-0.2.${extension}
			mv *-13.${extension} cyberpunk-00-0-1.${extension}
			mv *-14.${extension} cyberpunk-00-0-2.${extension}
			mv *-15.${extension} cyberpunk-00-0-3.${extension}
			newName=0
			for filename in *; do
				mv "$filename" "${newName}.${extension}"
				let newName=newName+1
			done
			mv 15.${extension} 21.${extension}
			mv 14.${extension} 19.${extension}
			mv 13.${extension} 18.${extension}
			mv 12.${extension} 17.${extension}
			mv 11.${extension} 15.${extension}
			mv 10.${extension} 13.${extension}
			mv 9.${extension} 12.${extension}
			mv 8.${extension} 11.${extension}
			mv 7.${extension} 10.${extension}
			mv 6.${extension} 9.${extension}
			mv 5.${extension} 8.${extension}
			mv 4.${extension} 7.${extension}
			mv 3.${extension} 6.${extension}
			mv 2.${extension} 5.${extension}
			mv 1.${extension} 3.${extension}
			Create_links_for_folders_now
			
			cd /tmp/Linux_Dynamic_Wallpapers/Dynamic_Wallpapers/Mojave
			extension="jpeg"
			mv *_15.${extension} cmojave_dynamic_0_0_0.${extension}
			mv *_14.${extension} mojave_dynamic_0_0_1.${extension}
			newName=0
			for filename in *; do
				mv "$filename" "${newName}.${extension}"
				let newName=newName+1
			done
			mv 15.${extension} 21.${extension}
			mv 14.${extension} 19.${extension}
			mv 13.${extension} 18.${extension}
			mv 12.${extension} 17.${extension}
			mv 11.${extension} 16.${extension}
			mv 10.${extension} 15.${extension}
			mv 9.${extension} 14.${extension}
			mv 8.${extension} 13.${extension}
			mv 7.${extension} 12.${extension}
			mv 6.${extension} 11.${extension}
			mv 5.${extension} 9.${extension}
			mv 4.${extension} 7.${extension}
			mv 3.${extension} 6.${extension}
			mv 2.${extension} 5.${extension}
			mv 1.${extension} 3.${extension}
			Create_links_for_folders_now
			
			cd /tmp/Linux_Dynamic_Wallpapers/Dynamic_Wallpapers
			mv /tmp/Linux_Dynamic_Wallpapers/Dynamic_Wallpapers/cyberpunk-01 /tmp/dynamic_wallpapers
			mv /tmp/Linux_Dynamic_Wallpapers/Dynamic_Wallpapers/Mojave /tmp/dynamic_wallpapers
			
			extension=""
			folder_2_convert_2_Dywall=""
			d=""
			cd /tmp/Linux_Dynamic_Wallpapers/Dynamic_Wallpapers
			for d in *
			do
				cd /tmp/Linux_Dynamic_Wallpapers/Dynamic_Wallpapers/"${d}"
				newName=0
				fullname="$(\ls | tail -1)"
				extension="${fullname##*.}"
				for filename in *; do
					mv "$filename" "${newName}.${extension}"
					let newName=newName+1
				done
				Convert_current_folder_2_Dywall_now
			done
			
			mv /tmp/Linux_Dynamic_Wallpapers/Dynamic_Wallpapers/* /tmp/dynamic_wallpapers 2>/dev/null
			echo "Downloading complete"
		;;
		NO|N) echo "skipping Download...";
		;;
		* ) >&2 printf '\033[31;1merror :\033[m %s\n' invalid response;
			Do_want_to_install_not_installed_apps_are;;
	esac
	
	if [ ! -d /tmp/Linux_Dynamic_Wallpapers ] && [ ! -d /tmp/dynamic-wallpaper ]; then
		exit 0
	fi
	
	sudo chown -R root:root /tmp/dynamic_wallpapers
	sudo mkdir -p $DIR
	sudo mv /tmp/dynamic_wallpapers/* $DIR
	
	echo "Done"
	exit 0
}

## Uninstall script
uninstall_now_() {
	## Delete files
	rmdir_dw() {
		echo -e ${ORANGE}"[*] Uninstalling Dynamic Wallpaper..."${WHITE}
		if [[ -d $DIR ]]; then
			# delete dwall directory
			sudo rm -rf $DIR
		fi
	}

	del_files() {
		if [[ -f /usr/local/bin/dwall ]]; then
			sudo rm /usr/local/bin/dwall
		fi
		echo -e ${GREEN}"[*] Uninstalled Successfully."${WHITE}
	}

	## Uninstall
	rmdir_dw
	del_files
}

#
create_crontab_now() {
	crontab -r
	(crontab -l 2>/dev/null; echo "0 * * * * env PATH=$PATH DISPLAY=$DISPLAY DESKTOP_SESSION=$DESKTOP_SESSION DBUS_SESSION_BUS_ADDRESS=\"$DBUS_SESSION_BUS_ADDRESS\" /usr/bin/dwall -s $STYLE") | crontab -
}

## Main
main() {
	# get current hour
	num=$(($HOUR/1))
	# set wallpaper accordingly
	if [[ -n "$PYWAL" ]]; then
		pywal_set
	else
		set_wallpaper "$num"
	fi
	
	reset_color
	
	if [ "$create_crontab_" == true ]; then
		create_crontab_now
	fi
	exit 0
}

## Get Options
while getopts ":s:c:ohpiud" opt; do
	case ${opt} in
		p)
			PYWAL=true
			;;
		s)
			STYLE=$OPTARG
			;;
		c)
			folder_2_convert_2_Dywall=$OPTARG
			do_you_want_2_convert_folder_2_Dywall=true
			;;
		h)
			{ usage; reset_color; exit 0; }
			;;
		i)
			Set_installation_=true
			;;
		u)
			Set_uninstall_=true
			;;
		o)
			create_crontab_=true
			;;
		d)
			Download_wallpapers_=true
			;;
		\?)
			echo -e ${RED}"[!] Unknown option, run ${GREEN}`basename $0` -h"
			{ reset_color; exit 1; }
			;;
		:)
			echo -e ${RED}"[!] Invalid:$G -$OPTARG$R requires an argument."
			{ reset_color; exit 1; }
			;;
	esac
done

if [[ "$do_you_want_2_convert_folder_2_Dywall" == true ]]; then
	cd $folder_2_convert_2_Dywall
	Convert_current_folder_2_Dywall_now
	exit 0
fi

if [[ "$Set_installation_" == true ]]; then
	install_now_
	exit 0
fi

if [[ "$Set_uninstall_" == true ]]; then
	uninstall_now_
	exit 0
fi

if [[ "$Download_wallpapers_" == true ]]; then
	Download_wallpapers_now
fi

## Run
Prerequisite
if [[ "$STYLE" ]]; then
	check_style "$STYLE"
	main
else
	{ usage; reset_color; exit 1; }
fi
