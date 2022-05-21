main_installer_now()
{
we_are_at_stage=$(expr $we_are_at_stage + 1)
pre_install_script_now

we_are_at_stage=$(expr $we_are_at_stage + 1)
if [ "$do_you_want_to_dotfile_cleanup_now" == "true" ]
then
dotfile_cleanup_now
fi

we_are_at_stage=$(expr $we_are_at_stage + 1)
if [ "$do_you_want_to_configure_Distro_now" == "true" ]
then
	main_${DISTRO}_now || failed_to_configure_Distro
fi
############################

we_are_at_stage=$(expr $we_are_at_stage + 1)
if [ "$do_you_want_to_uninstall_unwanted_apps" == "true" ]; then
	main_uninstall_unwanted_apps_now
fi

############################

we_are_at_stage=$(expr $we_are_at_stage + 1)

if [ "$do_you_want_to_install_Tweak_my_terminal" == "true" ]; then
	install_main_apps_for_tweak_my_terminal
fi
 
if [ "$do_you_want_to_configure_GNOME" == "true" ]; then
	install_main_apps_for_gnome
fi

if [ "$do_you_want_to_configure_KDE" == "true" ]; then
	install_main_apps_for_kde
fi

if [ "$do_you_want_to_enable_preWM" == "true" ]; then
	install_main_apps_for_preWM
fi

if [ "$do_you_want_to_install_polybar_panel" == "true" ]; then
	install_polybar_app_now_
fi

if command -v polybar &> /dev/null
then
	download_polybar_config_now_
	install_plank_app_now_
fi

if [ "$do_you_want_to_install_xfce4_panel" == "true" ]; then
	install_xfce4_panel_app_now_
fi

if command -v xfce4-panel &> /dev/null
then
	download_xfce4_panel_config_now_
fi

if [ "$do_you_want_to_install_awesomeWM" == "true" ]; then
	install_main_apps_for_awesomewm
fi

if [ "$do_you_want_to_install_bspwm" == "true" ]; then
	install_main_apps_for_bspwm
fi

if [ "$do_you_want_to_install_openbox" == "true" ]; then
	install_main_apps_for_openbox
fi

if [ "$do_you_want_to_install_firmware_app" == "true" ]
then
	install_main_firmware_apps_now
fi

if [ "$install_flatpak_apps_only_snow" == "true" ]; then
	installing_flatpak_apps_now
fi

############################

we_are_at_stage=$(expr $we_are_at_stage + 1)

if [ "$do_you_want_to_install_essential_apps" == "true" ]; then
	full_install_all_picked_apps_now
fi

############################

we_are_at_stage=$(expr $we_are_at_stage + 1)
if [ "$do_you_want_to_install_pen" == "true" ]; then
  main_pen_now
fi

############################

we_are_at_stage=$(expr $we_are_at_stage + 1)
if [ "$do_you_want_to_reconfigure_grub_" == "true" ]; then
  main_Grub_now
fi

############################

we_are_at_stage=$(expr $we_are_at_stage + 1)
# from common.sh
if [ "$do_you_want_to_enable_install_common_stuff" == "true" ]; then
	system_configration_now
	if [ "$do_you_want_to_download_extra_wallpaper" == "true" ]
	then
		wallpaper_download_Now "extra"
	else
		wallpaper_download_Now "main"
	fi
fi

############################

we_are_at_stage=$(expr $we_are_at_stage + 1)
show_m "upgrading your system."
upgrade_my_system_now

############################
# if network manager not installed
# need to install  at end 
# or will lose internet connectivate
# since networkmanager disable
# default network configue 
############################

install_preWM_Network_apps_now

############################################################################################################################################
# from here, there is no need for internet or network connective 
############################################################################################################################################

we_are_at_stage=$(expr $we_are_at_stage + 1)
if [ "$do_you_want_to_install_Tweak_my_terminal" == "true" ]; then
	configure_shell_now
	if [ "$do_you_want_to_make_zsh_default_shell" == "true" ]
	then
		we_are_at_stage=$(expr $we_are_at_stage + 1)
		make_zsh_default_shell
	fi
fi

############################
we_are_at_stage=$(expr $we_are_at_stage + 1)
if [ "$do_you_want_to_configure_GNOME" == "true" ]; then
  main_gnome_now
fi

we_are_at_stage=$(expr $we_are_at_stage + 1)
if [ "$do_you_want_to_configure_KDE" == "true" ]; then
  main_kde_now
fi

we_are_at_stage=$(expr $we_are_at_stage + 1)
if [ "$do_you_want_to_enable_preWM" == "true" ]; then
	main_PreWM_now
fi

we_are_at_stage=$(expr $we_are_at_stage + 1)
if [ "$do_you_want_to_install_awesomeWM" == "true" ]; then
	main_awesomeWM_now
fi

we_are_at_stage=$(expr $we_are_at_stage + 1)
if [ "$do_you_want_to_install_bspwm" == "true" ]; then
	main_bspwm_now
	# fonts-linuxlibertine break polybar 
	# fonts-linuxlibertine installed from libreoffice
	sudo apt-get purge -y fonts-linuxlibertine || show_im "couldn't purge fonts-linuxlibertine"
fi

we_are_at_stage=$(expr $we_are_at_stage + 1)
if [ "$do_you_want_to_install_openbox" == "true" ]; then
	if [ "$do_you_want_to_install_polybar_panel" == "true" ]; then
		configure_polybar_now
	fi
	
	if [ "$do_you_want_to_install_xfce4_panel" == "true" ]; then
		configure_xfce4_now
	fi
	main_openbox_now
fi

############################

mv_Temp_skel_folder_to_etc_skel_folder_now

############################
# from common.sh
if [ "$do_you_want_to_enable_install_common_stuff" == "true" ]; then
	Disable_some_unnecessary_services_now
fi
############################

we_are_at_stage=$(expr $we_are_at_stage + 1)
if [ "$do_you_want_to_cleanup_after_install" == "true" ]; then
	clean_up_now
fi

we_are_at_stage=$(expr $we_are_at_stage + 1)
Done_installing_Massage_now

if [ "$do_you_want_to_reboot" == "true" ]; then
	sudo reboot
fi


}
