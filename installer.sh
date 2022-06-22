#!/bin/bash
set -e

opt_="$1"

#run debug mode
if [ "$opt_" == "-d" ]
then
	Debugging_mode_status="enabled"
fi

Green_echo_() {
  echo -e $'\033[1;32m'"$*"$'\033[0m'
}

#########################
# functions
#########################
check_for_SUDO()
{
if ! command -v sudo >/dev/null
then
	# Check root
	[ "$(id -u)" -ne 0 ] && { Green_echo_ "sudo not installed, so you must run script as root" 1>&2; }
	Green_echo_ "Install sudo and add user 1000 to sudo group"
	# INFO: SUDO allow users exec commands with root privileges without login as root
	[ "$(find /var/cache/apt/pkgcache.bin -mtime 0 2>/dev/null)" ] || apt update
	apt install -y sudo
	user=$(cat /etc/passwd | cut -f 1,3 -d: | grep :1000$ | cut -f1 -d:)
	[ "$user" ] && adduser "$user" sudo
	sudo apt install -f -y
fi
}

check_before_sourcing_this_file()
{
local sourced_file="$1"
if [ "$sourced_file" == "variables.sh" ]
then
	if command -v curl &> /dev/null
	then
		Green_echo_ "sourcing $sourced_file it will take few sec"
		source <(curl -s https://raw.githubusercontent.com/dari862/my-linux-script/main/Myscript-lib/$sourced_file)
	else
		Green_echo_ "sourcing $sourced_file it will take few sec"
		source <(wget -q -O - https://raw.githubusercontent.com/dari862/my-linux-script/main/Myscript-lib/$sourced_file)
		Green_echo_ "installing curl please wait"
		sudo apt-get update && sudo -v && $sudoaptinstall curl && sudo -v
	fi
	mkdir -p $temp_folder_4_Remote_source_file
elif test -f "$temp_folder_4_Remote_source_file/$sourced_file"
then
	Green_echo_ "sourcing $sourced_file" && source $temp_folder_4_Remote_source_file/$sourced_file;
else
	Green_echo_ "sourcing $sourced_file it will take few sec"
	curl -s https://raw.githubusercontent.com/dari862/my-linux-script/main/Myscript-lib/$sourced_file > $temp_folder_4_Remote_source_file/$sourced_file && source $temp_folder_4_Remote_source_file/$sourced_file
fi
}

installer__()
{
#########################

	trap if_error_exit_with_this_function_now EXIT # exist with this function if script failed

	keep_Sudo_refresed &
	pre_script_now_now

	show_main_menu_now

#########################

	create_Stages_array_to_show_progress_menu # sourced from menu_and_installer.sh

#########################

	main_installer_now || if_error_exit_with_this_function_now EXIT
}

debugger__()
{
#########################

	keep_Sudo_refresed &
	pre_script_now_now

#########################

	create_Stages_array_to_show_progress_menu # sourced from menu_and_installer.sh

#########################
set_debugging_Sourcing_Remote_Files_now
show_wm "sourcing remotely source files."
show_mf "sourcing remotely source files."
Sourcing_Remote_Files_now
pre_script_now_now
run_part_of_script_that_needs_debugging_now || if_error_exit_with_this_function_now
}

run_part_of_script_that_needs_debugging_now()
{
###############################################################################

	pre_show_app_menu_now
	show_app_menu_now

###############################################################################
	show_mf "Done3"
	show_m "Done3"
}

main()
{
	### Fix broken packages for good measure (why not?)
	sudo apt install -f -y || check_for_SUDO
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
		installer__
	else
		debugger__
	fi
}

main
