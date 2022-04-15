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
mkdir -p ~/.config/gtk-3.0
mv $temp_folder_for_preWM/preWM_config_files/gtk-3.0/* ~/.config/gtk-3.0 && rm -rdf $temp_folder_for_preWM/preWM_config_files/gtk-3.0 || echo "falied to move all gtk-3.0 files"
mv $temp_folder_for_preWM/preWM_config_files/* ~/.config &> /dev/null || echo "falied to move all preWM_config_files files"
if [ -z "$(ls -A $temp_folder_for_preWM/preWM_config_files)" ]; then
   echo "preWM_config_files copyed without any errors"
else
   ls -aR $temp_folder_for_preWM/preWM_config_files > $missing_content_from_preWM_config_files && show_em "falied to move all preWM_config_files files"
fi

if [ "$virtual_machine" == "true" ]
then
   sed -i 's|# vsync = false|vsync = false;|g' ~/.config/picom.conf
   sed -i 's|vsync = true;|# vsync = true|g' ~/.config/picom.conf
fi

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

cd
rm_if_link "$HOME/.Xresources"
ln -s $HOME/.config/x11/xresources .Xresources

}

main_PreWM_now()
{
show_mf "Pre-WM."
configure_PreWM_now
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

mkdir -p ~/.config/awesome
cp /etc/xdg/awesome/rc.lua ~/.config/awesome

#sed -i 's/terminal = "x-terminal-emulator"/local terminal = "x-terminal-emulator"/g' ~/.config/awesome/rc.lua
#sed -i 's/editor = os.getenv/local editor = os.getenv/g' ~/.config/awesome/rc.lua
#sed -i 's/editor_cmd = /local editor_cmd = /g' ~/.config/awesome/rc.lua

sed -i '/^-- {{{ Variable definitions/a -- Var for Applications' ~/.config/awesome/rc.lua
sed -i '/^-- Var for Applications/a filesmanagerr = "pcmanfm"' ~/.config/awesome/rc.lua
sed -i '/^-- Var for Applications/a screenshot = "flameshot"' ~/.config/awesome/rc.lua
sed -i '/^-- Var for Applications/a browser = "firefox"' ~/.config/awesome/rc.lua

sed -i 's/modkey = /modkey = /g' ~/.config/awesome/rc.lua
sed -i 's/"Mod4"/"Mod1"/g' ~/.config/awesome/rc.lua

sed -i '/^-- {{{ Variable definitions/a titlebars_status_now = false' ~/.config/awesome/rc.lua
sed -i 's/properties = { titlebars_enabled = true }/properties = { titlebars_enabled = titlebars_status_now }/g' ~/.config/awesome/rc.lua

sed -i 's/awful.screen.focused().mypromptbox:run()/awful.util.spawn("dmenu_run")/g' ~/.config/awesome/rc.lua

# work on awful.layout.layouts
# add https://github.com/Elv13/collision

sed -i 's/awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }/awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }/g' ~/.config/awesome/rc.lua

cat << EOF > ffffffff.txt
    awful.key({ modkey }, "b", function () awful.spawn(browser) end,
              {description = "run browser", group = "launcher"}),

    -- User File manager
    awful.key({ modkey }, "b", function () awful.spawn(filesmanagerr) end,
              {description = "launch File manager", group = "launcher"}),
			  
    -- Dmenu  
EOF
sed -i '/-- Prompt/ r ffffffff.txt' ~/.config/awesome/rc.lua	  
sed -i 's/-- Prompt/-- User browser/g' ~/.config/awesome/rc.lua
rm ffffffff.txt

sed -i '/^-- {{{ Variable definitions/a sloppy_focuss_enabled = false' ~/.config/awesome/rc.lua
sed -i '/^-- Enable sloppy focus/{N;N;N;s/$/\nend/}' ~/.config/awesome/rc.lua
sed -i '/^-- Enable sloppy focus/a then' ~/.config/awesome/rc.lua
sed -i '/^-- Enable sloppy focus/a if sloppy_focuss_enabled' ~/.config/awesome/rc.lua

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
mkdir -p ~/.config/awesome/$temp_var_for_new_module_folder_name
cp /usr/share/awesome/themes/gtk/theme.lua ~/.config/awesome/themes/gtk.lua
sed -i 's/theme.useless_gap   = dpi(3)/theme.useless_gap   = dpi(5)/g' ~/.config/awesome/themes/gtk.lua
echo 'local beautiful = require("beautiful")' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo '' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
sed -n '/-- Themes define colours/p' ~/.config/awesome/rc.lua >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local my_theme = "gtk"' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
sed -n '/gears.filesystem.get_themes_dir/p' ~/.config/awesome/rc.lua >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
sed -i '/gears.filesystem.get_themes_dir/d' ~/.config/awesome/rc.lua
sed -i 's|gears.filesystem.get_themes_dir() .. "default/theme.lua"|string.format("%s/.config/awesome/themes/%s.lua", os.getenv("HOME"), my_theme)|g' ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
sed -i '/-- Themes define colours.*/d' ~/.config/awesome/rc.lua
temp_var_for_theme_location="$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name"

temp_var_for_new_module_folder_name="main"
mkdir -p ~/.config/awesome/$temp_var_for_new_module_folder_name
#Signals
temp_var_for_new_module_name="Signals"
echo '-- Standard awesome library' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local gears = require("gears")' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local awful = require("awful")' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local beautiful = require("beautiful")' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local wibox = require("wibox")' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo '' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
modularize_awesomeWM_rc_file "Signals" "$temp_var_for_new_module_name" "$temp_var_for_new_module_folder_name" "{"

#Rules
temp_var_for_new_module_name="Rules"
echo '-- Standard awesome library' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local awful = require("awful")' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local beautiful = require("beautiful")' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo '' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
modularize_awesomeWM_rc_file "Rules" "$temp_var_for_new_module_name" "$temp_var_for_new_module_folder_name" "{"

#keybindings
temp_var_for_new_module_name="keybindings"
echo '-- Standard awesome library' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local gears = require("gears")' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local awful = require("awful")' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local hotkeys_popup = require("awful.hotkeys_popup")' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo '' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
modularize_awesomeWM_rc_file "Key bindings" "$temp_var_for_new_module_name" "$temp_var_for_new_module_folder_name" "{"

#mousebindings
temp_var_for_new_module_name="mousebindings"
echo '-- Standard awesome library' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local gears = require("gears")' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local awful = require("awful")' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo '' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
modularize_awesomeWM_rc_file "Mouse bindings" "$temp_var_for_new_module_name" "$temp_var_for_new_module_folder_name" "{"

#Wibar
temp_var_for_new_module_name="Wibar"
echo '-- Standard awesome library' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local gears = require("gears")' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local awful = require("awful")' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local beautiful = require("beautiful")' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local wibox = require("wibox")' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo '' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
modularize_awesomeWM_rc_file "-- Keyboard map indicator and switcher" "$temp_var_for_new_module_name" "$temp_var_for_new_module_folder_name" 

#Menu
temp_var_for_new_module_name="Menu"
echo '-- Standard awesome library' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local gears = require("gears")' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local awful = require("awful")' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local menubar = require("menubar")' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local beautiful = require("beautiful")' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo '' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo '-- Load Debian menu entries' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local debian = require("debian.menu")' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local has_fdo, freedesktop = pcall(require, "freedesktop")' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/Menu.lua
echo ''
modularize_awesomeWM_rc_file "Menu" "$temp_var_for_new_module_name" "$temp_var_for_new_module_folder_name" "{"
sed -i '/-- Load Debian menu entries/d' ~/.config/awesome/rc.lua
sed -i '/local debian = require("debian.menu")/d' ~/.config/awesome/rc.lua
sed -i '/local has_fdo, freedesktop = pcall(require, "freedesktop")/d' ~/.config/awesome/rc.lua

#Variable
temp_var_for_new_module_name="Variable"
echo '-- Standard awesome library' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local awful = require("awful")' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo '' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
modularize_awesomeWM_rc_file "Variable definitions" "$temp_var_for_new_module_name" "$temp_var_for_new_module_folder_name" "{"
temp_var_for_Variable_location="$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name"

#Errorhandling
temp_var_for_new_module_name="Errorhandling"
echo '-- Notification library' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo 'local naughty = require("naughty")' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
echo '' >> ~/.config/awesome/$temp_var_for_new_module_folder_name/$temp_var_for_new_module_name.lua
modularize_awesomeWM_rc_file "Error handling" "$temp_var_for_new_module_name" "$temp_var_for_new_module_folder_name" "{"

#autostart
temp_var_for_new_module_folder_name="autostart"
mkdir -p ~/.config/awesome/$temp_var_for_new_module_folder_name
curl -s https://raw.githubusercontent.com/dari862/my-linux-script/$temp_var_for_new_module_folder_name/Config/awesomewm/awspawn > ~/.config/awesome/$temp_var_for_new_module_folder_name/awspawn
chmod +x ~/.config/awesome/$temp_var_for_new_module_folder_name/awspawn
cat << EOF >> ~/.config/awesome/$temp_var_for_new_module_folder_name/autorun.lua
local awful = require("awful")
awful.spawn.with_shell("~/.config/awesome/$temp_var_for_new_module_folder_name/awspawn")
awful.spawn.with_shell(screenshot)
EOF
echo 'require("'$temp_var_for_new_module_folder_name'/autorun")' >> ~/.config/awesome/rc.lua

#extra stuff
# add require("theme-file") below require("Variable-file")
sed -i 's|require("'$temp_var_for_Variable_location'")|temp_var_for_Variable_location|g' ~/.config/awesome/rc.lua
sed -i '/^temp_var_for_Variable_location/a temp_var_for_theme_location' ~/.config/awesome/rc.lua
sed -i 's|temp_var_for_Variable_location|require("'$temp_var_for_Variable_location'")|g' ~/.config/awesome/rc.lua
sed -i 's|temp_var_for_theme_location|require("'$temp_var_for_theme_location'")|g' ~/.config/awesome/rc.lua

sed -i '/^[[:space:]]*$/d' $HOME/.config/awesome/rc.lua # remove empty line in rc.lua
}

main_awesomeWM_now()
{
show_mf "configure_awesomewm_and_dependancy_now "
configure_awesomewm_and_dependancy_now
modularize_awesomeWM_rc_file_now
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
cp -r $temp_folder_for_bspwm/bspwm_config_files/dotfiles/* /home/$USER/.config/
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

##################################################################show_m "Install script autosnap for half-maximize windows with mouse middle click in titlebar" 
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
show_m "Install script poweroff_last for auto-poweroff if no users logged in 20 minutes"
# INFO: Automatic poweroff may be useful in public or shared computers to avoid left computers ON needlessly

sudo bash "$temp_folder_for_openbox/autopoweroff" -I 20

##################################################################
show_m "openbox copy temp_folder_for_openbox files."
sudo chown root:root ${temp_folder_for_openbox}/usr_share_app/*
sudo mv ${temp_folder_for_openbox}/usr_share_app/* /usr/share/applications/
sudo chown -R root:root $temp_folder_for_usr_bin_
sudo cp -rv $temp_folder_for_usr_bin_/* "/usr/bin/"

# Create welcome link
sudo ln -s /usr/bin/welcome "/$temp_folder_for_skel_/.config/openbox/welcome"
}
