#!/bin/bash
set -e

#########################
# functions
#########################
check_for_SUDO()
{
if ! command -v sudo >/dev/null
then
	# Check root
	[ "$(id -u)" -ne 0 ] && { echo "sudo not installed, so you must run script as root" 1>&2; }
	echo "Install sudo and add user 1000 to sudo group"
	# INFO: SUDO allow users exec commands with root privileges without login as root
	[ "$(find /var/cache/apt/pkgcache.bin -mtime 0 2>/dev/null)" ] || apt update
	apt install -y sudo
	user=$(cat /etc/passwd | cut -f 1,3 -d: | grep :1000$ | cut -f1 -d:)
	[ "$user" ] && adduser "$user" sudo
fi
}

check_before_sourcing_this_file()
{
local sourced_file="$1"
if [ "$sourced_file" == "variables.sh" ]
then
	if command -v curl &> /dev/null
	then
		echo "sourcing $sourced_file it will take few sec"
		source <(curl -s https://raw.githubusercontent.com/dari862/my-linux-script/main/Myscript-lib/$sourced_file)
	else
		echo "sourcing $sourced_file it will take few sec"
		source <(wget -q -O - https://raw.githubusercontent.com/dari862/my-linux-script/main/Myscript-lib/$sourced_file)
		echo "installing curl please wait"
		sudo apt-get update && sudo -v && $sudoaptinstall curl && sudo -v
	fi
	mkdir -p $temp_folder_4_Remote_source_file
elif test -f "$temp_folder_4_Remote_source_file/$sourced_file"
then
	echo "sourcing $sourced_file" && source $temp_folder_4_Remote_source_file/$sourced_file;
else
	echo "sourcing $sourced_file it will take few sec"
	curl -s https://raw.githubusercontent.com/dari862/my-linux-script/main/Myscript-lib/$sourced_file > $temp_folder_4_Remote_source_file/$sourced_file && source $temp_folder_4_Remote_source_file/$sourced_file
fi
}
#########################

check_for_SUDO
clear
sudo -v || exit 1

#########################

check_before_sourcing_this_file "variables.sh"
check_before_sourcing_this_file "sourcing_list.sh"
check_before_sourcing_this_file "functions.sh"
check_before_sourcing_this_file "menu_creater_.sh"
check_before_sourcing_this_file "full_installer.sh"

#########################

if [ "$Debugging_mode_status" != "enabled" ]
then
	trap if_error_exit_with_this_function_now EXIT # exist with this function if script failed
fi

keep_Sudo_refresed &
pre_script_now_now

if [ "$Debugging_mode_status" != "enabled" ]
then
	show_main_menu_now
fi

#########################

create_Stages_array_to_show_progress_menu # sourced from menu_and_installer.sh

#########################

if [ "$Debugging_mode_status" != "enabled" ]
then
	main_installer_now || if_error_exit_with_this_function_now EXIT
fi
