main_openbox_now()
{
cd $temp_folder_for_openbox
show_mf "install and configure openbox"
show_m "install and configure openbox."

if command -v conky &>/dev/null; then
	echo openbox > $temp_folder_for_skel_config/conky/conky_theme.conky
fi

show_m "configure Openbox"
mv -v "$temp_folder_for_openbox"/dot_config_folder/* $temp_folder_for_skel_config/
sudo tar -xzvf "$temp_folder_for_openbox"/openbox_theme.tgz -C /usr/share/themes/
sudo cp -rv "$temp_folder_for_openbox/openbox-menu" /usr/share/icons/

# Install help docs
sudo cp -rv "$temp_folder_for_openbox/help" "/usr/share/doc/openbox/"

# Install system info dependences
chmod a+x $temp_folder_for_usr_bin_/ps_mem.py
chmod a+x $temp_folder_for_usr_bin_/bashtop
# Copy cups-session
chmod a+x $temp_folder_for_usr_bin_/cups-session
# Copy bt-session
chmod a+x $temp_folder_for_usr_bin_/bt-session
# Copy welcome
chmod a+x $temp_folder_for_usr_bin_/welcome
# exit-power menu based on rofi
chmod +x "$temp_folder_for_usr_bin_/obexit"
# Copy autosnap script
chmod +x $temp_folder_for_usr_bin_/autosnap 

# Copy users config	
sudo dmesg | grep -qi bluetooth || sed -i '/DEBIAN-OPENBOX-bluetooth/Id' $temp_folder_for_skel_/.config/openbox/menu.xml

# Set as default
sudo update-alternatives --set x-session-manager /usr/bin/openbox-session

################################################################################################################################################################
################################################################################################################################################################
################################################################################################################################################################
show_m "Install script autosnap for half-maximize windows with mouse middle click in titlebar" 
# INFO: Openbox lacks autosnap windows function (auto half-maximize)
# INFO: Autosnap script allow half-maximice active window to current quadrant or half screen, accroding mouse location
# INFO: The script is configured to be called when mouse middle is clicked in titlebar


comment_mark="#DEBIAN-OPENBOX-autosnap"

# Delete all previous lines added
sed -i "/${comment_mark}/Id" "$temp_folder_for_skel_/.config/openbox/rc.xml"
# Add keybinds por each autosnap command
rc="$(sed '/<keyboard>/q' "$temp_folder_for_skel_/.config/openbox/rc.xml"; cat "$temp_folder_for_openbox/autosnap/keybinds_rc.xml"; sed -n -e '/<keyboard>/,$p' "$temp_folder_for_skel_/.config/openbox/rc.xml" | tail +2 )"
echo "$rc" > "$temp_folder_for_skel_/.config/openbox/rc.xml"
# Add context titlebar
rc="$(sed '/<context name="Titlebar">/q' "$temp_folder_for_skel_/.config/openbox/rc.xml"; cat "$temp_folder_for_openbox/autosnap/titlebar_rc.xml"; sed -n -e '/<context name="Titlebar">/,$p' "$temp_folder_for_skel_/.config/openbox/rc.xml" | tail +2)"
echo "$rc" > "$temp_folder_for_skel_/.config/openbox/rc.xml"

################################################################################################################################################################
################################################################################################################################################################
################################################################################################################################################################
show_m "add user 1000 to lpadmin group to manage CUPS printer system"
# INFO: CUPS is a printer system for config printers and printer queue
# INFO: Can be managed in http://localhost:631 and admin users must be in lpadmin group

user1000=$(cat /etc/passwd | cut -f 1,3 -d: | grep :1000$ | cut -f1 -d:)
[ "$user1000" ] && sudo adduser "$user1000" lpadmin

################################################################################################################################################################
################################################################################################################################################################
################################################################################################################################################################
show_m "Install theme Arc GTK ,icon theme Numix-Paper and set as default"
# INFO: Arc GTK theme is a clear and cool GTK theme
# Install packages

# Change accent color blue (#5294e2) for grey:
sudo find /usr/share/themes/Arc -type f -exec sed -i 's/#5294e2/#b3bcc6/g' {} \;   

[ -d "$/usr/share/icons/Numix-Paper" ] && rm -rf "/usr/share/icons/Numix-Paper"
sudo tar -xzvf "$temp_folder_for_openbox"/numix-paper-icon-theme.tgz -C /usr/share/icons/	

#sed -i 's/^gtk-theme-name *= *.*/gtk-theme-name="'"Arc"'"/' "$temp_folder_for_skel_/.config/gtk-2.0/gtkrc-2.0"
#sed -i 's/^gtk-icon-theme-name *= *.*/gtk-icon-theme-name="'"Numix-Paper"'"/'	"$temp_folder_for_skel_/.config/gtk-2.0/gtkrc-2.0"
#sed -i 's/^gtk-cursor-theme-name *= *.*/gtk-cursor-theme-name="'"DMZ-White"'"/' "$temp_folder_for_skel_/.config/gtk-2.0/gtkrc-2.0"
#sed -i 's/^gtk-toolbar-icon-size *= *.*/gtk-toolbar-icon-size="'"GTK_ICON_SIZE_SMALL_TOOLBAR"'"/' "$temp_folder_for_skel_/.config/gtk-2.0/gtkrc-2.0"
#sed -i 's/^gtk-xft-hintstyle *= *.*/gtk-xft-hintstyle="'"hintslight"'"/' "$temp_folder_for_skel_/.config/gtk-2.0/gtkrc-2.0"

#sed -i 's/^gtk-theme-name *= *.*/gtk-theme-name="'"Arc"'"/' "$temp_folder_for_skel_/.config/gtk-3.0/settings.ini"
#sed -i 's/^gtk-icon-theme-name *= *.*/gtk-icon-theme-name="'"Numix-Paper"'"/'	"$temp_folder_for_skel_/.config/gtk-3.0/settings.ini"
#sed -i 's/^gtk-cursor-theme-name *= *.*/gtk-cursor-theme-name="'"DMZ-White"'"/' "$temp_folder_for_skel_/.config/gtk-3.0/settings.ini"
#sed -i 's/^gtk-toolbar-icon-size *= *.*/gtk-toolbar-icon-size="'"GTK_ICON_SIZE_SMALL_TOOLBAR"'"/' "$temp_folder_for_skel_/.config/gtk-3.0/settings.ini"
#sed -i 's/^gtk-xft-hintstyle *= *.*/gtk-xft-hintstyle="'"hintslight"'"/' "$temp_folder_for_skel_/.config/gtk-3.0/settings.ini"

################################################################################################################################################################
################################################################################################################################################################
################################################################################################################################################################
#xfce4 stuff
show_m "Install clear xfce4-notify theme and configure xfce4-panel"
# Copy users config
sudo mkdir -p "/usr/share/themes/clear-notify/xfce-notify-4.0/"
sudo mv -v "$temp_folder_for_openbox/clear_xfce-notify-4.0_gtk.css" "/usr/share/themes/clear-notify/xfce-notify-4.0/gtk.css"
#fix xfce4-panel workspace settings error in openbox
sudo ln -s /usr/bin/obconf /usr/bin/xfwm4-workspace-settings

################################################################################################################################################################
################################################################################################################################################################
################################################################################################################################################################

show_m "Install script poweroff_last for auto-poweroff if no users logged in 20 minutes"
# INFO: Automatic poweroff may be useful in public or shared computers to avoid left computers ON needlessly

sudo bash "$temp_folder_for_openbox/autopoweroff" -I 20


install_now_brightness()
{
# ACTION: Install script to control screen brightness
# INFO: Script birghtness allow increment and decrement screen brightness
# INFO: Is used in tint2 taskbar config for inc/dec brightness with mouse wheel
sudo bash "$temp_folder_for_openbox/brightness" -I 
}
################################################################################################################################################################
################################################################################################################################################################
################################################################################################################################################################

install_now_WIFI()
{
newwget https://raw.githubusercontent.com/leomarcov/debian-openbox/master/script_wifi-manager/wifi-manager
}

################################################################################################################################################################
################################################################################################################################################################
################################################################################################################################################################

show_m "openbox copy temp_folder_for_openbox files."
sudo chown root:root ${temp_folder_for_openbox}/usr_share_app/*
sudo mv ${temp_folder_for_openbox}/usr_share_app/* /usr/share/applications/
sudo chown -R root:root $temp_folder_for_usr_bin_
sudo cp -rv $temp_folder_for_usr_bin_/* "/usr/bin/"

# Create welcome link
sudo ln -s /usr/bin/welcome "/$temp_folder_for_skel_/.config/openbox/welcome"
}
