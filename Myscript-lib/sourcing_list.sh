var_for_Sourcing_list_of_apps_dot_sh="https://raw.githubusercontent.com/dari862/my-linux-script/main/core/list_of_apps.sh"
var_for_Sourcing_must_install_apps_list_dot_sh="https://raw.githubusercontent.com/dari862/my-linux-script/main/core/must_install_apps_list.sh"
var_for_Sourcing_Out_side_my_repo_dot_sh="https://raw.githubusercontent.com/dari862/my-linux-script/main/core/Out-side-my-repo.sh"
var_for_Sourcing_common_dot_sh="https://raw.githubusercontent.com/dari862/my-linux-script/main/core/common.sh"
var_for_Sourcing_DISTRO_dot_sh="https://raw.githubusercontent.com/dari862/my-linux-script/main/core/DISTRO.sh"
var_for_Sourcing_DE_dot_sh="https://raw.githubusercontent.com/dari862/my-linux-script/main/core/DE.sh"
var_for_Sourcing_uninstall_unwanted_apps_dot_sh="https://raw.githubusercontent.com/dari862/my-linux-script/main/core/uninstall_unwanted_apps.sh"
var_for_Sourcing_install_main_apps_dot_sh="https://raw.githubusercontent.com/dari862/my-linux-script/main/core/install_main_apps.sh"
var_for_Sourcing_install_essential_and_optional_apps_dot_sh="https://raw.githubusercontent.com/dari862/my-linux-script/main/core/install_essential_and_optional_apps.sh"
var_for_Sourcing_tweakMyTerminal_dot_sh="https://raw.githubusercontent.com/dari862/my-linux-script/main/core/tweakMyTerminal.sh"
var_for_Sourcing_WM_dot_sh="https://raw.githubusercontent.com/dari862/my-linux-script/main/core/WM.sh"
var_for_Sourcing_dotfile_cleanup_dot_sh="https://raw.githubusercontent.com/dari862/my-linux-script/main/core/dotfile_cleanup.sh"

#############################################################################################################################################################################
#############################################################################################################################################################################

set_debugging_Sourcing_Remote_Files_now()
{
Sourcing_list_of_apps_dot_sh="$var_for_Sourcing_list_of_apps_dot_sh"
Sourcing_must_install_apps_list_dot_sh="$var_for_Sourcing_must_install_apps_list_dot_sh"
Sourcing_Out_side_my_repo_dot_sh="$var_for_Sourcing_Out_side_my_repo_dot_sh"
Sourcing_common_dot_sh="$var_for_Sourcing_common_dot_sh"
Sourcing_DISTRO_dot_sh="$var_for_Sourcing_DISTRO_dot_sh"
Sourcing_DE_dot_sh="$var_for_Sourcing_DE_dot_sh"
Sourcing_uninstall_unwanted_apps_dot_sh="$var_for_Sourcing_uninstall_unwanted_apps_dot_sh"
Sourcing_install_main_apps_dot_sh="$var_for_Sourcing_install_main_apps_dot_sh"
Sourcing_install_essential_and_optional_apps_dot_sh="$var_for_Sourcing_install_essential_and_optional_apps_dot_sh"
Sourcing_tweakMyTerminal_dot_sh="$var_for_Sourcing_tweakMyTerminal_dot_sh"
Sourcing_WM_dot_sh="$var_for_Sourcing_WM_dot_sh"
Sourcing_dotfile_cleanup_dot_sh="$var_for_Sourcing_dotfile_cleanup_dot_sh"
}

Sourcing_Remote_Files_now()
{
declare -a Remote_source_URL=(
$Sourcing_list_of_apps_dot_sh
$Sourcing_must_install_apps_list_dot_sh
$Sourcing_Out_side_my_repo_dot_sh
$Sourcing_common_dot_sh
$Sourcing_DISTRO_dot_sh
$Sourcing_DE_dot_sh
$Sourcing_uninstall_unwanted_apps_dot_sh
$Sourcing_install_main_apps_dot_sh
$Sourcing_install_essential_and_optional_apps_dot_sh
$Sourcing_tweakMyTerminal_dot_sh
$Sourcing_WM_dot_sh
$Sourcing_dotfile_cleanup_dot_sh
)

for INDEX in ${!Remote_source_URL[*]}; do
Remote_source_File=${Remote_source_URL[$INDEX]##*/};
if test -f "$Remote_source_File"; then
    show_m "sourcing $Remote_source_File" && source $temp_folder_4_Remote_source_file/$Remote_source_File;
else
    curl -s ${Remote_source_URL[$INDEX]} > $temp_folder_4_Remote_source_file/$Remote_source_File;
    show_m "sourcing $Remote_source_File" && source $temp_folder_4_Remote_source_file/$Remote_source_File;
fi
done
}
