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
