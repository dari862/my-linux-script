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

# to fix 

fix brighness script

error: tray: Failed to put tray above 0x3800001 in the stack (XCB_MATCH (8))
