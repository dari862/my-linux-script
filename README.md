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

# old polybar

error: module/backlight: Could not get data (err: XCB_NAME (15))

error: Disabling module "backlight" (reason: Not supported for "eDP-1")

error: tray: Failed to put tray above 0x3800001 in the stack (XCB_MATCH (8))

# new polybar

add tray

# cut docky hacks

error: Disabling module "temperature" (reason: The file '/sys/devices/pci0000:00/0000:00:01.3/0000:01:00.0/hwmon/hwmon0/temp1_input' does not exist)

# forest grayblocks

error: module/backlight: Could not get data (err: XCB_NAME (15))

error: Disabling module "backlight" (reason: Not supported for "HDMI-1")

