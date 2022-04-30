#var
internet_status_right_now_is="up"

#whiptail var
tty_height_="$(stty -a | tr \; \\012 | egrep 'rows' | cut '-d ' -f3)"
tty_width="$(stty -a | tr \; \\012 | egrep 'columns' | cut '-d ' -f3)"
whiptail_listheight="20"

declare -i we_are_at_stage=0
sudoaptinstall='sudo apt-get install -y'
sudoaptinstall_noninteractive='sudo DEBIAN_FRONTEND=noninteractive apt-get install -y'

foldertempfornow="/tmp/tempfornow"
temp_folder_4_Remote_source_file="$foldertempfornow/core-dajhs7526jdfhjfkgh857fj-core"
temp_folder_for_download="$foldertempfornow/Temp_download_folder"
temp_folder_for_themes_and_apps="$foldertempfornow/Themes_and_apps"
temp_folder_for_usr_bin_="$foldertempfornow/usr_bin_temp_folder_"

config_folder_name=".config"
myshell_folder_name="myshell"
oldshell_folder_name="old_files"

config_skel_folder="$config_folder_name"
myshell_skel_folder="$config_skel_folder/$myshell_folder_name"
oldshell_skel_folder="$myshell_skel_folder/$oldshell_folder_name"

temp_folder_for_skel_="$foldertempfornow/skel_temp_folder_"
temp_folder_for_skel_config="$temp_folder_for_skel_/$config_skel_folder"
temp_folder_for_skel_shell_folder="$temp_folder_for_skel_/$myshell_skel_folder"
temp_folder_for_oldskel_file_shell_folder="$temp_folder_for_skel_/$oldshell_skel_folder"

temp_folder_for_skel_tweakterminalfolder="$temp_folder_for_skel_/$myshell_skel_folder"

temp_folder_for_shell_config="$temp_folder_for_themes_and_apps/shell_config"
temp_folder_for_GNOME="$temp_folder_for_themes_and_apps/GNOME"
temp_folder_for_KDE="$temp_folder_for_themes_and_apps/KDE"
temp_folder_for_preWM="$temp_folder_for_themes_and_apps/preWM"
temp_folder_for_polybar="$temp_folder_for_themes_and_apps/polybar"
temp_folder_for_awesomewm="$temp_folder_for_themes_and_apps/awesomewm"
temp_folder_for_bspwm="$temp_folder_for_themes_and_apps/bspwm"
temp_folder_for_openbox="$temp_folder_for_themes_and_apps/openbox"
temp_folder_for_gaming="$temp_folder_for_download/gaming"

sub_massage_in_running_function_show_it_in_progress_list=""
prev1_sub_massage_in_running_function_show_it_in_progress_list=""
prev2_sub_massage_in_running_function_show_it_in_progress_list=""

folder_to_my_script_linux_log="$foldertempfornow/my_script_linux_log_folder"

info_log=$folder_to_my_script_linux_log/info-log.out.txt
debug_log=$folder_to_my_script_linux_log/debug-log.out.txt
error_log=$folder_to_my_script_linux_log/error-log.out.txt
missing_content_from_preWM_config_files="$folder_to_my_script_linux_log/missing_content_from_preWM_config_files"

temp_full_log_file="$folder_to_my_script_linux_log/installer.out.txt"
final_full_log_file="$HOME/full-logs.out.txt"

helper_list="$foldertempfornow/helper_list.out"

switch_default_sh_now="1"

check_if_unattended_upgrades_is_installed=

#disto stuff
[ -f "/usr/lib/os-release" ] && os_release_location="/usr/lib/os-release"
[ -f "/etc/os-release" ] && os_release_location="/etc/os-release"

DISTRO=$(grep "$os_release_location" -e "^ID=" | grep -Po '^.{3}\K.*')
DISTRO=${DISTRO^}
if [ "$DISTRO" == "Ubuntu" ]
then
	Codename=$(grep "$os_release_location" -e "^UBUNTU_CODENAME=" | grep -Po '^.{16}\K.*' || :)
else
	Codename=$(grep "$os_release_location" -e "^VERSION_CODENAME=" | grep -Po '^.{17}\K.*' || :)
fi
os_id_like=$(grep "$os_release_location" -e "^ID_LIKE=" | grep -Po '^.{8}\K.*' || :)

if [ "$os_id_like" == "Ubuntu" ] || [ "$os_id_like" == *"Ubuntu" ] || [ "$os_id_like" == *"Ubuntu"* ] || [ "$os_id_like" == "Ubuntu"* ]
then
	ubuntu_similar_DISTRO="true"
fi

# test if in virtual machine
if [ "$(hostnamectl | grep "Chassis:" | grep -o "vm")" == "vm" ]
then
	virtual_machine="true"
fi

if [[ "$(cat /sys/class/dmi/id/chassis_type)" == @(8|9|10|14) ]]
then 
	is_this_laptop_="true"
fi

#############################################################################################################################################################################
#############################################################################################################################################################################

if [ -z "$(sudo apt list --installed 2> /dev/null | grep unattended-upgrades)" ]
then
	is_unattended_upgrades_installed_="false"
else
	is_unattended_upgrades_installed_="true"
fi

do_you_want_to_install_essential_apps=""
enable_check_to_install_essential_apps="true"
if [ "$enable_check_to_install_essential_apps" != "true" ]
then
do_you_want_to_install_essential_apps="true"
fi

Gedit_theme_folder="$HOME/.local/share/gedit/styles/"
themesFolder_now="$HOME/.local/share/themes"
themes_icons_Folder_now="$HOME/.local/share/icons"

All_my_Stuff_folder_now="$HOME/.local"
conky_Stuff_folder_now="/$config_skel_folder/conky"
sourseAll_my_Stuff_folder_now='$HOME/.local'
themes_switcher_Folder_now="$All_my_Stuff_folder_now/themes-switcher"

time_and_date_now_=$(date +"%H%M.%d%m%Y.%S")
backup_old_config_file_name_=".config_$time_and_date_now_.backup"
backup_old_config_file_to_="$HOME/$backup_old_config_file_name_"
pimpmyterminalfolder="$HOME/$myshell_skel_folder"
soursepimpmyterminalfolder='$HOME/\$myshell_skel_folder'
soursepimpmyterminalfolder_fullpath="$HOME/$myshell_skel_folder"
temp_folder_for_tweakmyterminal="$HOME/temp_folder_for_tweakmyterminal"

#custom-gdm3
dest="/usr/local/share/gnome-shell/custom-gdm"
color='#456789'
gresource_file_location="/usr/share/gnome-shell/theme/Yaru/gnome-shell-theme.gresource"
#

cleanUpFromScript=""

flatpakinstall='flatpak --user install flathub -y'

if command -v snap &> /dev/null
then
	is_snap_installed="true"
fi

if command -v flatpak &> /dev/null
then
	is_flatpak_installed="true"
fi


#desktop env

if command -v gnome-shell &> /dev/null
then
	gnome_desktop_environment="true"
	do_we_need_to_re_install_gnome_desktop_environment="false"
	do_you_want_to_upgrade_gnome_to_gnome_4_="false"
	gnome_desktop_environment_ver="GNOME_OLD"

	if (( $(gnome-shell --version | cut -d ' ' -f 3 | cut -d . -f 1) >= 4 ))
	then
		gnome_desktop_environment_ver="GNOME_NEW"
	fi

	if [ "$DISTRO" != "Ubuntu" ] && [ "$ubuntu_similar_DISTRO" != "true" ]; then
		dash2dock_OR_ubuntu2dock="dash-to-dock@micxgx.gmail.com"
	else
		dash2dock_OR_ubuntu2dock="ubuntu-dock@ubuntu.com"
	fi
fi

if command -v plasmashell &> /dev/null
then
	kde_desktop_environment="true"
fi

Kde_Display_number_now=":1"

# common.sh var

wallpapers_location_now="/usr/share/my_wallpapers"
gnome_wallpaper_folder="/usr/share/backgrounds"
kde_wallpaper_folder="/usr/share/wallpapers"
nitrogen_wp_default="nord1.png"
replace_nitrogen_wp_default="openbox.png"

# dotcleanup var
is_zsh_default_shell="false"

# tweak my terminal var

if [ $(echo $SHELL) == "/bin/zsh" ]
then
	is_zsh_default_shell="true"
fi

zshrcfilename="zshrc.sh"
bashrcfilename="bashrc.sh"


#GPU
cpu_AMD=$(lscpu | grep "Vendor ID"  | grep -i AMD || echo "" )
cpu_Intel=$(lscpu | grep "Vendor ID"  | grep -i Intel || echo "" )

if [ -z "$cpu_AMD" ]; then
 my_cpu_vendor="intel"
else
 my_cpu_vendor="amd64"
fi


#############################################################################################################################################################################
#############################################################################################################################################################################

GATEWAY__IP__=$(/sbin/ip route | awk '/default/ { print $3 }')


