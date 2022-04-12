##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################
# gnome
##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################

make_folders_gnome_now()
{
mkdir -p $themesFolder_now
mkdir -p $themesFolder_now/Transparent-shell-theme
mkdir -p $themes_switcher_Folder_now
mkdir -p $themes_icons_Folder_now
mkdir -p $temp_folder_for_GNOME/WhiteSur-logscreen
sudo install -d $dest
}

gnome_configration_now()
{
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/']"

if [ "$DISTRO" != "Ubuntu" ] && [ "$ubuntu_similar_DISTRO" != "true" ]; then
show_m "create shortcut for terminal"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "'open Terminal'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "'<Primary><Alt>T'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "'/usr/bin/x-terminal-emulator'"
fi

show_m "add shortcut to terminal, flameshot and xkill "
gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot '[]'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name "'Take screenshot'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding "'Print'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command "'/usr/bin/flameshot gui'"

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name "'run xkill'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding "'<Primary><Alt>X'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command "'/usr/bin/xkill'"

gsettings set org.gnome.desktop.interface clock-format 12h
}

dash_to_dock_configration_now()
{

show_m "dash_to_dock_configration"
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32
gsettings set org.gnome.shell.extensions.dash-to-dock unity-backlit-items true
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
gsettings set org.gnome.shell.extensions.dash-to-dock apply-custom-theme false
}

GNOME_themes_configration_now()
{
###############################################
# nord_Themes_configration_now
###############################################
show_mf "Nordic Themes"
show_m "create Nordic-darker"
mv $temp_folder_for_GNOME/Nordic-darker $themesFolder_now

show_m "create Zafiro-Icons-Dark"
mv $temp_folder_for_GNOME/Zafiro-Icons-Dark $themes_icons_Folder_now

show_m "create Nordic-cursors"
cd $temp_folder_for_GNOME/Nordzy-cursors/
./install.sh &>> $debug_log

show_m "create nord Themes switcher"
cat <<EOF3 > $themes_switcher_Folder_now/nordic-darker.sh
gsettings set org.gnome.desktop.interface gtk-theme "Nordic-darker"
gsettings set org.gnome.desktop.wm.preferences theme "Nordic-darker"
gsettings set org.gnome.desktop.interface icon-theme 'Zafiro-Icons-Dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Nordzy-cursors'
gsettings set org.gnome.shell.extensions.user-theme name 'Nordic-darker'
gsettings set org.gnome.gedit.preferences.editor scheme 'nord-gedit'
gsettings set org.gnome.desktop.background picture-uri 'file:///home/$USER/.local/share/backgrounds/nord1.png'
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'DEFAULT'
gnome-extensions disable dash-to-panel@jderose9.github.com
#arcmenu
dconf reset -f /org/gnome/shell/extensions/arc-menu/
EOF3
chmod +x $themes_switcher_Folder_now/nordic-darker.sh
echo "gnome-extensions enable $dash2dock_OR_ubuntu2dock" >> $themes_switcher_Folder_now/nordic-darker.sh

###############################################
# Transparent_shell_Themes_configration_now
###############################################
show_mf "create Transparent shell Themes"

cp -R $themesFolder_now/Nordic-darker/gnome-shell $themesFolder_now/Transparent-shell-theme/gnome-shell
sed -i "s/background-color: #1d2128/background-color: rgba(0, 0, 0, 0)/g" $themesFolder_now/Transparent-shell-theme/gnome-shell/gnome-shell.css
show_m "Create themes-switcher"
cat <<EOF3-c > $themes_switcher_Folder_now/Transparent-shell.sh
gsettings set org.gnome.shell.extensions.user-theme name 'Transparent-shell-theme'
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode FIXED
gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0
EOF3-c
chmod +x $themes_switcher_Folder_now/Transparent-shell.sh

###############################################
# sweet_Themes_configration_now
###############################################
show_mf "sweet Themes"
show_m "Create sweet Dark"
mv $temp_folder_for_GNOME/Sweet-Dark $themesFolder_now

show_m "Create candy-icons"
does_folder_or_file_exsist_if_yes_remove "$themes_icons_Folder_now/candy-icons"
mv $temp_folder_for_GNOME/candy-icons $themes_icons_Folder_now

show_m "Create themes-switcher"
cat <<EOF4 > $themes_switcher_Folder_now/sweet-darker.sh
gsettings set org.gnome.desktop.interface gtk-theme "Sweet-Dark"
gsettings set org.gnome.desktop.wm.preferences theme "Sweet-Dark"
gsettings set org.gnome.desktop.interface icon-theme 'candy-icons'
gsettings set org.gnome.desktop.interface cursor-theme 'Nordzy-cursors'
gsettings set org.gnome.shell.extensions.user-theme name 'Sweet-Dark'
gsettings set org.gnome.gedit.preferences.editor scheme 'Classic'
gsettings set org.gnome.desktop.background picture-uri 'file:///home/$USER/.local/share/backgrounds/sweet3.png'
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'DEFAULT'
gnome-extensions disable dash-to-panel@jderose9.github.com
#arcmenu
dconf reset -f /org/gnome/shell/extensions/arc-menu/
EOF4
chmod +x $themes_switcher_Folder_now/sweet-darker.sh
echo "gnome-extensions enable $dash2dock_OR_ubuntu2dock" >> $themes_switcher_Folder_now/sweet-darker.sh

###############################################
# WhiteSur_Themes_configration_now
###############################################
show_mf "WhiteSur Themes"
show_m "Create WhiteSur-light"
mv $temp_folder_for_GNOME/WhiteSur-light $themesFolder_now
show_m "Create BigSur-icon-theme"
cd $temp_folder_for_GNOME/BigSur-icon-theme-*/
./install.sh -d $HOME/.icons &>> $debug_log

show_m "Create McMojave-cursors"
cd $temp_folder_for_GNOME/McMojave-cursors-*/
./install.sh &>> $debug_log

show_m "Create themes-switcher"
cat <<EOF4 > $themes_switcher_Folder_now/macosnow.sh
gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-light"
gsettings set org.gnome.desktop.wm.preferences theme "WhiteSur-light"
gsettings set org.gnome.desktop.interface icon-theme 'BigSur'
gsettings set org.gnome.desktop.interface cursor-theme 'McMojave-cursors'
gsettings set org.gnome.shell.extensions.user-theme name 'WhiteSur-light'
gsettings set org.gnome.gedit.preferences.editor scheme 'Classic'
gsettings set org.gnome.desktop.background picture-uri 'file:///home/$USER/.local/share/backgrounds/macOS6.png'
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'DEFAULT'
gnome-extensions disable dash-to-panel@jderose9.github.com
#arcmenu
dconf reset -f /org/gnome/shell/extensions/arc-menu/
EOF4
chmod +x $themes_switcher_Folder_now/macosnow.sh
echo "gnome-extensions enable $dash2dock_OR_ubuntu2dock" >> $themes_switcher_Folder_now/macosnow.sh

###############################################
# windows_10_Themes_configration_now
###############################################
#https://b00merang.weebly.com/
#https://aboominister.medium.com/how-to-make-ubuntu-linux-look-like-windows-10-bfb6795ccf91

show_mf "windows10 Themes"
show_m "Create Windows-10-theme"
mv $temp_folder_for_GNOME/Windows-10-themes/ $themesFolder_now/Windows-10

show_m "Create Windows-10-icons"
mv $temp_folder_for_GNOME/Windows-10-icons/ $themes_icons_Folder_now/Windows-10-icons

show_m "Create themes-switcher"
cat <<EOF4 > $themes_switcher_Folder_now/windows10.sh
gsettings set org.gnome.desktop.interface gtk-theme "Windows-10"
gsettings set org.gnome.desktop.wm.preferences theme "Windows-10"
gsettings set org.gnome.desktop.interface icon-theme 'Windows-10-icons'
gsettings set org.gnome.desktop.interface cursor-theme 'whiteglass'
gsettings set org.gnome.shell.extensions.user-theme name 'Windows-10'
gsettings set org.gnome.gedit.preferences.editor scheme 'Classic'
gsettings set org.gnome.desktop.background picture-uri 'file:///home/$USER/.local/share/backgrounds/win10-1.png'
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'DEFAULT'
gnome-extensions enable dash-to-panel@jderose9.github.com
#dash to panel
gsettings set org.gnome.shell.extensions.dash-to-panel appicon-margin 8
gsettings set org.gnome.shell.extensions.dash-to-panel appicon-padding 8
gsettings set org.gnome.shell.extensions.dash-to-panel show-show-apps-button false
gsettings set org.gnome.shell.extensions.dash-to-panel panel-size 48
#arcmenu
dconf reset -f /org/gnome/shell/extensions/arc-menu/
dconf write /org/gnome/shell/extensions/arc-menu/avatar-style "'Circular'"
dconf write /org/gnome/shell/extensions/arc-menu/dtp-dtd-state "[true, false]"
dconf write /org/gnome/shell/extensions/arc-menu/enable-custom-arc-menu-layout "true"
dconf write /org/gnome/shell/extensions/arc-menu/enable-horizontal-flip "true"
dconf write /org/gnome/shell/extensions/arc-menu/menu-button-icon "'System_Icon'"
dconf write /org/gnome/shell/extensions/arc-menu/menu-hotkey "'Super_L'"
dconf write /org/gnome/shell/extensions/arc-menu/menu-layout "'Redmond'"
dconf write /org/gnome/shell/extensions/arc-menu/pinned-app-list "['Firefox Web Browser', 'firefox', 'firefox.desktop', 'Terminal', 'utilities-terminal', 'org.gnome.Terminal.desktop', 'Arc Menu Settings', 'ArcMenu_ArcMenuIcon', 'gnome-extensions prefs arc-menu@linxgem33.com']"
dconf write /org/gnome/shell/extensions/arc-menu/reload-theme "false"
dconf write /org/gnome/shell/extensions/arc-menu/searchbar-location-redmond "'Bottom'"
EOF4
chmod +x $themes_switcher_Folder_now/windows10.sh
echo "gnome-extensions disable $dash2dock_OR_ubuntu2dock" >> $themes_switcher_Folder_now/windows10.sh

###############################################
# Orchis_Themes_configration_now
###############################################
show_mf "Orchis Themes"

show_m "create Vimix-cursors"
mv $temp_folder_for_GNOME/Vimix-cursors $themes_icons_Folder_now/
mv $temp_folder_for_GNOME/Vimix-white-cursors $themes_icons_Folder_now/

show_m "create Tela-circle-icon"
cd $temp_folder_for_GNOME/Tela-circle-icon-theme-*/
./install.sh -d $themes_icons_Folder_now &>> $debug_log

show_m "create Orchis-theme"
cd $temp_folder_for_GNOME/Orchis-theme-*/
./install.sh --tweaks solid --dest $themesFolder_now &>> $debug_log

show_m "Create themes-switcher"
cat <<EOF4 > $themes_switcher_Folder_now/Orchis.sh
gsettings set org.gnome.desktop.interface gtk-theme "Orchis-compact"
gsettings set org.gnome.desktop.wm.preferences theme "Orchis-compact"
gsettings set org.gnome.desktop.interface icon-theme 'Tela-circle'
gsettings set org.gnome.desktop.interface cursor-theme 'Vimiz-cursors'
gsettings set org.gnome.shell.extensions.user-theme name 'Orchis-compact'
gsettings set org.gnome.gedit.preferences.editor scheme 'Classic'
gsettings set org.gnome.desktop.background picture-uri 'file:///home/$USER/.local/share/backgrounds/Orchis-1.jpg'
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'DEFAULT'
gnome-extensions disable dash-to-panel@jderose9.github.com
#arcmenu
dconf reset -f /org/gnome/shell/extensions/arc-menu/
dconf write /org/gnome/shell/extensions/arc-menu/alphabetize-all-programs "true"
dconf write /org/gnome/shell/extensions/arc-menu/arc-menu-icon "29"
dconf write /org/gnome/shell/extensions/arc-menu/arc-menu-placement "'DTP'"
dconf write /org/gnome/shell/extensions/arc-menu/available-placement "[false, true, false]"
dconf write /org/gnome/shell/extensions/arc-menu/avatar-style "'Circular'"
dconf write /org/gnome/shell/extensions/arc-menu/border-color "'rgb(44,45,44)'"
dconf write /org/gnome/shell/extensions/arc-menu/button-padding "4"
dconf write /org/gnome/shell/extensions/arc-menu/custom-menu-button-icon-size "22.0"
dconf write /org/gnome/shell/extensions/arc-menu/default-menu-view-tognee "'Categories_List'"
dconf write /org/gnome/shell/extensions/arc-menu/disable-category-arrows "false"
dconf write /org/gnome/shell/extensions/arc-menu/disable-recently-installed-apps "false"
dconf write /org/gnome/shell/extensions/arc-menu/disable-searchbox-border "false"
dconf write /org/gnome/shell/extensions/arc-menu/disable-tooltips "false"
dconf write /org/gnome/shell/extensions/arc-menu/enable-clock-widget-raven "true"
dconf write /org/gnome/shell/extensions/arc-menu/enable-custom-arc-menu "true"
dconf write /org/gnome/shell/extensions/arc-menu/enable-horizontal-flip "false"
dconf write /org/gnome/shell/extensions/arc-menu/enable-large-icons "true"
dconf write /org/gnome/shell/extensions/arc-menu/enable-menu-button-arrow "false"
dconf write /org/gnome/shell/extensions/arc-menu/enable-sub-menus "false"
dconf write /org/gnome/shell/extensions/arc-menu/enable-ubuntu-homescreen "true"
dconf write /org/gnome/shell/extensions/arc-menu/enable-weather-widget-raven "true"
dconf write /org/gnome/shell/extensions/arc-menu/extra-categories "[(0, true), (1, true), (2, true), (3, true), (4, true)]"
dconf write /org/gnome/shell/extensions/arc-menu/gap-adjustment "0"
dconf write /org/gnome/shell/extensions/arc-menu/highlight-color "'rgba(37,87,214,0.721477)'"
dconf write /org/gnome/shell/extensions/arc-menu/highlight-foreground-color "'rgba(236,232,232,1)'"
dconf write /org/gnome/shell/extensions/arc-menu/hot-corners "'Default'"
dconf write /org/gnome/shell/extensions/arc-menu/indicator-color "'rgb(41, 165, 249)'"
dconf write /org/gnome/shell/extensions/arc-menu/indicator-text-color "'rgba(196, 196, 196, 0.3)'"
dconf write /org/gnome/shell/extensions/arc-menu/krunner-show-details "false"
dconf write /org/gnome/shell/extensions/arc-menu/menu-arrow-size "12"
dconf write /org/gnome/shell/extensions/arc-menu/menu-border-size "0"
dconf write /org/gnome/shell/extensions/arc-menu/menu-button-appearance "'Icon'"
dconf write /org/gnome/shell/extensions/arc-menu/menu-button-icon "'Arc_Menu_Icon'"
dconf write /org/gnome/shell/extensions/arc-menu/menu-color "'rgba(47,47,46,0.8)'"
dconf write /org/gnome/shell/extensions/arc-menu/menu-corner-radius "8"
dconf write /org/gnome/shell/extensions/arc-menu/menu-font-size "10"
dconf write /org/gnome/shell/extensions/arc-menu/menu-foreground-color "'rgb(198,194,194)'"
dconf write /org/gnome/shell/extensions/arc-menu/menu-height "550"
dconf write /org/gnome/shell/extensions/arc-menu/menu-layout "'Raven'"
dconf write /org/gnome/shell/extensions/arc-menu/menu-margin "24"
dconf write /org/gnome/shell/extensions/arc-menu/menu-width "290"
dconf write /org/gnome/shell/extensions/arc-menu/multi-lined-labels "true"
dconf write /org/gnome/shell/extensions/arc-menu/override-hot-corners "true"
dconf write /org/gnome/shell/extensions/arc-menu/position-in-panel "'Left'"
dconf write /org/gnome/shell/extensions/arc-menu/remove-menu-arrow "false"
dconf write /org/gnome/shell/extensions/arc-menu/right-panel-width "205"
dconf write /org/gnome/shell/extensions/arc-menu/separator-color "'rgb(37,87,214)'"
dconf write /org/gnome/shell/extensions/arc-menu/show-bookmarks "true"
dconf write /org/gnome/shell/extensions/arc-menu/show-external-devices "true"
dconf write /org/gnome/shell/extensions/arc-menu/vert-separator "true"
dconf write /org/gnome/shell/extensions/arc-menu/color-themes "[['ArcMenu Theme', 'rgba(28, 28, 28, 0.98)', 'rgba(211, 218, 227, 1)', 'rgb(63,62,64)', 'rgba(238, 238, 236, 0.1)', 'rgba(255,255,255,1)', 'rgb(63,62,64)', '9', '0', '0', '0', '0', 'false'], ['Dark Blue Theme', 'rgb(25,31,34)', 'rgb(189,230,251)', 'rgb(41,50,55)', 'rgb(41,50,55)', 'rgba(255,255,255,1)', 'rgb(41,50,55)', '9', '1', '5', '12', '24', 'true'], ['Light Blue Theme', 'rgb(255,255,255)', 'rgb(51,51,51)', 'rgb(235,235,235)', 'rgba(189,230,251,0.9)', 'rgba(89,89,89,1)', 'rgba(189,230,251,0.9)', '9', '1', '5', '12', '24', 'true'], ['ArcMenu Theme', 'rgba(28, 28, 28, 0.98)', 'rgba(211, 218, 227, 1)', 'rgb(63,62,64)', 'rgba(238, 238, 236, 0.1)', 'rgba(255,255,255,1)', 'rgb(63,62,64)', '9', '0', '0', '0', '0', 'false'], ['Dark Blue', 'rgb(25,31,34)', 'rgb(189,230,251)', 'rgb(41,50,55)', 'rgb(41,50,55)', 'rgba(255,255,255,1)', 'rgb(41,50,55)', '9', '1', '5', '12', '24', 'true'], ['Light Blue', 'rgb(255,255,255)', 'rgb(51,51,51)', 'rgb(235,235,235)', 'rgba(189,230,251,0.9)', 'rgba(89,89,89,1)', 'rgba(189,230,251,0.9)', '9', '1', '5', '12', '24', 'true'], ['Silk Desert', 'rgba(50,52,73,0.820946)', 'rgba(211, 218, 227, 1)', 'rgb(63,62,64)', 'rgba(238, 238, 236, 0.1)', 'rgba(255,255,255,1)', 'rgb(63,62,64)', '11', '0', '0', '0', '0', 'false'], ['Breeze', 'rgb(237,237,243)', 'rgb(36,36,40)', 'rgba(63,62,64,0.246622)', 'rgba(61,174,235,0.55)', 'rgb(36,36,40)', 'rgb(210,210,215)', '9', '1', '0', '0', '0', 'false'], ['Breeze Dark', 'rgb(49,53,61)', 'rgb(237,237,243)', 'rgba(63,62,64,0.246622)', 'rgba(61,174,235,0.55)', 'rgb(237,237,243)', 'rgb(65,69,73)', '9', '1', '0', '0', '0', 'false'], ['Dark Blue 2', 'rgb(50,52,61)', 'rgb(211,217,227)', 'rgba(211,217,227,0.2)', 'rgb(81,149,226)', 'rgba(255,255,255,1)', 'rgba(211,217,227,0.5)', '9', '1', '4', '0', '0', 'false'], ['Dark Orange', 'rgb(51,51,51)', 'rgb(226,224,221)', 'rgba(174,167,159,0.2)', 'rgb(233,84,32)', 'rgba(255,255,255,1)', 'rgba(233,84,32,0.5)', '9', '1', '4', '12', '24', 'true'], ['Light Orange', 'rgb(246,246,245)', 'rgb(76,76,76)', 'rgba(51,51,51,0.2)', 'rgb(233,84,32)', 'rgba(114,114,114,1)', 'rgba(233,84,32,0.5)', '9', '1', '4', '12', '24', 'true'], ['Blue Orange', 'rgb(44,62,80)', 'rgb(189,195,199)', 'rgba(189,195,199,0.2)', 'rgb(231,76,60)', 'rgba(227,233,237,1)', 'rgba(189,195,199,0.5)', '9', '1', '4', '0', '0', 'false'], ['Light Purple', 'rgb(237,245,252)', 'rgb(39,45,45)', 'rgba(39,45,45,0.2)', 'rgba(144,112,164,0.5)', 'rgba(77,83,83,1)', 'rgba(144,112,164,0.5)', '9', '1', '6', '0', '0', 'false'], ['Dark Green', 'rgb(27,34,36)', 'rgb(243,243,243)', 'rgba(46,149,130,0.2)', 'rgb(46,149,130)', 'rgba(255,255,255,1)', 'rgba(46,149,130,0.35)', '9', '1', '6', '0', '0', 'true'], ['Gray', 'rgb(142,142,142)', 'rgb(255,255,255)', 'rgb(63,62,64)', 'rgba(238, 238, 236, 0.1)', 'rgba(255,255,255,1)', 'rgb(63,62,64)', '11', '0', '0', '0', '0', 'false'], ['Terminal Green', 'rgba(28, 28, 28, 0.98)', 'rgb(17,164,40)', 'rgb(63,62,64)', 'rgba(17,164,40,0.641892)', 'rgba(255,255,255,1)', 'rgb(63,62,64)', '9', '0', '0', '0', '0', 'false'], ['Sky Clear', 'rgba(64,145,191,0.756757)', 'rgb(243,243,243)', 'rgb(63,62,64)', 'rgba(135,64,191,0.253378)', 'rgba(255,255,255,1)', 'rgb(63,62,64)', '9', '0', '0', '0', '0', 'false'], ['Ubi Purple', 'rgba(174,64,191,0.523649)', 'rgb(243,243,243)', 'rgb(63,62,64)', 'rgba(189,191,64,0.763514)', 'rgba(255,255,255,1)', 'rgb(63,62,64)', '9', '0', '0', '0', '0', 'false'], ['Shade', 'rgb(46,52,54)', 'rgb(186,189,182)', 'rgb(63,62,64)', 'rgb(85,87,83)', 'rgb(238,238,236)', 'rgb(63,62,64)', '9', '0', '0', '0', '0', 'false'], ['Red Shade', 'rgba(191,64,74,0.753378)', 'rgb(243,243,243)', 'rgb(63,62,64)', 'rgb(85,87,83)', 'rgb(238,238,236)', 'rgb(63,62,64)', '9', '0', '0', '0', '0', 'false'], ['Tilk Blue', 'rgba(74,179,228,0.716216)', 'rgb(243,243,243)', 'rgb(63,62,64)', 'rgb(85,87,83)', 'rgb(238,238,236)', 'rgb(63,62,64)', '9', '0', '0', '0', '0', 'false'], ['Green Blue', 'rgb(87,121,89)', 'rgb(189,230,251)', 'rgb(41,50,55)', 'rgb(41,50,55)', 'rgba(255,255,255,1)', 'rgb(41,50,55)', '9', '1', '5', '12', '24', 'true'], ['Gray Blue', 'rgb(136,138,133)', 'rgb(189,230,251)', 'rgb(41,50,55)', 'rgb(41,50,55)', 'rgba(255,255,255,1)', 'rgb(41,50,55)', '9', '1', '5', '12', '24', 'true'], ['Pastel', 'rgb(238,238,236)', 'rgb(46,52,54)', 'rgb(63,62,64)', 'rgb(233,185,110)', 'rgb(173,127,168)', 'rgb(63,62,64)', '9', '0', '0', '0', '0', 'false'], ['Pastel 2', 'rgb(238,238,236)', 'rgb(46,52,54)', 'rgb(63,62,64)', 'rgba(191,64,190,0.344595)', 'rgb(114,159,207)', 'rgb(63,62,64)', '9', '0', '0', '0', '0', 'false'], ['Pastel 3', 'rgb(238,238,236)', 'rgb(46,52,54)', 'rgb(63,62,64)', 'rgba(64,137,191,0.358108)', 'rgb(78,154,6)', 'rgb(63,62,64)', '9', '0', '0', '0', '0', 'false'], ['Pastel 4', 'rgb(238,238,236)', 'rgb(46,52,54)', 'rgb(63,62,64)', 'rgba(64,191,70,0.307432)', 'rgb(196,160,0)', 'rgb(63,62,64)', '9', '0', '0', '0', '0', 'false'], ['Dark Pastel', 'rgb(46,52,54)', 'rgb(243,243,243)', 'rgb(63,62,64)', 'rgb(233,185,110)', 'rgb(173,127,168)', 'rgb(63,62,64)', '9', '0', '0', '0', '0', 'false'], ['Dark Pastel 2', 'rgb(46,52,54)', 'rgb(243,243,243)', 'rgb(63,62,64)', 'rgba(191,64,190,0.344595)', 'rgb(114,159,207)', 'rgb(63,62,64)', '9', '0', '0', '0', '0', 'false'], ['Dark Pastel 3', 'rgb(46,52,54)', 'rgb(243,243,243)', 'rgb(63,62,64)', 'rgba(64,137,191,0.358108)', 'rgb(78,154,6)', 'rgb(63,62,64)', '9', '0', '0', '0', '0', 'false'], ['Dark Pastel 4', 'rgb(46,52,54)', 'rgb(243,243,243)', 'rgb(63,62,64)', 'rgba(64,191,70,0.307432)', 'rgb(196,160,0)', 'rgb(63,62,64)', '9', '0', '0', '0', '0', 'false'], ['Yellow Shade', 'rgb(196,160,0)', 'rgb(46,52,54)', 'rgb(63,62,64)', 'rgb(85,87,83)', 'rgb(238,238,236)', 'rgb(63,62,64)', '9', '0', '0', '0', '0', 'false'], ['Adapta', 'rgb(250,251,252)', 'rgb(34,45,50)', 'rgb(81,84,86)', 'rgba(0,150,136,0.121711)', 'rgba(72,83,88,1)', 'rgb(0,150,136)', '11', '0', '8', '12', '24', 'true'], ['Adapta Nokto', 'rgb(38,50,56)', 'rgb(205,215,218)', 'rgb(38,50,56)', 'rgba(125,131,134,0.207237)', 'rgba(243,253,255,1)', 'rgb(0,188,212)', '11', '0', '8', '12', '24', 'true'], ['Arc', 'rgb(245,246,247)', 'rgb(55,54,68)', 'rgba(82,148,226,0.903915)', 'rgba(56,55,68,0.0782918)', 'rgba(93,92,106,1)', 'rgb(82,148,226)', '11', '0', '8', '12', '24', 'true'], ['Arc Dark', 'rgb(56,60,74)', 'rgb(188,195,205)', 'rgba(82,148,226,0.903915)', 'rgba(188,195,205,0.188612)', 'rgba(226,233,243,1)', 'rgb(82,148,226)', '11', '0', '8', '12', '24', 'true'], ['McOS CTLina', 'rgba(243,243,243,0.841549)', 'rgb(32,32,32)', 'rgba(243,243,243,0.841549)', 'rgb(203,204,207)', 'rgba(70,70,70,1)', 'rgb(61,140,248)', '11', '0', '8', '12', '24', 'true'], ['McOS CTLina Dark', 'rgba(47,47,46,0.873239)', 'rgb(198,194,194)', 'rgb(44,45,44)', 'rgb(37,87,214)', 'rgba(236,232,232,1)', 'rgb(37,87,214)', '11', '0', '8', '12', '24', 'true'], ['Android Dark Blue', 'rgb(63,62,64)', 'rgb(243,243,243)', 'rgb(0,177,251)', 'rgba(237,250,12,0.35473)', 'rgba(255,255,255,1)', 'rgb(0,177,251)', '11', '0', '4', '12', '24', 'true'], ['Android Light Blue', 'rgb(255,255,255)', 'rgb(63,62,64)', 'rgb(0,177,251)', 'rgba(237,250,12,0.35473)', 'rgba(101,100,102,1)', 'rgb(0,177,251)', '11', '0', '4', '12', '24', 'true'], ['Android Light Green', 'rgb(255,255,255)', 'rgb(63,62,64)', 'rgb(4,149,90)', 'rgba(143,219,207,0.334459)', 'rgba(101,100,102,1)', 'rgb(237,250,12)', '11', '0', '4', '12', '24', 'true'], ['Android Dark Green', 'rgb(46,52,54)', 'rgb(243,243,243)', 'rgb(4,149,90)', 'rgba(143,219,207,0.334459)', 'rgba(255,255,255,1)', 'rgb(237,250,12)', '11', '0', '4', '12', '24', 'true'], ['Android Dark Yaru', 'rgb(46,52,54)', 'rgb(243,243,243)', 'rgb(189,86,53)', 'rgba(247,186,36,0.405405)', 'rgba(255,255,255,1)', 'rgb(189,86,53)', '11', '0', '4', '12', '24', 'true'], ['Android Light Yaru', 'rgb(255,255,255)', 'rgb(63,62,64)', 'rgb(189,86,53)', 'rgba(247,186,36,0.405405)', 'rgba(101,100,102,1)', 'rgb(189,86,53)', '11', '0', '4', '12', '24', 'true'], ['Adapta 4k Dark', 'rgb(49,59,67)', 'rgb(243,243,243)', 'rgb(4,149,90)', 'rgba(0,177,251,0.337838)', 'rgba(255,255,255,1)', 'rgb(4,149,90)', '11', '1', '4', '12', '24', 'true'], ['Adapta 4k Light', 'rgb(255,255,255)', 'rgb(46,52,54)', 'rgb(4,149,90)', 'rgba(0,177,251,0.337838)', 'rgba(84,90,92,1)', 'rgb(4,149,90)', '11', '1', '4', '12', '24', 'true'], ['Neon Yellow Punk', 'rgb(49,59,67)', 'rgb(237,250,12)', 'rgb(4,149,90)', 'rgba(0,177,251,0.337838)', 'rgba(248,255,109,1)', 'rgb(4,149,90)', '11', '1', '4', '12', '24', 'true'], ['Halo Dark Blue', 'rgba(49,59,67,0.841216)', 'rgb(243,243,243)', 'rgb(4,149,90)', 'rgba(0,177,251,0.337838)', 'rgba(255,255,255,1)', 'rgb(4,149,90)', '11', '1', '4', '12', '24', 'true'], ['Halo Dark Jade', 'rgba(24,81,58,0.875)', 'rgb(243,243,243)', 'rgb(4,149,90)', 'rgba(0,177,251,0.337838)', 'rgba(255,255,255,1)', 'rgb(4,149,90)', '11', '1', '4', '12', '24', 'true'], ['Halo Dark Amber', 'rgba(84,34,18,0.881757)', 'rgb(243,243,243)', 'rgb(247,186,36)', 'rgba(247,186,36,0.472973)', 'rgba(255,255,255,1)', 'rgb(247,186,36)', '11', '1', '4', '12', '24', 'true'], ['Elegant Purple Haze', 'rgba(41,1,31,0.881757)', 'rgb(243,243,243)', 'rgba(112,8,67,0.425676)', 'rgba(112,8,67,0.425676)', 'rgba(255,255,255,1)', 'rgb(176,52,139)', '11', '0', '4', '12', '24', 'true']]"
EOF4
chmod +x $themes_switcher_Folder_now/Orchis.sh
echo "gnome-extensions enable $dash2dock_OR_ubuntu2dock" >> $themes_switcher_Folder_now/Orchis.sh

show_m "add gnome extra for aliases"
if [ -f "$pimpmyterminalfolder/aliases" ]
then
cat <<EOF2 >> $pimpmyterminalfolder/aliases
# theme switcher aliases
alias now-nord="$themes_switcher_Folder_now/nordic-darker.sh"
alias now-sweet="$themes_switcher_Folder_now/sweet-darker.sh"
alias now-invisible="$themes_switcher_Folder_now/Transparent-shell.sh"
alias now-macos="$themes_switcher_Folder_now/macosnow.sh"
alias now-win10="$themes_switcher_Folder_now/windows10.sh"
alias now-orchis="$themes_switcher_Folder_now/Orchis.sh"

EOF2
else
touch -a ~/.bash_aliases
cat <<EOF2 >> ~/.bash_aliases
# theme switcher aliases
alias now-nord="$themes_switcher_Folder_now/nordic-darker.sh"
alias now-sweet="$themes_switcher_Folder_now/sweet-darker.sh"
alias now-invisible="$themes_switcher_Folder_now/Transparent-shell.sh"
alias now-macos="$themes_switcher_Folder_now/macosnow.sh"
alias now-win10="$themes_switcher_Folder_now/windows10.sh"
alias now-orchis="$themes_switcher_Folder_now/Orchis.sh"
EOF2
fi

show_m "move all icons and cursors to correct folder"
mv $HOME/.icons/* $themes_icons_Folder_now
rm -rdf $HOME/.icons

}

changelogscreennow_GNOME()
{
cd $temp_folder_for_GNOME/WhiteSur-logscreen
#EXTRACT
for r in $(gresource list $gresource_file_location); do
    t="${r/#\/org\/gnome\/shell\/}"
    mkdir -p $(dirname $t)
    gresource extract $gresource_file_location $r >$t
done

cd theme

if [[ -f gdm3.css ]]; then
GDM_RESOURCE_CONFIG_NAME="gdm3"
elif [[ -f gdm.css ]]; then
GDM_RESOURCE_CONFIG_NAME="gdm"
else
echo "
------------------------------------------------------------------
Sorry, Script is only for Ubuntu 20.04, Ubuntu 21.04 & 21.10 Only
Exiting...
------------------------------------------------------------------"
exit 1
fi

newwget https://raw.githubusercontent.com/dari862/my-linux-script/main/data/wallpaper/gdm-background
mv $GDM_RESOURCE_CONFIG_NAME.css original.css
echo '@import url("resource:///org/gnome/shell/theme/original.css");
#lockDialogGroup {
background: '$color' url("resource:///org/gnome/shell/theme/gdm-background");
background-repeat: no-repeat;
background-size: cover;
background-position: center; }' > $GDM_RESOURCE_CONFIG_NAME.css
cd ..

#CREATE_XML
extractedFiles=$(find "theme" -type f -printf "%P\n" | xargs -i echo "    <file>{}</file>")
cat <<EOF >"theme/custom-gdm-background.gresource.xml"
<?xml version="1.0" encoding="UTF-8"?>
<gresources>
  <gresource prefix="/org/gnome/shell/theme">
$extractedFiles
  </gresource>
</gresources>
EOF

cd theme
glib-compile-resources custom-gdm-background.gresource.xml
sudo chown root:root custom-gdm-background.gresource
sudo mv custom-gdm-background.gresource $dest
#SET_GRESOURCE
cd $dest
sudo update-alternatives --quiet --install /usr/share/gnome-shell/$GDM_RESOURCE_CONFIG_NAME-theme.gresource $GDM_RESOURCE_CONFIG_NAME-theme.gresource $dest/custom-gdm-background.gresource 0
sudo update-alternatives --quiet --set $GDM_RESOURCE_CONFIG_NAME-theme.gresource $dest/custom-gdm-background.gresource

}

changelogscreennow2_GNOME()
{

cd $temp_folder_for_GNOME/flat-remix-gnome
make && sudo make install

}

install_extra_gnomeshell_extensions_now()
{

show_m "install compiz-alike-windows-effect gnome-shell-extension"
if [ "$DISTRO" == "Ubuntu" ] || [ "$ubuntu_similar_DISTRO" == "true" ]; then
mkdir -p ~/.local/share/gnome-shell/extensions/
mv $temp_folder_for_GNOME/compiz-alike-windows-effect@hermes83.github.com ~/.local/share/gnome-shell/extensions/
else
sudo mkdir -p /usr/share/gnome-shell/extensions
cd $temp_folder_for_GNOME/
sudo chown root:root -R compiz-alike-windows-effect@hermes83.github.com
sudo mv compiz-alike-windows-effect@hermes83.github.com /usr/share/gnome-shell/extensions
fi

#https://github.com/vinceliuice
}

Create_autorun_at_login_to_enable_gnomeshell_extensions_now()
{
show_m "Create_autorun_at_login_to_enable_gnomeshell_extensions_now"
mkdir -p $HOME/.config/autostart
cat<< EOF > $HOME/.config/autostart/ddrrddrrddrrddrrddrrddrr_gnome
#!/bin/bash
sleep 5
run_gnome_themeing_one_time_script()
{
#gnome-extensions enable system-monitor@paradoxxx.zero.gmail.com
#gnome-extensions enable apps-menu@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
gnome-extensions enable arc-menu@linxgem33.com &>> $debug_log || gnome-extensions enable arcmenu@arcmenu.com &>> $debug_log 
gnome-extensions enable remove-dropdown-arrows@mpdeimos.com
gnome-extensions enable disconnect-wifi@kgshank.net
gnome-extensions enable compiz-alike-windows-effect@hermes83.github.com
$themes_switcher_Folder_now/nordic-darker.sh
rm $HOME/.config/autostart/ddrrddrrddrrddrrddrrddrr_gnome
rm $HOME/.config/autostart/ddrrddrrddrrddrrddrrddrr_gnome.desktop
}
run_gnome_themeing_one_time_script > $HOME/.config/autostart/gnome_themeing_one_time_script.log
EOF
chmod +x $HOME/.config/autostart/ddrrddrrddrrddrrddrrddrr_gnome

cat<< EOF > $HOME/.config/autostart/ddrrddrrddrrddrrddrrddrr_gnome.desktop
[Desktop Entry]
Name=GNOME-THEMEING-now
GenericName=GNOME-THEMEING-now
Exec=bash "$HOME/.config/autostart/ddrrddrrddrrddrrddrrddrr_gnome"
Terminal=false
Type=Application
X-GNOME-Autostart-enabled=true
OnlyShownIn=GNOME
NotShowIn=KDE
EOF
}

main_gnome_now()
{
show_mf "make_folders_gnome_now"
make_folders_gnome_now
show_mf "gnome_configration_now"
gnome_configration_now
show_mf "dash_to_dock_configration_now"
dash_to_dock_configration_now
show_mf "GNOME_themes_configration_now"
GNOME_themes_configration_now
show_mf "install_extra_gnomeshell_extensions_now"
install_extra_gnomeshell_extensions_now
#show_mf "changelogscreennow_GNOME"
#changelogscreennow_GNOME
show_mf "changelogscreennow2_GNOME"
changelogscreennow2_GNOME
Create_autorun_at_login_to_enable_gnomeshell_extensions_now
}

##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################
# KDE
##################################################################################################################################################
##################################################################################################################################################
##################################################################################################################################################

KDE_themes_configration_now()
{
show_m "configure Nordic KDE theme and Sweet KDE theme"
cd $temp_folder_for_KDE
sudo mv kde/sddm/* /usr/share/sddm/themes
sudo rm -rdf kde/sddm
mv kde/kvantum ~/.config/Kvantum
mv kde/* ~/.local/share/

show_m "install new theme color"
mkdir -p ~/.kde/share/apps/color-schemes
mv $temp_folder_for_KDE/Nature.colors ~/.kde/share/apps/color-schemes/Nature.colors
cp -r ~/.kde/share/apps/color-schemes/Nature.colors ~/.local/share/color-schemes

show_m "install new icons"
mkdir -p $themes_icons_Folder_now
does_folder_or_file_exsist_if_yes_remove "$themes_icons_Folder_now/candy-icons"
mv $temp_folder_for_KDE/candy-icons $themes_icons_Folder_now

show_m "install ROUNDED-COLOR plasma theme "
mkdir -p ~/.local/share/plasma/desktoptheme
mv $temp_folder_for_KDE/ROUNDED-COLOR ~/.local/share/plasma/desktoptheme

show_m "autostart latte-dock for kde only"
mkdir -p $HOME/.config/autostart
cp /usr/share/applications/org.kde.latte-dock.desktop  ~/.config/autostart
echo 'OnlyShownIn=KDE' >> ~/.config/autostart/org.kde.latte-dock.desktop
echo 'NotShowIn=GNOME' >> ~/.config/autostart/org.kde.latte-dock.desktop

mkdir -p $HOME/.local/share/konsole
mkdir -p $HOME/.config/Kvantum/
}

install_and_configre_widget_now()
{
show_m "install and configre some widget and rules"
mkdir -p ~/.local/share/plasma/plasmoids/
mv $temp_folder_for_KDE/org.communia.apptitle ~/.local/share/plasma/plasmoids/
mv $temp_folder_for_KDE/org.kde.plasma.betterinlineclock ~/.local/share/plasma/plasmoids/

cd $temp_folder_for_KDE
plasmapkg2 -t kwinscript -i krohnkite-0.7.kwinscript
mv lattewindowcolors ~/.local/share/kwin/scripts/

mkdir -p ~/.local/share/kservices5/
ln -s ~/.local/share/kwin/scripts/krohnkite/metadata.desktop ~/.local/share/kservices5/krohnkite.desktop

cat <<EOF > ~/.config/kwinrulesrc
[1]
Description=hide title bar
noborder=true
noborderrule=2
wmclass=.*
wmclasscomplete=false
wmclassmatch=3

[General]
count=1
EOF

}

changelogscreennow_kde()
{
#remove panel
#splashscreen
show_m "Changing KDE login screen to nordic "

sudo cat <<EOF2 > $foldertempfornow/kde_settings.conf
[Autologin]
Relogin=false
Session=
User=

[General]
HaltCommand=
RebootCommand=

[Theme]
Current=Nordic

[Users]
MaximumUid=60000
MinimumUid=1000
EOF2
sudo chown root:root $foldertempfornow/kde_settings.conf
sudo mkdir -p /etc/sddm.conf.d/
sudo mv $foldertempfornow/kde_settings.conf /etc/sddm.conf.d/kde_settings.conf
}

Create_autorun_at_login_to_configure_kde_theme_now()
{
mkdir -p $HOME/.config/autostart-scripts

cat<< EOFEOFEOF > $HOME/.config/autostart-scripts/ddrrddrrddrrddrrddrrddrr_KDE
#!/bin/bash
zenity --info --text="in 15 sec nordic theme and lattedock theme will be applyed this massge is one time massage" --no-wrap
sleep 15
KDE_themeing_one_time_script()
{
#configure konsole
cat <<EOF > ~/.local/share/konsole/My-Profile.profile
[Appearance]
ColorScheme=Sweet-Mars

[General]
Name=My-Profile
Parent=FALLBACK/
EOF

cat <<EOF > ~/.config/konsolerc
[Desktop Entry]
DefaultProfile=My-Profile.profile
EOF

cat <<EOF > ~/.config/Kvantum/kvantum.kvconfig
[General]
theme=Nordic-Darker
EOF

#change wallpaper
kwriteconfig5 --file plasma-org.kde.plasma.desktop-appletsrc --group Containments --group 1 --group Wallpaper --group org.kde.image --group General --key Image "file:///home/$USER/.local/share/wallpapers/nord10.png"

# Script-krohnkite for tailling window
kwriteconfig5 --file kwinrc --group Plugins --key krohnkiteEnabled true
kwriteconfig5 --file kwinrc --group Script-krohnkite --key screenGapBottom 10
kwriteconfig5 --file kwinrc --group Script-krohnkite --key screenGapLeft 10
kwriteconfig5 --file kwinrc --group Script-krohnkite --key screenGapRight 10
kwriteconfig5 --file kwinrc --group Script-krohnkite --key screenGapTop 10
kwriteconfig5 --file kwinrc --group Script-krohnkite --key tileLayoutGap 10

# effects
kwriteconfig5 --file kwinrc --group Plugins --key lattewindowcolorsEnabled true
kwriteconfig5 --file kwinrc --group Plugins --key blurEnabled true
kwriteconfig5 --file kwinrc --group Effect-Blur --key NoiseStrength 0

# nordic theme
lookandfeeltool -a Nordic

# Sweet-Mars-transparent theme
kwriteconfig5 --file kwinrc --group org.kde.kdecoration2 --key theme __aurorae__svg__Sweet-Mars-transparent

# ROUNDED theme
kwriteconfig5 --file plasmarc --group Theme --key name ROUNDED-COLOR

# latte-dock theme
wget -P $HOME/.config/latte https://raw.githubusercontent.com/dari862/my-linux-script/main/data/dari.layout.latte
sleep 1
qdbus org.kde.lattedock /Latte switchToLayout "dari"

# remove KDE plasma panel
cp ~/.config/plasma-org.kde.plasma.desktop-appletsrc ~/.config/plasma-org.kde.plasma.desktop-appletsrc.backup
kwriteconfig5 --file plasma-org.kde.plasma.desktop-appletsrc --group Containments --group 2 --key plugin ""

# enable 4x virtual desktops
kwriteconfig5 --file kwinrc --group Desktops --key Name_2 "Desktops 2"
kwriteconfig5 --file kwinrc --group Desktops --key Name_3 "Desktops 3"
kwriteconfig5 --file kwinrc --group Desktops --key Name_4 "Desktops 4"
kwriteconfig5 --file kwinrc --group Desktops --key Number "4"

# change kde default applications
kwriteconfig5 --file kdeglobals --group 'General' --key 'TerminalApplication' 'kitty'
kwriteconfig5 --file kdeglobals --group 'General' --key 'BrowserApplication' 'firefox.desktop'

# change terminal shortcut to x-terminal-emulator
kwriteconfig5 --file khotkeysrc --group Data_1_2Actions0 --key Type COMMAND_URL
kwriteconfig5 --file khotkeysrc --group Data_1_2Actions0 --key CommandURL /usr/bin/x-terminal-emulator
kwriteconfig5 --file khotkeysrc --group Data_1_2 --key Name Launch Terminal
kwriteconfig5 --file khotkeysrc --group Data_1_2 --key Comment Global keyboard shortcut to launch Terminal
rm $HOME/.config/autostart-scripts/ddrrddrrddrrddrrddrrddrr_KDE
}
KDE_themeing_one_time_script > $HOME/.config/autostart/KDE_themeing_one_time_script.log
EOFEOFEOF
chmod +x $HOME/.config/autostart-scripts/ddrrddrrddrrddrrddrrddrr_KDE
}

main_kde_now()
{
show_mf "KDE_themes_configration_now"
KDE_themes_configration_now
show_mf "install_and_configre_widget_now"
install_and_configre_widget_now
show_mf "changelogscreennow_kde"
changelogscreennow_kde
show_mf "Create_autorun_at_login_to_configure_kde_theme_now"
Create_autorun_at_login_to_configure_kde_theme_now
}
