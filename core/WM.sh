##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################
# PreWM
##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################
configure_PreWM_now()
{
show_m "install preWM_apps"
cd $temp_folder_for_preWM

# update-notification
mv $temp_folder_for_preWM/preWM/usr_bin/update-notification $temp_folder_for_download
sudo bash "$temp_folder_for_download/update-notification" -I

mkdir -p $temp_folder_for_skel_/.local/bin
sudo mv $temp_folder_for_preWM/preWM/usr_bin/* $temp_folder_for_usr_bin_
mv $temp_folder_for_preWM/preWM/local_bin/* $temp_folder_for_skel_/.local/bin

mkdir -p $temp_folder_for_skel_config/gtk-3.0
mv $temp_folder_for_preWM/preWM/config/gtk-3.0/* $temp_folder_for_skel_config/gtk-3.0 && rm -rdf $temp_folder_for_preWM/preWM/config/gtk-3.0 || echo "falied to move all gtk-3.0 files"
mv $temp_folder_for_preWM/preWM/config/* $temp_folder_for_skel_config &> /dev/null || echo "falied to move all preWM/config files"
if [ -z "$(ls -A $temp_folder_for_preWM/preWM/config)" ]; then
   echo "preWM/config copyed without any errors"
else
   ls -aR $temp_folder_for_preWM/preWM/config > $missing_content_from_preWM_config_files && show_em "falied to move all preWM/config files"
fi

if [ "$virtual_machine" == "true" ]
then
   sed -i 's|# vsync = false|vsync = false;|g' $temp_folder_for_skel_config/picom.conf
   sed -i 's|vsync = true;|# vsync = true|g' $temp_folder_for_skel_config/picom.conf
fi
show_m "Enable network interface managemnet "
sudo sed -i 's/managed=.*/managed=true/g' /etc/NetworkManager/NetworkManager.conf

mkdir -p $temp_folder_for_skel_config/autostart

####################################
# PreWM_themeing_now
####################################
show_m "PreWM_themeing_now "

sudo mkdir -p /usr/share/fonts
sudo mv $temp_folder_for_preWM/fonts/* /usr/share/fonts &> /dev/null || show_em "falied to move all fonts files"
sudo fc-cache -vf

# Download Nordic Theme
sudo mv $temp_folder_for_preWM/Nordic /usr/share/themes/ &> /dev/null || show_em "falied to move all Nordic theme files"
# Layan Cursors
cd $temp_folder_for_preWM/build_Layan_Cursors
sudo ./install.sh
}

main_PreWM_now()
{
show_mf "Pre-WM."
configure_PreWM_now
}

##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################
# open_stuff
##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################

configure_open_stuff_os_stuffs_now_()
{

if [ -f "$temp_folder_for_download/open_stuff_files_configured__" ]
then
	return 0
fi

sudo mkdir -p /usr/share/fonts
sudo mv $temp_folder_for_open_stuff/fonts/* /usr/share/fonts
sudo chown -R root:root /usr/share/fonts
sudo fc-cache -vf

sudo chown -R root:root $temp_folder_for_open_stuff/open_stuff
sudo mv $temp_folder_for_open_stuff/open_stuff /usr/share/

sudo mkdir -p /usr/share/icons
sudo chown -R root:root $temp_folder_for_open_stuff/icons
sudo cp -rf $temp_folder_for_open_stuff/icons/* /usr/share/icons

sudo chown -R root:root $temp_folder_for_open_stuff/themes

sudo mkdir -p /usr/share/themes
for d in $temp_folder_for_open_stuff/themes/* ; do
	Directory_name=${d##*/}
	[ -d "/usr/share/themes/$Directory_name" ] && sudo rm -rdf /usr/share/themes/$Directory_name
done

sudo mv $temp_folder_for_open_stuff/themes/* /usr/share/themes

touch $temp_folder_for_download/open_stuff_files_configured__

}
##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################
# polybar
##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################

Configure_QT_stuff_now()
{
show_m "Configure QT Themes and apps "
cp -fr QT_config/* $temp_folder_for_skel_/.config
}

configure_polybar_now()
{

mkdir -p ${temp_folder_for_polybar}/usr_share_app
mv $temp_folder_for_download/networkmanager-dmenu/networkmanager_dmenu $temp_folder_for_usr_bin_
mv $temp_folder_for_download/networkmanager-dmenu/networkmanager_dmenu.desktop ${temp_folder_for_polybar}/usr_share_app

configure_open_stuff_os_stuffs_now_
}

##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################
# xfce4_panel
##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################

configure_xfce4_now()
{
sed -i "s|/home/dari|$HOME|g" $temp_folder_for_skel_config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
configure_open_stuff_os_stuffs_now_
}

##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################
# awesomeWM
##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################

configure_awesomewm_and_dependancy_now()
{

show_m "configure awesomeWN"

where_is_awesome="$HOME/.config/awesome"

mkdir -p $where_is_awesome/awesome
cp /etc/xdg/awesome/rc.lua $where_is_awesome

#sed -i 's/terminal = "x-terminal-emulator"/local terminal = "x-terminal-emulator"/g' $where_is_awesome/rc.lua
#sed -i 's/editor = os.getenv/local editor = os.getenv/g' $where_is_awesome/rc.lua
#sed -i 's/editor_cmd = /local editor_cmd = /g' $where_is_awesome/rc.lua

sed -i '/^-- {{{ Variable definitions/a -- Var for Applications' $where_is_awesome/rc.lua
sed -i '/^-- Var for Applications/a filesmanagerr = "pcmanfm"' $where_is_awesome/rc.lua
sed -i '/^-- Var for Applications/a screenshot = "flameshot"' $where_is_awesome/rc.lua
sed -i '/^-- Var for Applications/a browser = "firefox"' $where_is_awesome/rc.lua

sed -i 's/modkey = /modkey = /g' $where_is_awesome/rc.lua
sed -i 's/"Mod4"/"Mod1"/g' $where_is_awesome/rc.lua

sed -i '/^-- {{{ Variable definitions/a titlebars_status_now = false' $where_is_awesome/rc.lua
sed -i 's/properties = { titlebars_enabled = true }/properties = { titlebars_enabled = titlebars_status_now }/g' $where_is_awesome/rc.lua

sed -i 's/awful.screen.focused().mypromptbox:run()/awful.util.spawn("dmenu_run")/g' $where_is_awesome/rc.lua

# work on awful.layout.layouts
# add https://github.com/Elv13/collision

sed -i 's/awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }/awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }/g' $where_is_awesome/rc.lua

cat << EOF > ffffffff.txt
    awful.key({ modkey }, "b", function () awful.spawn(browser) end,
              {description = "run browser", group = "launcher"}),

    -- User File manager
    awful.key({ modkey }, "b", function () awful.spawn(filesmanagerr) end,
              {description = "launch File manager", group = "launcher"}),
			  
    -- Dmenu  
EOF
sed -i '/-- Prompt/ r ffffffff.txt' $where_is_awesome/rc.lua	  
sed -i 's/-- Prompt/-- User browser/g' $where_is_awesome/rc.lua
rm ffffffff.txt

sed -i '/^-- {{{ Variable definitions/a sloppy_focuss_enabled = false' $where_is_awesome/rc.lua
sed -i '/^-- Enable sloppy focus/{N;N;N;s/$/\nend/}' $where_is_awesome/rc.lua
sed -i '/^-- Enable sloppy focus/a then' $where_is_awesome/rc.lua
sed -i '/^-- Enable sloppy focus/a if sloppy_focuss_enabled' $where_is_awesome/rc.lua

}

modularize_awesomeWM_rc_file_now()
{
show_m "modularize_awesomeWM_rc_file_now "
local temp_var_for_new_module_name=""
local temp_var_for_new_module_folder_name=""
local temp_var_for_theme_location=""
local temp_var_for_Variable_location=""

#themes
temp_var_for_new_module_name="theme-picker"
temp_var_for_new_module_folder_name="themes"
mkdir -p $where_is_awesome/$temp_var_for_new_module_folder_name
cp /usr/share/awesome/themes/gtk/theme.lua $where_is_awesome/themes/gtk.lua
sed -i 's/theme.useless_gap   = dpi(3)/theme.useless_gap   = dpi(5)/g' $where_is_awesome/themes/gtk.lua
echo 'local beautiful = require("beautiful")' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo '' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
sed -n '/-- Themes define colours/p' $where_is_awesome/rc.lua >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local my_theme = "gtk"' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
sed -n '/gears.filesystem.get_themes_dir/p' $where_is_awesome/rc.lua >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
sed -i '/gears.filesystem.get_themes_dir/d' $where_is_awesome/rc.lua
sed -i 's|gears.filesystem.get_themes_dir() .. "default/theme.lua"|string.format("%s/.config/awesome/themes/%s.lua", os.getenv("HOME"), my_theme)|g' $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
sed -i '/-- Themes define colours.*/d' $where_is_awesome/rc.lua
temp_var_for_theme_location="$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name"

temp_var_for_new_module_folder_name="main"
mkdir -p $where_is_awesome/$temp_var_for_new_module_folder_name
#Signals
temp_var_for_new_module_name="Signals"
echo '-- Standard awesome library' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local gears = require("gears")' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local awful = require("awful")' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local beautiful = require("beautiful")' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local wibox = require("wibox")' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo '' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
modularize_awesomeWM_rc_file "Signals" "$temp_var_for_new_module_name" "$temp_var_for_new_module_folder_name" "{"

#Rules
temp_var_for_new_module_name="Rules"
echo '-- Standard awesome library' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local awful = require("awful")' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local beautiful = require("beautiful")' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo '' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
modularize_awesomeWM_rc_file "Rules" "$temp_var_for_new_module_name" "$temp_var_for_new_module_folder_name" "{"

#keybindings
temp_var_for_new_module_name="keybindings"
echo '-- Standard awesome library' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local gears = require("gears")' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local awful = require("awful")' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local hotkeys_popup = require("awful.hotkeys_popup")' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo '' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
modularize_awesomeWM_rc_file "Key bindings" "$temp_var_for_new_module_name" "$temp_var_for_new_module_folder_name" "{"

#mousebindings
temp_var_for_new_module_name="mousebindings"
echo '-- Standard awesome library' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local gears = require("gears")' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local awful = require("awful")' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo '' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
modularize_awesomeWM_rc_file "Mouse bindings" "$temp_var_for_new_module_name" "$temp_var_for_new_module_folder_name" "{"

#Wibar
temp_var_for_new_module_name="Wibar"
echo '-- Standard awesome library' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local gears = require("gears")' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local awful = require("awful")' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local beautiful = require("beautiful")' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local wibox = require("wibox")' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo '' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
modularize_awesomeWM_rc_file "-- Keyboard map indicator and switcher" "$temp_var_for_new_module_name" "$temp_var_for_new_module_folder_name" 

#Menu
temp_var_for_new_module_name="Menu"
echo '-- Standard awesome library' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local gears = require("gears")' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local awful = require("awful")' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local menubar = require("menubar")' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local beautiful = require("beautiful")' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo '' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo '-- Load Debian menu entries' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local debian = require("debian.menu")' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local has_fdo, freedesktop = pcall(require, "freedesktop")' >> $where_is_awesome/$temp_var_for_new_module_folder_name/Menu.lua
echo ''
modularize_awesomeWM_rc_file "Menu" "$temp_var_for_new_module_name" "$temp_var_for_new_module_folder_name" "{"
sed -i '/-- Load Debian menu entries/d' $where_is_awesome/rc.lua
sed -i '/local debian = require("debian.menu")/d' $where_is_awesome/rc.lua
sed -i '/local has_fdo, freedesktop = pcall(require, "freedesktop")/d' $where_is_awesome/rc.lua

#Variable
temp_var_for_new_module_name="Variable"
echo '-- Standard awesome library' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local awful = require("awful")' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo '' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
modularize_awesomeWM_rc_file "Variable definitions" "$temp_var_for_new_module_name" "$temp_var_for_new_module_folder_name" "{"
temp_var_for_Variable_location="$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name"

#Errorhandling
temp_var_for_new_module_name="Errorhandling"
echo '-- Notification library' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local naughty = require("naughty")' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo '' >> $where_is_awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
modularize_awesomeWM_rc_file "Error handling" "$temp_var_for_new_module_name" "$temp_var_for_new_module_folder_name" "{"

#autostart
temp_var_for_new_module_folder_name="autostart"
mkdir -p $where_is_awesome/$temp_var_for_new_module_folder_name
curl -s https://raw.githubusercontent.com/dari862/my-linux-script/$temp_var_for_new_module_folder_name/Config/awesomewm/awspawn > $where_is_awesome/$temp_var_for_new_module_folder_name/awspawn
chmod +x $where_is_awesome/$temp_var_for_new_module_folder_name/awspawn
cat << EOF >> $where_is_awesome/$temp_var_for_new_module_folder_name/autorun.lua
local awful = require("awful")
awful.spawn.with_shell("~/.config/awesome/$temp_var_for_new_module_folder_name/awspawn")
awful.spawn.with_shell(screenshot)
EOF
echo 'require("'$temp_var_for_new_module_folder_name'/autorun")' >> $where_is_awesome/rc.lua

#extra stuff
# add require("theme-file") below require("Variable-file")
sed -i 's|require("'$temp_var_for_Variable_location'")|temp_var_for_Variable_location|g' $where_is_awesome/rc.lua
sed -i '/^temp_var_for_Variable_location/a temp_var_for_theme_location' $where_is_awesome/rc.lua
sed -i 's|temp_var_for_Variable_location|require("'$temp_var_for_Variable_location'")|g' $where_is_awesome/rc.lua
sed -i 's|temp_var_for_theme_location|require("'$temp_var_for_theme_location'")|g' $where_is_awesome/rc.lua

sed -i '/^[[:space:]]*$/d' $where_is_awesome/rc.lua # remove empty line in rc.lua
}

main_awesomeWM_now()
{
show_mf "configure_awesomewm_and_dependancy_now "
configure_awesomewm_and_dependancy_now
modularize_awesomeWM_rc_file_now
copy_awesome_2_skel
}



##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################
# bspwm
##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################

configuring_bspwm_now()
{
cp -r $temp_folder_for_bspwm/bspwm_config_files/dotfiles/* $temp_folder_for_skel_config
mv $temp_folder_for_skel_config/bspwm/bin $temp_folder_for_skel_/.local/bin/bspwm
}

main_bspwm_now()
{
show_mf "main_PreWM_now "
configuring_bspwm_now
}


##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################
# openbox
##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################

modify_openbox_menu_now()
{
if [ "$(find $temp_folder_for_openbox/dot_config_folder/openbox/menu-*.xml -type f 2> /dev/null)" ]
then
	if command -v "${install_QT_apps_[0]}" >/dev/null
	then
		Configure_QT_stuff_now
		find $temp_folder_for_openbox/dot_config_folder/openbox/menu-*.xml -type f -exec sed -i -e '/QT_ROOT_Menu/Id' -e '/QT_Normal_Menu/Id'  {} \;
	fi
	
	if command -v xfce4-appearance-settings >/dev/null
	then
		find $temp_folder_for_openbox/dot_config_folder/openbox/menu-*.xml -type f -exec sed -i -e 's/lxappearance/xfce4-appearance-settings/g' {} \;
	fi

	if ! command -v xfce4-settings-manager >/dev/null
	then
		find $temp_folder_for_openbox/dot_config_folder/openbox/menu-*.xml -type f -exec sed -i -e 's/xfce4-settings-manager/obconf/g' {} \;
	fi	
fi

if [ "$(find $temp_folder_for_openbox/dot_config_folder/openbox/* -type f \( -name "xfce4-*.xml" -o -name "menu.xml" \) 2> /dev/null)" ] 
then
	if [ "$(sudo dmesg | grep -qi bluetooth)" ]
	then
		find $temp_folder_for_openbox/dot_config_folder/openbox/* -type f \( -name "xfce4-*.xml" -o -name "menu.xml" \) -exec sed -i '/Bluetooth_session_script_/Id' {} \;
	fi
	
	if command -v virtualbox >/dev/null
	then
		find $temp_folder_for_openbox/dot_config_folder/openbox/* -type f \( -name "xfce4-*.xml" -o -name "menu.xml" \) -exec sed -i '/Virtual_Desktop_Software/Id' {} \;
	fi
fi

}

main_openbox_now()
{
show_mf "install and configure openbox"
show_m "install and configure openbox."

modify_openbox_menu_now

cd $temp_folder_for_openbox

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
# Copy autosnap script
chmod +x $temp_folder_for_usr_bin_/autosnap 
# Copy my-locker
chmod a+x $temp_folder_for_usr_bin_/my-locker

# Set as default
sudo update-alternatives --set x-session-manager /usr/bin/openbox-session

##################################################################show_m "add user 1000 to lpadmin group to manage CUPS printer system"
# INFO: CUPS is a printer system for config printers and printer queue
# INFO: Can be managed in http://localhost:631 and admin users must be in lpadmin group

user1000=$(cat /etc/passwd | cut -f 1,3 -d: | grep :1000$ | cut -f1 -d:)
[ "$user1000" ] && sudo adduser "$user1000" lpadmin

##################################################################show_m "Install theme Arc GTK ,icon theme Numix-Paper and set as default"
# INFO: Arc GTK theme is a clear and cool GTK theme
# Install packages

# Change accent color blue (#5294e2) for grey:
sudo find /usr/share/themes/Arc -type f -exec sed -i 's/#5294e2/#b3bcc6/g' {} \;   

# install Tela-icon-theme
$temp_folder_for_download/Tela-icon-theme/install.sh grey &>> $debug_log

#sed -i 's/^gtk-theme-name *= *.*/gtk-theme-name="'"Arc"'"/' "$temp_folder_for_skel_/.config/gtk-2.0/gtkrc-2.0"
#sed -i 's/^gtk-icon-theme-name *= *.*/gtk-icon-theme-name="'"Tela-grey"'"/'	"$temp_folder_for_skel_/.config/gtk-2.0/gtkrc-2.0"
#sed -i 's/^gtk-cursor-theme-name *= *.*/gtk-cursor-theme-name="'"DMZ-White"'"/' "$temp_folder_for_skel_/.config/gtk-2.0/gtkrc-2.0"
#sed -i 's/^gtk-toolbar-icon-size *= *.*/gtk-toolbar-icon-size="'"GTK_ICON_SIZE_SMALL_TOOLBAR"'"/' "$temp_folder_for_skel_/.config/gtk-2.0/gtkrc-2.0"
#sed -i 's/^gtk-xft-hintstyle *= *.*/gtk-xft-hintstyle="'"hintslight"'"/' "$temp_folder_for_skel_/.config/gtk-2.0/gtkrc-2.0"

#sed -i 's/^gtk-theme-name *= *.*/gtk-theme-name="'"Arc"'"/' "$temp_folder_for_skel_/.config/gtk-3.0/settings.ini"
#sed -i 's/^gtk-icon-theme-name *= *.*/gtk-icon-theme-name="'"Tela-grey"'"/'	"$temp_folder_for_skel_/.config/gtk-3.0/settings.ini"
#sed -i 's/^gtk-cursor-theme-name *= *.*/gtk-cursor-theme-name="'"DMZ-White"'"/' "$temp_folder_for_skel_/.config/gtk-3.0/settings.ini"
#sed -i 's/^gtk-toolbar-icon-size *= *.*/gtk-toolbar-icon-size="'"GTK_ICON_SIZE_SMALL_TOOLBAR"'"/' "$temp_folder_for_skel_/.config/gtk-3.0/settings.ini"
#sed -i 's/^gtk-xft-hintstyle *= *.*/gtk-xft-hintstyle="'"hintslight"'"/' "$temp_folder_for_skel_/.config/gtk-3.0/settings.ini"

##################################################################

show_m "openbox copy temp_folder_for_openbox files."
sudo chown root:root ${temp_folder_for_openbox}/usr_share_app/*
sudo mv ${temp_folder_for_openbox}/usr_share_app/* /usr/share/applications/
sudo chown -R root:root $temp_folder_for_usr_bin_
sudo cp -rv $temp_folder_for_usr_bin_/* "/usr/bin/"

sudo chown root:root -R $temp_folder_for_openbox/open_stuff
sudo mv $temp_folder_for_openbox/open_stuff /usr/share/

# Create welcome link
sudo ln -s /usr/bin/welcome "$temp_folder_for_skel_/.config/openbox/welcome"
}
