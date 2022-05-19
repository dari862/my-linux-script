show_main_menu_now()
{

if [ "$enable_check_to_install_essential_apps" == "true" ]
then
	essential_apps_choose_content=("essential" "install essential apps." "ON")
fi

if [ "$DISTRO" == "Debian" ]
then
	enable_switching_to_debian_bleeding_edge_now=("bleeding" "switch to debian bleeding edge." "OFF")
	enable_adding_backport_to_debian_now=("backport" "enable backport Debian." "OFF")
fi

if [ "$gnome_desktop_environment" == "true" ]
then
	GNOME_choose_content=("GNOME" "GNOME tweaking." "ON")
fi

if [ "$kde_desktop_environment" == "true" ]
then
	KDE_choose_content=("KDE" "KDE tweaking." "ON")
fi

if [ "$is_flatpak_installed" == "true" ]
then
	Flatpak_choose_content=("flatpak" "install flatpak and flatpak apps." "OFF")
fi

declare -a CHOICES_Array_now_=(
"dotfile" "clean up Dotfiles." ON
"DISTRO" "configure $DISTRO." ON
"${enable_switching_to_debian_bleeding_edge_now[@]}"
"${enable_adding_backport_to_debian_now[@]}"
"unwanted" "uninstall unwanted apps." ON
"${essential_apps_choose_content[@]}"
"COMMON" "install and configure common stuff." ON
"Tweakmyterminal" "Tweak my terminal." ON
"${GNOME_choose_content[@]}"
"${KDE_choose_content[@]}"
"awesomeWM" "install awesomeWM and tweak it." OFF
"bspwm" "install bspwm and tweak it." OFF
"openbox" "install openbox and tweak it." OFF
"pen" "install pen and tweak it." OFF
"${Flatpak_choose_content[@]}"
"extra_wallpaper" "Download extra wallpapers." OFF
"grub" "reconfigure grub." OFF
"CLEANUP" "clean up after installtion." ON
)
CHOICES=$(whiptail --separate-output --checklist "Choose options" $(stty size) $whiptail_listheight "${CHOICES_Array_now_[@]}" 3>&1 1>&2 2>&3)

if [ -z "$CHOICES" ]; then
	echo "No option was selected (user hit Cancel or unselected all options)"
else
	for CHOICE in $CHOICES; do
		case "$CHOICE" in
			"essential")
				Sourcing_list_of_apps_dot_sh="$var_for_Sourcing_list_of_apps_dot_sh"
				Sourcing_install_essential_and_optional_apps_dot_sh="$var_for_Sourcing_install_essential_and_optional_apps_dot_sh"
				do_we_need_to_install_essential_apps="installing essential and optinal apps."
				do_you_want_to_install_essential_apps="true"
			;;
			"dotfile")
				Sourcing_dotfile_cleanup_dot_sh="$var_for_Sourcing_dotfile_cleanup_dot_sh"
				do_you_want_to_dotfile_cleanup_now="true"
				do_we_need_to_cleanup_dotfile="dotfile clean-up."
			;;
			"DISTRO")
				Sourcing_DISTRO_dot_sh="$var_for_Sourcing_DISTRO_dot_sh"
				do_you_want_to_configure_Distro_now="true"
				which_distro_are_we_configuring="configuring $DISTRO."
			;;
			"CLEANUP")
				do_you_want_to_cleanup_after_install="true"
				do_we_need_to_cleanup_after_install="clean up time."
			;;
			"COMMON")
				Sourcing_common_dot_sh="$var_for_Sourcing_common_dot_sh"
				do_you_want_to_enable_install_common_stuff="true"
				do_we_need_to_enable_install_common_stuff="install and configure common stuff."
			;;
			"unwanted")
				Sourcing_uninstall_unwanted_apps_dot_sh="$var_for_Sourcing_uninstall_unwanted_apps_dot_sh"
				do_you_want_to_uninstall_unwanted_apps="true"
				do_we_need_to_uninstall_unwanted_apps="uninstall unwanted apps."
			;;
			"Tweakmyterminal")
				Sourcing_tweakMyTerminal_dot_sh="$var_for_Sourcing_tweakMyTerminal_dot_sh"
				do_you_want_to_install_Tweak_my_terminal="true"
				do_we_need_to_install_Tweak_my_terminal="pimp my terminal now."
				do_we_need_to_make_zsh_default_shell="make zsh default shell."
				do_we_need_to_configure_zsh_and_bash="configure zsh and bash."
			;;
			"GNOME")
				Sourcing_DE_dot_sh="$var_for_Sourcing_DE_dot_sh"
				do_you_want_to_configure_GNOME="true"
				do_we_need_to_configure_gnome_now="configure GNOME"
			;;
			"KDE")
				Sourcing_DE_dot_sh="$var_for_Sourcing_DE_dot_sh"
				do_you_want_to_configure_KDE="true"
				do_we_need_to_configure_kde_now="configure KDE"
			;;
			"extra_wallpaper")
				do_you_want_to_download_extra_wallpaper="true"
			;;
			"awesomeWM")
				do_you_want_to_enable_preWM="true"
				do_you_want_to_install_awesomeWM="true"
				do_we_need_to_install_awesomeWM="install and configure awesomeWM"
			;;
			"bspwm")
				do_you_want_to_enable_preWM="true"
				do_you_want_to_install_bspwm="true"
				do_we_need_to_install_bspwm="install and configure bspwm"
			;;
			"openbox")
				do_you_want_to_enable_preWM="true"
				do_you_want_to_install_openbox="true"
				do_we_need_to_install_openbox="install and configure openbox"
			;;
			"pen")
				do_you_want_to_install_pen="true"
				do_we_need_to_install_pen="install and configure pen"
			;;
			"flatpak")
				install_flatpak_apps_only_snow="true"
				Sourcing_install_essential_and_optional_apps_dot_sh="$var_for_Sourcing_install_essential_and_optional_apps_dot_sh"
			;;
			"grub")
				do_you_want_to_reconfigure_grub_="true"
				do_we_need_to_install_grub_="reconfigure grub."
			;;
			"bleeding")
				do_you_want_to_switch_to_bleeding_edge_now="true"
				which_distro_are_we_configuring="switch to debian bleeding edge."
			;;
			"backport")
				do_you_want_enable_backport_now="true"
			;;
			*)
				echo "Unsupported item $CHOICE!" >&2
				exit 1
			;;
		esac
	done
fi

if [ "$do_you_want_to_reconfigure_grub_" == "true" ] || [ "$do_you_want_to_install_openbox" == "true" ] || [ "$do_you_want_to_install_bspwm" == "true" ]
then
	show_sub_menu_now
fi

if [ "$do_you_want_to_configure_GNOME" == "true" ] && [ "$gnome_desktop_environment_ver" == "GNOME_OLD" ] && [ "$do_you_want_to_switch_to_bleeding_edge_now" != "true" ] 
then
#	if (whiptail --title "GNOME" --yesno "Do you want to upgrade to GNOME 4 ?" $(stty size))
#	then
#		do_you_want_to_upgrade_gnome_to_gnome_4_="true"
#	fi
echo "test"
fi

if [ "$do_you_want_to_enable_preWM" == "true" ]
then
	Sourcing_WM_dot_sh="$var_for_Sourcing_WM_dot_sh"
	do_we_need_to_enable_preWM="install and configure preWM"
fi

if [ "$do_you_want_to_install_essential_apps" == "true" ]
then
	source_this_url "$Sourcing_list_of_apps_dot_sh"
	source_this_url "$Sourcing_install_essential_and_optional_apps_dot_sh"
	pre_show_app_menu_now
	show_app_menu_now
fi

if ((${#gaming_Array[*]})) || ((${#drivers_Array[*]}))
then
	Sourcing_DISTRO_dot_sh="$var_for_Sourcing_DISTRO_dot_sh"
	do_you_want_to_configure_Distro_now="true"
	which_distro_are_we_configuring="configuring $DISTRO."
fi

Sourcing_must_install_apps_list_dot_sh="$var_for_Sourcing_must_install_apps_list_dot_sh"
Sourcing_Out_side_my_repo_dot_sh="$var_for_Sourcing_Out_side_my_repo_dot_sh"
Sourcing_gpu_dot_sh="$var_for_Sourcing_gpu_dot_sh"
Sourcing_install_main_apps_dot_sh="$var_for_Sourcing_install_main_apps_dot_sh"
}


###########################################################################################################################################################################
###########################################################################################################################################################################
# submenu
###########################################################################################################################################################################
###########################################################################################################################################################################

show_sub_menu_now()
{

if [ "$do_you_want_to_install_openbox" == "true" ] || [ "$do_you_want_to_install_bspwm" == "true" ]
then
	declare -a Panel_CHOICES_Array_now_=(
	"polybar" "install polybar." ON
	"xfce4" "install xfce4-panel." OFF
	)
fi

if [ "$do_you_want_to_reconfigure_grub_" == "true" ]
then
	declare -a Grub_CHOICES_Array_now_=(
	"Protectgrub" "do you want to Protect grub menu." ON
	"Skipgrub" "do you want to skip grub menu." ON
	)
fi
declare -a SUBMenu_CHOICES_Array_now_=(
"${Panel_CHOICES_Array_now_[@]}" "${Grub_CHOICES_Array_now_[@]}"
)

CHOICES=$(whiptail --separate-output --checklist "Choose options" $(stty size) $whiptail_listheight "${SUBMenu_CHOICES_Array_now_[@]}" 3>&1 1>&2 2>&3)

if [ -z "$CHOICES" ]; then
	echo "No option was selected (user hit Cancel or unselected all options)"
else
	for CHOICE in $CHOICES; do
		case "$CHOICE" in
			"xfce4")
				do_you_want_to_install_xfce4_panel="true"
			;;
			"polybar")
				do_you_want_to_install_polybar_panel="true"
			;;
			"Protectgrub")
				do_you_want_to_Protect_grub="true"
			;;
			"Skipgrub")
				do_you_want_to_skip_grub="true"
			;;
			*)
				echo "Unsupported item $CHOICE!" >&2
				exit 1
			;;
		esac
	done
fi

if [ "$do_you_want_to_Protect_grub" == "true" ]
then
	new_GRUB_password___pbkdf2_pass=$(temp_password_creater__)
fi

if [ "$new_GRUB_password___pbkdf2_pass" == "" ]
then
	do_you_want_to_Protect_grub="false"
fi

}


###########################################################################################################################################################################
###########################################################################################################################################################################
			
create_Stages_array_to_show_progress_menu()
{
Stages_list=(
"Pre Scripting."
"$do_we_need_to_cleanup_dotfile"
"$which_distro_are_we_configuring"
"$do_we_need_to_uninstall_unwanted_apps"
"installing main apps."
"$do_we_need_to_install_essential_apps"
"$do_we_need_to_install_pen"
"$do_we_need_to_install_grub_"
"$do_we_need_to_enable_install_common_stuff"
"upgrading your system."
"$do_we_need_to_configure_zsh_and_bash"
"$do_we_need_to_make_zsh_default_shell"
"$do_we_need_to_configure_gnome_now"
"$do_we_need_to_configure_kde_now"
"$do_we_need_to_enable_preWM"
"$do_we_need_to_install_awesomeWM"
"$do_we_need_to_install_bspwm"
"$do_we_need_to_install_openbox"
"$do_we_need_to_cleanup_after_install"
)

if  [ "$install_optional_apps_status_now" = "true" ] || [ "$Tweak_my_terminal_status_now" = "true" ] || [ "$install_awesomeWM_and_tweak_status_now" = "true" ] || [ "$install_bspwm_and_tweak_status_now" = "true" ]
then
	add_installed_apps_helper_list_now
fi
}
