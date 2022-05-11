experimental

# my-linux-script

bash <(wget -q -O - https://raw.githubusercontent.com/dari862/my-linux-script/main/installer.sh)

bash <(curl -s https://raw.githubusercontent.com/dari862/my-linux-script/main/installer.sh)

# my-linux-script (Debugging)

bash <(wget -q -O - https://raw.githubusercontent.com/dari862/my-linux-script/main/debugging.sh)

bash <(curl -s https://raw.githubusercontent.com/dari862/my-linux-script/main/debugging.sh)

# to do

number of installed appes : echo $(( $(dpkg-query -l | wc -l) - 5 ))

work on bspwm

https://xerolinux.xyz/

https://github.com/erikdubois/arcolinux-nemesis

https://github.com/adi1090x/polybar-themes



sed -n '/<keyboard>/,/\/keyboard/p' rc.xml | grep -e '<keybind key=' -e '<action name="' -e '<!--' -e '<command>' -e '<menu>' | grep -v '<action name="ShowMenu">' | grep -v '<!-- #DEBIAN-OPENBOX-autosnap -->' | grep -v '<action name="Execute">' | grep -v '<action name="MaximizeVert"/>' | grep -v '<action name="MoveResizeTo">' | grep -v '<action name="MoveToEdgeWest"/>' | grep -v '<action name="Focus"/>' | grep -v '<action name="UnshadeRaise"/>' | sed 's/<keybind key="/\nkeybind_new_line/g' | sed 's/<command>/\ntab_plz/g' | sed 's/<action name="/\ntab_plz/g' | sed 's/<action name="<menu>/\ntab_plz/g' | sed 's/<!-- /\n------------------------\n/g' | sed 's/-->/\n------------------------\n/g' > 123
