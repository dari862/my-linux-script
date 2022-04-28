extract_now()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1 -C $2 ;;
      *.tar.gz)    tar xzf $1 -C $2 ;;
      *.tar.xz)    tar xJf $1 -C $2 ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1 -C $2 ;;
      *.tbz2)      tar xjf $1 -C $2 ;;
      *.tgz)       tar xzf $1 -C $2 ;;
      *.zip)       unzip $1 -d $2 ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

##################################################################################################################################################
# Terminals
##################################################################################################################################################

install_new_terminal_tilix_now()
{
show_m "install terminal tilix"
echo_2_helper_list "# new terminals"
apt_install_whith_error_whitout_exit "${New_terminal_2_install_tilix[@]}"
show_m "configuring tilix"
    # tilix ubuntu fix
    vte_Full_File="/etc/profile.d/vte.sh"
      if ! test -f $vte_Full_File; then
      vte_Full_File=$(ls /etc/profile.d/vte-*.sh)
      sudo ln -s $vte_Full_File /etc/profile.d/vte.sh || show_em "error link vte failed"
      fi
      
    if [ "$gnome_desktop_environment" == "true" ]
    then
    	show_m "set tilix as default terminal"
    	sudo update-alternatives --set x-terminal-emulator /usr/bin/tilix.wrapper
    fi
}

install_new_terminal_kitty_now()
{
show_m "install terminal kitty "
apt_install_whith_error_whitout_exit "${New_terminal_2_install_kitty[@]}"
show_m "configuring  kitty"
echo_2_helper_list ""
if [ "$gnome_desktop_environment" != "true" ]
then
	show_m "set kitty as default terminal"
	sudo update-alternatives --set x-terminal-emulator /usr/bin/kitty
fi

 show_m "configuring  kitty terminal"
 mkdir -p ~/.config/kitty/
 mkdir -p ~/.config/kitty/themes
 cp /usr/share/doc/kitty/examples/kitty.conf ~/.config/kitty/
 newwget -P ~/.config/kitty/themes/ https://raw.githubusercontent.com/dari862/my-linux-script/main/Config/kitty-themes/nord.conf
 sed -i 's/background_opacity 1.0/#background_opacity 1.0/g' ~/.config/kitty/kitty.conf
 echo "background_opacity 0.8" > ~/.config/kitty/theme.conf
 echo "# color scheme" >> ~/.config/kitty/theme.conf
 echo "include ./themes/nord.conf" >> ~/.config/kitty/theme.conf
 echo "include ./theme.conf" >> ~/.config/kitty/kitty.conf
}

install_new_terminal_terminator_now()
{
show_m "install terminal terminator"
echo_2_helper_list "# new terminals"
apt_install_whith_error_whitout_exit "${New_terminal_2_install_terminator[@]}"
echo_2_helper_list ""
show_m "configuring terminator"
sudo update-alternatives --set x-terminal-emulator /usr/bin/terminator
mkdir -p ~/.config/terminator/
newwget -P ~/.config/terminator/ https://raw.githubusercontent.com/dari862/my-linux-script/main/Config/terminator/config
}

##################################################################################################################################################
# GNOME
##################################################################################################################################################

install_main_apps_for_gnome()
{
if [ "$do_you_want_to_upgrade_gnome_to_gnome_4_" == "true" ]
then
gnome_desktop_environment_ver="GNOME_NEW"
	if [ "$DISTRO" == "Ubuntu" ] || [ "$ubuntu_similar_DISTRO" == "true" ]
	then
	      show_m "Adding GNOME 4 repository"
	      sudo add-apt-repository ppa:shemgp/gnome-40
	elif [ "$DISTRO" == "Debian" ]
	then
	      show_m "Adding experimental repository for GNOME 4"
	      add_new_source_to_apt_now mod "" repolink "deb http://deb.debian.org/debian/ experimental main" reponame "experimental-debian"
	fi
fi

aptupdate

if [ "$gnome_desktop_environment_ver" == "GNOME_OLD" ]
then
	if [ -z "$(apt-cache show gnome-shell | grep "Version:" | head -n 1 | cut -d ' ' -f 2 | cut -d . -f 1)" ] 
	then
		gnome_desktop_environment_ver="GNOME_OLD"
	elif [ "$(apt-cache show gnome-shell | grep "Version:" | head -n 1 | cut -d ' ' -f 2 | cut -d . -f 1)" -lt 4 ] 
	then
		gnome_desktop_environment_ver="GNOME_OLD"
	elif [ "$(apt-cache show gnome-shell | grep "Version:" | head -n 1 | cut -d ' ' -f 2 | cut -d . -f 1)" -ge 4 ] 
	then
		gnome_desktop_environment_ver="GNOME_NEW"
		do_we_need_to_re_install_gnome_desktop_environment="true"
	fi
fi

if [ "$do_you_want_to_upgrade_gnome_to_gnome_4_" == "true" ]
then
	show_m "Upgrade GNOME desktop environment."
	if [ "$DISTRO" == "Ubuntu" ] || [ "$ubuntu_similar_DISTRO" == "true" ]
	then
		sudo apt-get --reinstall install -y gnome &>> $debug_log 
	fi
	if [ "$DISTRO" == "Debian" ]
	then
	sudo apt-get install -t experimental -y gnome &>> $debug_log 
	fi
fi

if [ "$do_we_need_to_re_install_gnome_desktop_environment" == "true" ]
then
	show_m "re-installing GNOME desktop environment."
	sudo apt-get --reinstall install -y gnome &>> $debug_log 
fi

if [ "$gnome_desktop_environment_ver" == "GNOME_NEW" ]
then
	outsidemyrepo_Nordic_darker="$outsidemyrepo_Nordic_darker_v40"
	outsidemyrepo_Sweet_Dark="$outsidemyrepo_Sweet_Dark_v40"
fi

mkdir -p $temp_folder_for_GNOME
mkdir -p $temp_folder_for_GNOME/compressed_files
cd $temp_folder_for_GNOME

show_m "downloading GNOME themes"
newwget -o $temp_folder_for_GNOME/compressed_files/Nordic-darker.tar.xz $outsidemyrepo_Nordic_darker
extract_now $temp_folder_for_GNOME/compressed_files/Nordic-darker.tar.xz $temp_folder_for_GNOME
mv $temp_folder_for_GNOME/Nordic-darker* $temp_folder_for_GNOME/Nordic-darker &>> $debug_log || echo ""

newwget -o $temp_folder_for_GNOME/compressed_files/Zafiro-Icons-Dark.tar.xz $outsidemyrepo_Zafiro_Icons_Dark
extract_now $temp_folder_for_GNOME/compressed_files/Zafiro-Icons-Dark.tar.xz $temp_folder_for_GNOME

newwget -o $temp_folder_for_GNOME/compressed_files/Nordzy-cursors.zip $outsidemyrepo_Nordzy_cursors
extract_now $temp_folder_for_GNOME/compressed_files/Nordzy-cursors.zip $temp_folder_for_GNOME
mv $temp_folder_for_GNOME/Nordzy-cursors-* $temp_folder_for_GNOME/Nordzy-cursors

newwget -o $temp_folder_for_GNOME/compressed_files/Sweet-Dark.zip $outsidemyrepo_Sweet_Dark
extract_now $temp_folder_for_GNOME/compressed_files/Sweet-Dark.zip $temp_folder_for_GNOME
mv $temp_folder_for_GNOME/Sweet-Dark* $temp_folder_for_GNOME/Sweet-Dark &>> $debug_log || echo ""

newwget -o $temp_folder_for_GNOME/compressed_files/candy-icons.zip $outsidemyrepo_candy_icons
extract_now $temp_folder_for_GNOME/compressed_files/candy-icons.zip $temp_folder_for_GNOME
mv $temp_folder_for_GNOME/candy-icons-* $temp_folder_for_GNOME/candy-icons

newwget -o $temp_folder_for_GNOME/compressed_files/WhiteSur-light.tar.xz $outsidemyrepo_WhiteSur_light
extract_now $temp_folder_for_GNOME/compressed_files/WhiteSur-light.tar.xz $temp_folder_for_GNOME/

newwget -o $temp_folder_for_GNOME/compressed_files/BigSur-icon-theme.zip $outsidemyrepo_BigSur_icon_theme
extract_now $temp_folder_for_GNOME/compressed_files/BigSur-icon-theme.zip $temp_folder_for_GNOME

newwget -o $temp_folder_for_GNOME/compressed_files/McMojave-cursors.zip $outsidemyrepo_McMojave_cursors
extract_now $temp_folder_for_GNOME/compressed_files/McMojave-cursors.zip $temp_folder_for_GNOME

newwget -o $temp_folder_for_GNOME/compressed_files/Windows10master.zip $outsidemyrepo_Windows10
extract_now $temp_folder_for_GNOME/compressed_files/Windows10master.zip $temp_folder_for_GNOME/compressed_files
mv $temp_folder_for_GNOME/compressed_files/Windows-10-* $temp_folder_for_GNOME/Windows-10-themes

newwget -o $temp_folder_for_GNOME/compressed_files/Windows10mastericons.zip $outsidemyrepo_Windows10_icons
extract_now $temp_folder_for_GNOME/compressed_files/Windows10mastericons.zip $temp_folder_for_GNOME/compressed_files
mv $temp_folder_for_GNOME/compressed_files/Windows-10-* $temp_folder_for_GNOME/Windows-10-icons

newwget -o $temp_folder_for_GNOME/compressed_files/Vimix-cursors.zip $outsidemyrepo_Vimix_cursors
extract_now $temp_folder_for_GNOME/compressed_files/Vimix-cursors.zip $temp_folder_for_GNOME/compressed_files
mv $temp_folder_for_GNOME/compressed_files/Vimix-cursors-*/dist/ $temp_folder_for_GNOME/Vimix-cursors
mv $temp_folder_for_GNOME/compressed_files/Vimix-cursors-*/dist-white/ $temp_folder_for_GNOME/Vimix-white-cursors

newwget -o $temp_folder_for_GNOME/compressed_files/Tela-circle-icon-theme.zip $outsidemyrepo_Tela_circle_icon_theme
extract_now $temp_folder_for_GNOME/compressed_files/Tela-circle-icon-theme.zip $temp_folder_for_GNOME

newwget -o $temp_folder_for_GNOME/compressed_files/Orchis-theme.zip $outsidemyrepo_Orchis_theme
extract_now $temp_folder_for_GNOME/compressed_files/Orchis-theme.zip $temp_folder_for_GNOME

show_m "downloading GNOME extention"
newwget -o $temp_folder_for_GNOME/compressed_files/compiz-alike-windows-effect.zip $outsidemyrepo_compiz_alike_windows_effect
extract_now $temp_folder_for_GNOME/compressed_files/compiz-alike-windows-effect.zip $temp_folder_for_GNOME
mv $temp_folder_for_GNOME/compiz-alike-windows-effect-* $temp_folder_for_GNOME/compiz-alike-windows-effect@hermes83.github.com

show_m "downloading and installing gedit themes"
install -d $Gedit_theme_folder
git-clone $outsidemyrepo_mig_gedit_themes $Gedit_theme_folder
newwget -P $Gedit_theme_folder $outsidemyrepo_nord_gedit

show_m "downloading GDM theme"
git-clone "$outsidemyrepo_flat_remix_gnome_greeter" $temp_folder_for_GNOME/flat-remix-gnome

show_mf "install_gnome_apps_now "
show_m "install  sassc"
$sudoaptinstall sassc libglib2.0-dev-bin libxml2-utils make
show_m "install gnome app "
echo_2_helper_list "# GNOME apps"
apt_install_whith_error2info "${gnome_apps_[@]}"

show_m "install gnome-shell-extensions"

apt_install_whith_error2info "${gnome_shell_extensions_[@]}"

if [ "$DISTRO" != "Ubuntu" ] && [ "$ubuntu_similar_DISTRO" != "true" ]; then
apt_install_whith_error2info "${gnome_shell_extensions_dashtodock_[@]}"
#gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval 'Meta.restart(_("Restarting…"))'
killall gnome-shell &>> $debug_log || show_im "can not kill gnome-shell: no process found"
sleep 5
fi
conky_now
echo_2_helper_list ""
}
##################################################################################################################################################
# KDE
##################################################################################################################################################

install_main_apps_for_kde()
{
show_mf "install_kde_apps_now "
show_m "installing kvantum manager"
apt_install_whith_error2info "${install_kvantum_[@]}"
show_m "installing latte-dock"
apt_install_whith_error2info "${install_latte_dock_[@]}"

mkdir -p $temp_folder_for_KDE
cd $temp_folder_for_KDE
show_m "downloading Sweet KDE theme"
svn-export $outsidemyrepo_Sweet_KDE_theme
mv kde kde1
show_m "downloading Nordic KDE theme"
svn-export $outsidemyrepo_Nordic_KDE_theme
cd kde
mv sddm Nordic
mkdir -p sddm
mv Nordic sddm
mv look-and-feel Nordic
mkdir -p look-and-feel
mv Nordic look-and-feel
mkdir -p plasma
mv look-and-feel plasma
cd ..
cp -r kde1/* kde
rm -rdf kde1
cd kde
mv colorschemes color-schemes
sudo chown root:root -R sddm/*
mv aurorae themes
mkdir -p aurorae
mv themes aurorae

cd $temp_folder_for_KDE

show_m "downloading new theme color"
newwget https://raw.githubusercontent.com/dari862/my-linux-script/main/Config/kde/Nature.colors

show_m "downloading new icons"
newwget -o candy_icons_master.zip $outsidemyrepo_candy_icons
extract_now candy_icons_master.zip $PWD
mv candy-icons-master candy-icons

show_m "downaloading  ROUNDED-COLOR plasma theme "
svn-export $outsidemyrepo_ROUNDED_COLOR_plasma_theme

show_m "download plasmoids apps "
svn-export $outsidemyrepo_kde_plasmoid_betterinlineclock
git-clone $outsidemyrepo_apptitle_plasmoid apptitle-plasmoid
mv apptitle-plasmoid/org.communia.apptitle .
rm -rdf apptitle-plasmoid

show_m "download kwin_script_and_rules_now"
newwget $outsidemyrepo_krohnkite
git-clone $outsidemyrepo_kwinscript_window_colors lattewindowcolors

show_m "downloading layout.latte"
newwget https://raw.githubusercontent.com/dari862/my-linux-script/main/Config/kde/dari.layout.latte
conky_now
}

##################################################################################################################################################
# preWM
##################################################################################################################################################

install_polybar_app_now_()
{
show_m "install polybar app "
apt_install_whith_error2info "${install_polybar_[@]}"
show_m "download polybar config "
mkdir -p $temp_folder_for_skel_config
cd $temp_folder_for_skel_config
svn-export https://github.com/dari862/my-linux-script/trunk/Config/polybar
show_m "download rofi config "
svn-export https://github.com/dari862/my-linux-script/trunk/Config/rofi
show_m "install fonts for polybar app "
mkdir -p $temp_folder_for_download
sudo mkdir -p /usr/share/fonts
cd $temp_folder_for_download
svn-export $outsidemyrepo_fonts_polybar_themes
sudo chown -R root:root fonts
sudo mv $temp_folder_for_download/fonts/* /usr/share/fonts &> /dev/null || show_em "falied to move all fonts files"
sudo fc-cache -vf
}

install_xfce4_panel_app_now_()
{
show_m "install xfce4-panel app "
echo_2_helper_list "# xfce4 apps"
apt_install_whith_error2info "${install_xfce4_panel[@]}"
echo_2_helper_list ""
mkdir -p $temp_folder_for_skel_config
cd $temp_folder_for_skel_config
svn-export https://github.com/dari862/my-linux-script/trunk/Config/xfce4-panel/xfce4

###################################################################
show_m "Install clear xfce4-notify theme and configure xfce4-panel"
# Copy users config
sudo mkdir -p "/usr/share/themes/clear-notify/xfce-notify-4.0/"
mkdir -p $temp_folder_for_download
newwget -P $temp_folder_for_download https://raw.githubusercontent.com/dari862/my-linux-script/main/Config/xfce4-panel/clear_xfce-notify-4.0_gtk.css
sudo mv -v "$temp_folder_for_download/clear_xfce-notify-4.0_gtk.css" "/usr/share/themes/clear-notify/xfce-notify-4.0/gtk.css"
sudo chown root:root /usr/share/themes/clear-notify/xfce-notify-4.0/gtk.css
#fix xfce4-panel workspace settings error in openbox
sudo ln -s /usr/bin/obconf /usr/bin/xfwm4-workspace-settings
}

############################################################################

install_firefox_app_now_()
{
show_m "installing firefox"
apt_purge_with_error2info "firefox-esr"
apt_if_install_whith_error2info "${install_internet_app_firefox[@]}"
if command -v firefox >/dev/null
then
   sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser $(command -v firefox) 90
   sudo update-alternatives --set x-www-browser $(command -v firefox)
fi

if command -v firefox-esr >/dev/null
then
   sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser $(command -v firefox-esr) 90
   sudo update-alternatives --set x-www-browser $(command -v firefox-esr)
fi
}

install_files_manager_app_now_()
{
show_m "installing file manager"
apt_install_whith_error_whitout_exit "${install_files_manager_app[@]}"
if command -v $install_files_manager_app >/dev/null
then
	sudo update-alternatives --install /usr/bin/x-file-manager x-file-manager $(command -v $install_files_manager_app) 90
	sudo update-alternatives --set x-file-manager $(command -v $install_files_manager_app)
fi
}

install_text_editer_app_now_()
{
show_m "installing text editor"
apt_install_whith_error_whitout_exit "${install_text_editer_app[@]}"
if command -v $install_text_editer_app >/dev/null
then
	sudo update-alternatives --install /usr/bin/x-text-editor x-text-editor $(command -v $install_text_editer_app) 90
	sudo update-alternatives --set x-text-editor $(command -v $install_text_editer_app)
fi

if ! command -v libreoffice >/dev/null
then
   sudo update-alternatives --install /usr/bin/x-office x-office $(command -v $install_text_editer_app) 90
   sudo update-alternatives --set x-office $(command -v $install_text_editer_app)
fi
}

install_lock_screen_app_now_()
{
show_m "installing screenlocker"
apt_install_whith_error_whitout_exit "${install_x_lock_app[@]}"
if command -v $install_x_lock_app >/dev/null
then
	sudo update-alternatives --install /usr/bin/x-locker x-locker $(command -v $install_x_lock_app) 90
	sudo update-alternatives --set x-locker $(command -v $install_x_lock_app)
fi
}

install_terminal_based_sound_apps_now()
{
show_m "install terminal based sound app "
echo_2_helper_list "# terminal based Sound apps"
apt_install_whith_error_whitout_exit "${install_terminal_based_sound_app[@]}"
echo_2_helper_list ""
}

install_sddm_if_needed_now()
{
if [ ! -f "/etc/X11/default-display-manager" ]
then
	show_m "installing display manager (sddm)."
	apt_install_whith_error2info "sddm"
fi
}

############################################################################

install_main_apps_for_preWM()
{
show_mf "installing_PreWM_apps_now "
show_m "preWM_apps."
echo_2_helper_list "# preWM_apps app"
apt_install_whith_error_whitout_exit "${install_preWM_apps[@]}"
install_sddm_if_needed_now
install_new_terminal_kitty_now
install_files_manager_app_now_
install_text_editer_app_now_
install_lock_screen_app_now_
show_m "install internet apps."
echo_2_helper_list "# internet apps"
install_firefox_app_now_
echo_2_helper_list ""
show_m "install preWM_themeing_apps"
echo_2_helper_list "# preWM_themeing app"
apt_install_whith_error_whitout_exit "${install_preWM_themes[@]}"
echo_2_helper_list ""
install_terminal_based_sound_apps_now
show_m "download config for preWM_themeing_apps"
mkdir -p $temp_folder_for_preWM
mkdir -p $temp_folder_for_preWM/compressed_files
cd $temp_folder_for_preWM
svn-export https://github.com/dari862/my-linux-script/trunk/Config/preWM_config_files
git-clone $outsidemyrepo_prewm_Nordic_theme Nordic
sudo chown -R root:root Nordic
git-clone $outsidemyrepo_prewm_Layan_cursors build_Layan_Cursors
cd $temp_folder_for_preWM/compressed_files
newwget $outsidemyrepo_prewm_fonts_FiraCode
newwget $outsidemyrepo_prewm_fonts_Meslo
extract_now FiraCode.zip fonts
extract_now Meslo.zip fonts
mkdir -p $temp_folder_for_preWM/fonts/
mv $temp_folder_for_preWM/compressed_files/fonts/* $temp_folder_for_preWM/fonts/
cd $temp_folder_for_preWM
sudo chown -R root:root fonts
install_nitrogen_now
}

##################################################################################################################################################
# bspwm
##################################################################################################################################################

install_main_apps_for_bspwm()
{
mkdir -p $temp_folder_for_bspwm
cd $temp_folder_for_bspwm
svn-export https://github.com/dari862/my-linux-script/trunk/Config/bspwm_config_files/ $temp_folder_for_bspwm
# Add base packages
show_mf "pre_bspwm_now "
show_m "install bspwm app "
echo_2_helper_list "# bspwm app"
apt_install_whith_error_whitout_exit "${install_bspwm_[@]}"
echo_2_helper_list ""

show_m "install bspwm_extra app "
echo_2_helper_list "# bspwm_extra app"
apt_install_whith_error_whitout_exit "${install_bspwm_extra[@]}"
echo_2_helper_list ""
}

##################################################################################################################################################
# awesomewm
##################################################################################################################################################

install_main_apps_for_awesomewm()
{ 
mkdir -p $temp_folder_for_awesomewm
show_mf "install_awesomewm_now "
show_m "install awesomeWM app "
echo_2_helper_list "# awesomeWM app"
apt_install_whith_error_whitout_exit "${install_awesomeWM_[@]}"
echo_2_helper_list ""

show_m "install awesomeWM extra app "
echo_2_helper_list "# awesomeWM extra app"
apt_install_whith_error_whitout_exit "${install_awesomeWM_extra[@]}"
echo_2_helper_list ""
}

##################################################################################################################################################
# openBOX
##################################################################################################################################################

install_main_apps_for_openbox()
{
# install conky
conky_now
# set nitrogen wallpaper
sed -i "s/$nitrogen_wp_default/$replace_nitrogen_wp_default/g" $temp_folder_for_skel_/.config/nitrogen/bg-saved.cfg
show_mf "install_main_apps_for_openbox "
show_m "install openbox apps"
install_new_terminal_terminator_now
echo_2_helper_list "# openbox apps"
apt_install_whith_error_whitout_exit "${install_openbox_[@]}"
echo_2_helper_list ""
show_m "install openbox extra apps"
echo_2_helper_list "# openbox extra apps"
apt_install_whith_error_whitout_exit "${install_openbox_extra[@]}"
apt_install_whith_error_whitout_exit "${install_openbox_extra2[@]}"
apt_install_whith_error_whitout_exit "${install_openbox_fonts[@]}"
echo_2_helper_list ""
cd $temp_folder_for_themes_and_apps
svn-export https://github.com/dari862/my-linux-script/trunk/Config/openbox
mkdir -p $temp_folder_for_download
git-clone $outsidemyrepo_Tela_icon_theme $temp_folder_for_download/Tela-icon-theme
cd $temp_folder_for_openbox
cp -v ${temp_folder_for_openbox}/user_bin/* $temp_folder_for_usr_bin_
newwget -P $temp_folder_for_usr_bin_ "$outsidemyrepo_ps_mem" 
newwget -P $temp_folder_for_usr_bin_ "$outsidemyrepo_bashtop"

archcraft_os_stuffs()
{
local url_archcraft_os="$1"
local tempvar="$2"

git-clone $url_archcraft_os $temp_folder_for_download/openbox_${tempvar}
mkdir -p $temp_folder_for_openbox/${tempvar}

if [ "$tempvar" != "archcraft" ]
then
	for d in $temp_folder_for_download/openbox_${tempvar}/* ; do
		[ -d "$d" ] && mv -f ${d}/files/* $temp_folder_for_openbox/${tempvar}
	done
else
	for d in $temp_folder_for_download/openbox_${tempvar}/* ; do
		if [ -d "$d" ]
		then
			new_name=${d##*/}
			mv -f ${d}/files $temp_folder_for_openbox/${tempvar}/${new_name//archcraft-/}
		fi
	done
	mv $temp_folder_for_openbox/${tempvar}/pixmaps $temp_folder_for_openbox/${tempvar}/icons
fi
}

archcraft_os_stuffs "$outsidemyrepo_archcraft_os_themes" "themes"
archcraft_os_stuffs "$outsidemyrepo_archcraft_os_backgrounds" "backgrounds"
archcraft_os_stuffs "$outsidemyrepo_archcraft_os_icons" "icons"
archcraft_os_stuffs "$outsidemyrepo_archcraft_os_cursors" "cursors"
archcraft_os_stuffs "$outsidemyrepo_archcraft_os_archcraft" "archcraft"
git-clone "$outsidemyrepo_archcraft_os_archcraft_openbox" $temp_folder_for_download/archcraft-openbox
git-clone "$outsidemyrepo_archcraft_os_networkmanager_dmenu" $temp_folder_for_download/networkmanager-dmenu

apt_install_whith_error_whitout_exit "${install_openbox_archcraft[@]}"
add_new_source_to_apt_now mod "gpg" repolink "deb http://download.opensuse.org/repositories/home:/Head_on_a_Stick:/obmenu-generator/Debian_10/ /" reponame  "obmenu_generator" keylink "https://download.opensuse.org/repositories/home:Head_on_a_Stick:obmenu-generator/Debian_10/Release.key" keyname "obmenu-generator.gpg"
aptupdate
apt_install_whith_error_whitout_exit "${install_openbox_obmenu_generator[@]}"

}


##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################
# tweak_my_terminal
##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################

install_terminal_apps_now()
{
show_m "install app for better terminal"
echo_2_helper_list "# apps for better terminal"
apt_install_whith_error_whitout_exit "${install_apps_4_better_terminal[@]}"
echo_2_helper_list ""
}

install_zsh_now()
{
show_m "install zsh app"
echo_2_helper_list "# zsh apps"
apt_install_whith_error "${install_zsh_and_some_plugins[@]}"
echo_2_helper_list ""
# fix zsh-antigen

does_antigen_env_setup_works=$(grep -c antigen-env-setup /usr/share/zsh-antigen/antigen.zsh)
if [ "$does_antigen_env_setup_works" -gt "1" ]
then
	echo "antigen works fine"
else
newwget -o $foldertempfornow/antigen.zsh $outsidemyrepo_antigen
sudo mv /usr/share/zsh-antigen/antigen.zsh /usr/share/zsh-antigen/antigen.zsh.backup
sudo mv $foldertempfornow/antigen.zsh /usr/share/zsh-antigen/
fi
}

install_main_apps_for_tweak_my_terminal()
{
show_mf "install tweak my terminal apps"
install_new_terminal_tilix_now
install_new_terminal_kitty_now
install_terminal_apps_now
install_zsh_now

show_m "download new zsh and bash configure "
mkdir -p $temp_folder_for_shell_config

declare -a Remote_source_Array=(
Flat-Remix.json.tilix
aliases
bashrc.sh
functions
misc
zshrc.sh
zsh_only_aliases
bash_only_aliases
)
for i in ${!Remote_source_Array[*]}; do
  newwget -P $temp_folder_for_shell_config https://raw.githubusercontent.com/dari862/my-linux-script/main/Config/shell/${Remote_source_Array[$i]} ;
done

if [ "$bashrcfilename" != "bashrc.sh" ]
then
mv $temp_folder_for_shell_config/bashrc.sh $temp_folder_for_shell_config/$bashrcfilename
fi

if [ "$zshrcfilename" != "zshrc.sh" ]
then
mv $temp_folder_for_shell_config/zshrc.sh $temp_folder_for_shell_config/$zshrcfilename
fi

show_m "download zsh and bash themes. "

mkdir -p $temp_folder_for_shell_config/zthemes
declare -a StringArray=(
https://raw.githubusercontent.com/dari862/my-linux-script/main/Config/shell/zthemes/amazing.zsh-theme
$outsidemyrepo_headline_zsh_theme
https://raw.githubusercontent.com/dari862/my-linux-script/main/Config/shell/zthemes/SSH.zsh-theme
)
for i in ${!StringArray[*]}; do
newwget -P $temp_folder_for_shell_config/zthemes ${StringArray[$i]} ;
done

mkdir -p $temp_folder_for_shell_config/bashthemes
declare -a StringArray=(
https://raw.githubusercontent.com/dari862/my-linux-script/main/Config/shell/bashthemes/amazing.bash-prompt-theme
)
for i in ${!StringArray[*]}; do
newwget -P $temp_folder_for_shell_config/bashthemes ${StringArray[$i]} ;
done

show_m "download zsh plugins "
mkdir -p $temp_folder_for_shell_config/zplugins
declare -a StringArray=(
https://raw.githubusercontent.com/dari862/my-linux-script/main/Config/shell/zplugins/zsh-autosuggestions_and_zsh-syntax-highlighting.zsh
$outsidemyrepo_ommand_not_found_plugin_zsh
)
for i in ${!StringArray[*]}; do
  newwget -P $temp_folder_for_shell_config/zplugins ${StringArray[$i]} ;
done

}


##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################
## LIGHTDM
##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################


install_configure_lightdm_display_manager_now()
{
show_m "install lightdm"
apt_install_noninteractive_whith_error2info "${install_lightdm_pre[@]}"
add_new_source_to_apt_now mod "gpg" repolink "deb http://download.opensuse.org/repositories/home:/antergos/Debian_9.0/ /" reponame  "home_antergos" keylink "https://download.opensuse.org/repositories/home:antergos/Debian_9.0/Release.key" keyname "home_antergos.gpg"
aptupdate

apt_install_noninteractive_whith_error2info "${install_lightdm_[@]}"

show_m "install lightdm extra"
apt_install_whith_error_whitout_printf_2_helper_list_and_without_exit "${install_lightdm_extra[@]}"

show_m "configure lightdm"
Get_Used_Desktop_Mang=$(sed 's|.*/||' /etc/X11/default-display-manager)
sudo sed -i "s:$Get_Used_Desktop_Mang:lightdm:" /etc/X11/default-display-manager

sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure lightdm
}

themeing_lightdm_display_manager_now()
{
show_m "Set default lightdm greeter to lightdm-webkit2-greeter"

if test -f "/etc/lightdm/lightdm.conf"; then
  sudo sed -i 's/#greeter-session=example-gtk-gnome/greeter-session=lightdm-webkit2-greeter/g' /etc/lightdm/lightdm.conf
else
  echo '[Seat:*]' | sudo tee -a /etc/lightdm/lightdm.conf
  echo 'greeter-session=lightdm-webkit2-greeter' | sudo tee -a /etc/lightdm/lightdm.conf
fi

show_m "download lightdm webkit2 greeter themes"
#glorious theme
cd $foldertempfornow
mkdir glorious
newwget $outsidemyrepo_glorious_lightdm_theme
extract_now "*glorious*.tar.gz" glorious
sudo chown -R root:root glorious
sudo mv glorious /usr/share/lightdm-webkit/themes/glorious

#litarvan theme
cd $foldertempfornow
mkdir litarvan
newwget $outsidemyrepo_litarvan_lightdm_theme
extract_now "*litarvan*.tar.gz" litarvan
sudo chown -R root:root litarvan
sudo mv litarvan /usr/share/lightdm-webkit/themes/litarvan

#Aether theme
# need some work https://github.com/NoiSek/Aether#installation
#cd $foldertempfornow
#newwget $outsidemyrepo_Aether_lightdm_theme
#extract_now v2.2.2.zip $foldertempfornow
#mv Aether* Aether
#sudo chown -R root:root Aether
#sudo cp --recursive Aether /usr/share/lightdm-webkit/themes/Aether

show_m "Set default lightdm-webkit2-greeter theme to glorious"
sudo sed -i 's/^webkit_theme\s*=\s*\(.*\)/webkit_theme = glorious #\1/g' /etc/lightdm/lightdm-webkit2-greeter.conf
}

##################################################################################################################################################
# DOAS
##################################################################################################################################################

install_doas_now()
{
$sudoaptinstall doas || show_im "can't install doas"
echo "permit persist :sudo"  | sudo tee -a /etc/doas.conf

}

does_gnome_or_kde_desktop_environment_exist()
{
if [ "$gnome_desktop_environment" != "true" ] && [ "$kde_desktop_environment" != "true" ] 
then
  install_configure_lightdm_display_manager_now
  #themeing_lightdm_display_manager_now
  #install_doas_now
fi
}

##################################################################################################################################################
# Pen
##################################################################################################################################################

main_pen_now()
{
show_mf "main_pen_now"
show_m "updating your system"
aptupdate

show_m "install certificates app "
echo_2_helper_list "# certificates app"
apt_install_whith_error2info "${install_ca_certificates_[@]}"
echo_2_helper_list ""

show_m "adding kali keys and repositories"
add_new_source_to_apt_now mod "asc" repolink "deb [arch=amd64 signed-by=/usr/share/keyrings/kali-archive-keyring.asc] https://http.kali.org/kali kali-rolling main non-free contrib" reponame "kali" keylink "https://archive.kali.org/archive-key.asc" keyname "kali-archive-keyring.asc"
show_m "set low priority for Kali Linux repositories. Kali Linux packages (for example, kernels) will not be installed automatically, but manually you can install any packages."
echo 'Package: *'| sudo tee /etc/apt/preferences.d/kali.pref; echo 'Pin: release a=kali-rolling' | sudo tee -a/etc/apt/preferences.d/kali.pref; echo 'Pin-Priority: 50'| sudo tee -a /etc/apt/preferences.d/kali.prefshow_m "updating your system after adding keys"
aptupdate || show_em "failed to updated after adding kali repo"
}

##################################################################################################################################################
##################################################################################################################################################
install_nitrogen_now()
{
show_m "Install nitrogen tool and set default wallpaper to all users"
# nitrogen_wallpaper_location var set from from common.sh

show_m "install nitrogen"
echo_2_helper_list "# nitrogen apps"
apt_install_whith_error_whitout_exit "${install_nitrogen_app[@]}"
echo_2_helper_list ""
mkdir -p "$temp_folder_for_skel_/.config/nitrogen"
# Copy users config
# Create config folders if no exists
cat << EOF > $temp_folder_for_skel_/.config/nitrogen/nitrogen.cfg
[geometry]
posx=654
posy=174
sizex=508
sizey=500

[nitrogen]
view=icon
recurse=true
sort=alpha
icon_caps=false
dirs=$wallpapers_location_now
EOF

cat << EOF > $temp_folder_for_skel_/.config/nitrogen/bg-saved.cfg
[xin_-1]
file=$wallpapers_location_now/$nitrogen_wp_default
mode=5
bgcolor=#000000
EOF
}

conky_now()
{
#https://www.pling.com/p/1607304
# INFO: Conky is a system monitor that allow configure desktop panels and personalice info and styles
show_mf "Install Conky and add basic sysinfo-shortcuts panel"

show_m "install conky-all"
echo_2_helper_list "# conky apps"
apt_install_whith_error_whitout_exit "${install_conky_all_app[@]}"
echo_2_helper_list ""

show_m "create conky theme "
mkdir -p $temp_folder_for_skel_config && cd $temp_folder_for_skel_config
svn-export https://github.com/dari862/my-linux-script/trunk/data/conky/

# Copy users config
mv -v "$temp_folder_for_skel_config/conky/start_conky.sh" $temp_folder_for_usr_bin_
chmod a+x $temp_folder_for_usr_bin_"/start_conky.sh"

sed -i "s|/.conky/|"$conky_Stuff_folder_now/"|g" $temp_folder_for_usr_bin_/start_conky.sh

StringArray=(nordcore vision)
for INDEX in ${!StringArray[*]}; do
  sed -i "s|/.conky|"$conky_Stuff_folder_now"|g" $temp_folder_for_skel_config/conky/${StringArray[$INDEX]}/conkyrc2core;
if [ "$do_you_want_to_install_Tweak_my_terminal" == "true" ]
then
cat <<EOF >> $temp_folder_for_skel_tweakterminalfolder/conky-aliases
alias nowconky-set-${StringArray[$INDEX]}="echo ${StringArray[$INDEX]} >> ~/$config_skel_folder/conky/conky_theme.conky"
EOF
elif [ -d "$temp_folder_for_skel_shell_folder" ] || [ -d "/etc/skel/$myshell_skel_folder" ]
then
cat <<EOF >> $temp_folder_for_skel_shell_folder/conky-aliases
alias nowconky-set-${StringArray[$INDEX]}="echo ${StringArray[$INDEX]} >> ~/$config_skel_folder/conky/conky_theme.conky"
EOF
else
cat <<EOF >> $temp_folder_for_skel_/.bash_aliases
alias nowconky-set-${StringArray[$INDEX]}="echo ${StringArray[$INDEX]} >> ~/$config_skel_folder/conky/conky_theme.conky"
EOF
fi

done


if [ -d "$temp_folder_for_shell_config" ]
then
cat <<EOF >> $temp_folder_for_skel_tweakterminalfolder/conky-aliases
alias nowconky-start="~/$conky_Stuff_folder_now/conky/start_conky.sh &"
alias nowconky-removeautostart="rm ~/.config/autostart/start_conky.sh.desktop" 
alias nowconky-autostart="cp ~/$conky_Stuff_folder_now/conky/start_conky.sh.desktop ~/.config/autostart/"
EOF
echo 'source $zshdotfiles/conky-aliases' >> $temp_folder_for_skel_tweakterminalfolder/$zshrcfilename
echo 'source $BASHDOTDIR/conky-aliases' >> $temp_folder_for_skel_tweakterminalfolder/$bashrcfilename
elif [ -d "$temp_folder_for_skel_shell_folder" ] || [ -d "/etc/skel/$myshell_skel_folder" ]
then 
cat <<EOF >> $temp_folder_for_skel_shell_folder/conky-aliases
alias nowconky-start="~/$conky_Stuff_folder_now/conky/start_conky.sh &"
alias nowconky-removeautostart="rm ~/.config/autostart/start_conky.sh.desktop" 
alias nowconky-autostart="cp ~/$conky_Stuff_folder_now/conky/start_conky.sh.desktop ~/.config/autostart/"
EOF
echo 'source $zshdotfiles/conky-aliases' >> $temp_folder_for_skel_shell_folder/$zshrcfilename
echo 'source $BASHDOTDIR/conky-aliases' >> $temp_folder_for_skel_shell_folder/$bashrcfilename
else
cat <<EOF >> $temp_folder_for_skel_/.bash_aliases
alias nowconky-start="~/$conky_Stuff_folder_now/conky/start_conky.sh &"
alias nowconky-removeautostart="rm ~/.config/autostart/start_conky.sh.desktop"
alias nowconky-autostart="cp ~/$conky_Stuff_folder_now/conky/start_conky.sh.desktop ~/.config/autostart/"
EOF
fi

echo nordcore > $temp_folder_for_skel_config/conky/conky_theme.conky

chown $USER:$USER -R $temp_folder_for_skel_config/conky

sudo mkdir -p /usr/local/share/fonts/sample
newwget -P $foldertempfornow/ $outsidemyrepo_font_PoiretOne_Regular_ttf
sudo chown root:root $foldertempfornow/PoiretOne-Regular.ttf
sudo mv $foldertempfornow/PoiretOne-Regular.ttf /usr/local/share/fonts/sample
}

show_grub_menu_now()
{
declare -a Grub_CHOICES_Array_now_=(
"Protectgrub" "do you want to Protect grub menu." ON
"Skipgrub" "do you want to skip grub menu." ON
)
CHOICES=$(whiptail --separate-output --checklist "Choose options" $(stty size) $whiptail_listheight "${Grub_CHOICES_Array_now_[@]}" 3>&1 1>&2 2>&3)

if [ -z "$CHOICES" ]; then
	echo "No option was selected (user hit Cancel or unselected all options)"
else
	for CHOICE in $CHOICES; do
		case "$CHOICE" in
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

############################################################################################################################################
# Grub
############################################################################################################################################

main_Grub_now()
{
show_mf "main_Grub_now"
if [ "$do_you_want_to_Protect_grub" == "true" ]
then
  # ACTION: Config GRUB with password protection for prevent users edit entries
  # INFO: By default everyone can edit GRUB entries during boot time and login with root privileges
  # DEFAULT: n

  # Config variables
  comment_mark="#DEBIAN-OPENBOX"

  # Config admin user and password
  echo -e "\e[1mSetting GRUB config...\e[0m"
  pbkdf2_pass="$(echo -e "$new_GRUB_password___pbkdf2_pass\n$new_GRUB_password___pbkdf2_pass"| grub-mkpasswd-pbkdf2  | grep "grub.pbkdf2.*" -o)"
  sudo sed -i "/${comment_mark}/Id" /etc/grub.d/40_custom
  echo 'set superusers="admin"    '"$comment_mark"'
  password_pbkdf2 admin '"$pbkdf2_pass   $comment_mark" | sudo tee -a /etc/grub.d/40_custom 

  # Config others users for select entry
  for f in /etc/grub.d/*; do 
    sudo sed -i 's/--unrestricted//g' "$f"
    sudo sed -i 's/\bmenuentry\b/menuentry --unrestricted /g' "$f" 
  done

  echo -e "\e[1mUpdating GRUB...\e[0m"
  update_grub_now
fi

#############################################################################

if [ "$do_you_want_to_skip_grub" == "true" ]
then
  # ACTION: Config GRUB for skip menu (timeout=0)
  # INFO: If you are using only one OS in the computer you con skip GRUB menu for faster boot and avoid users can edit entries
  # DEFAULT: n

  # Config variables

cat << 'EOF' > $foldertempfornow/grub.conf
GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_HIDDEN_TIMEOUT=0
GRUB_BACKGROUND=""
EOF

  # Delete existing lines
  echo -e "\e[1mSetting GRUB config...\e[0m"
  for i in $(cat "$foldertempfornow/grub.conf"  | cut -f1 -d=);do
    sudo sed -i "/\b$i=/Id" /etc/default/grub
  done

  # Add lines
  cat "$foldertempfornow/grub.conf" | sudo tee -a /etc/default/grub

  # Update grub
  echo -e "\e[1mUpdating GRUB...\e[0m"
  update_grub_now

fi
}
