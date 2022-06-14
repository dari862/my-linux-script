#!/bin/bash

Debugging_mode_status="enabled"
if command -v curl &> /dev/null
then
	source <(curl -s https://raw.githubusercontent.com/dari862/my-linux-script/main/installer.sh)
else
	source <(wget -q -O - https://raw.githubusercontent.com/dari862/my-linux-script/main/installer.sh)
fi

set_debugging_Sourcing_Remote_Files_now
show_wm "sourcing remotely source files."
show_mf "sourcing remotely source files."
Sourcing_Remote_Files_now
pre_script_now_now

run_part_of_script_that_needs_debugging_now()
{
###############################################################################

	pre_show_app_menu_now
	show_app_menu_now

###############################################################################
show_mf "Done3"
show_m "Done3"
}
run_part_of_script_that_needs_debugging_now || if_error_exit_with_this_function_now
