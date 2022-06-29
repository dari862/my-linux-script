#laptops
if [ "$is_this_laptop_" == "true" ]
then
declare -ag laptops_Array_now_=(
"light" "list of apps to be installed" ON
"powertop" "list of apps to be installed" ON
"tlp" "list of apps to be installed" ON
"xbacklight" "list of apps to be installed" OFF
)
fi

#base
declare -ag base_Array_now_=(
"apt-transport-https" "list of apps to be installed" ON
"linux-base" "list of apps to be installed" ON
"git" "list of apps to be installed" ON
"man-db" "list of apps to be installed" ON
"manpages" "list of apps to be installed" ON
"lsb-release" "list of apps to be installed" ON
"gnupg" "list of apps to be installed" ON
"inotify-tools" "list of apps to be installed" ON
"nano" "list of apps to be installed" ON
"xkill" "list of apps to be installed" ON
"ntfs-3g" "list of apps to be installed" ON
"exfat-utils" "list of apps to be installed" ON
)


if [ "$(lspci | grep -i nvidia | grep VGA -c)" != "0" ] ; then
	Nvidia_choose_content=("Nvidia" "list of apps to be installed" ON)
fi
if [ "$(lspci | grep -i amd | grep VGA -c)" != "0" ] ; then
	Amd_choose_content=("Amd" "list of apps to be installed" ON)
fi
if [ "$(lspci | grep -i intel | grep VGA -c)" != "0" ] ; then
	intel_choose_content=("Intel" "list of apps to be installed" ON)
fi
if [ "$DISTRO" == "Debian" ]; then
	btrfs_kernal_install=("Btrfs" "btrfs-tuning." "ON")
fi
#drivers
declare -ag drivers_Array_now_=(
"$my_cpu_vendor-microcode" "list of apps to be installed" ON
"firmware-linux-nonfree" "list of apps to be installed" ON
"${Nvidia_choose_content[@]}"
"${Amd_choose_content[@]}"
"${intel_choose_content[@]}"
"${btrfs_kernal_install[@]}"
"bluez-firmware" "list of apps to be installed" OFF
"firmware-iwlwifi" "list of apps to be installed" OFF
"firmware-linux" "list of apps to be installed" OFF
"firmware-linux-free" "list of apps to be installed" OFF
"firmware-realtek" "list of apps to be installed" OFF
)

#media and sound
declare -ag media_Array_now_=(
"pulseaudio" "list of apps to be installed" ON
"pulseaudio-utils" "list of apps to be installed" ON
"pavucontrol" "list of apps to be installed" ON
"pulseaudio-equalizer" "list of apps to be installed" ON
"gstreamer1.0-pulseaudio" "list of apps to be installed" ON
"alsa-utils" "list of apps to be installed" ON
"alsamixergui" "list of apps to be installed" ON
"alsaplayer-gtk" "list of apps to be installed" ON
"libao-common" "list of apps to be installed" ON
"libao-dev" "list of apps to be installed" ON
"libao4" "list of apps to be installed" ON
"libasound2" "list of apps to be installed" ON
"pulseaudio" "list of apps to be installed" OFF
"pulseaudio-utils" "list of apps to be installed" OFF
"pavucontrol" "list of apps to be installed" OFF
"pulseaudio-equalizer" "list of apps to be installed" OFF
"gstreamer1.0-pulseaudio" "list of apps to be installed" OFF
"alsa-utils" "list of apps to be installed" OFF
"alsamixergui" "list of apps to be installed" OFF
"alsaplayer-gtk" "list of apps to be installed" OFF
"libao-common" "list of apps to be installed" OFF
"libao-dev" "list of apps to be installed" OFF
"libao4" "list of apps to be installed" OFF
"libasound2" "list of apps to be installed" OFF
"v4l-utils" "list of apps to be installed" OFF
"mpv" "list of apps to be installed" OFF
"ffmpeg" "list of apps to be installed" OFF
"smplayer" "list of apps to be installed" OFF
"smplayer-themes" "list of apps to be installed" OFF
"mplayer" "list of apps to be installed" OFF
)

#codecs_list
declare -ag codecs_list_Array_now_=(
"gstreamer1.0-libav" "list of apps to be installed" OFF
"gstreamer1.0-plugins-bad" "list of apps to be installed" OFF
"gstreamer1.0-plugins-base" "list of apps to be installed" OFF
"gstreamer1.0-plugins-good" "list of apps to be installed" OFF
"gstreamer1.0-plugins-ugly" "list of apps to be installed" OFF
)

#internet
declare -ag internet_Array_now_=(
"wget" "list of apps to be installed" ON
"curl" "list of apps to be installed" ON
"Slack" "list of apps to be installed" OFF
"filezilla" "list of apps to be installed" OFF
"transmission" "list of apps to be installed" OFF
"transmission-gtk" "list of apps to be installed" OFF
"chromium" "list of apps to be installed" OFF
"thunderbird" "list of apps to be installed" OFF
"brave-browser" "list of apps to be installed" OFF
"google-chrome-stable" "list of apps to be installed" OFF
"librewolf" "list of apps to be installed" OFF
"Dropbox" "list of apps to be installed" OFF
)

# network
declare -ag Network_Array_now_=(
"ufw" "list of apps to be installed" ON
"smbclient" "list of apps to be installed" ON
"net-tools" "list of apps to be installed" ON
"network-manager" "list of apps to be installed" ON
"Avahi" "list of apps to be installed" OFF
"openssh-server" "list of apps to be installed" OFF
"nmap" "list of apps to be installed" OFF
"gvfs-backends" "list of apps to be installed" OFF
"gvfs" "list of apps to be installed" OFF
"network-manager-openvpn" "list of apps to be installed" OFF
"samba" "list of apps to be installed" OFF
"samba-common" "list of apps to be installed" OFF
"samba-libs" "list of apps to be installed" OFF
"cifs-utils" "list of apps to be installed" OFF
"wireshark" "list of apps to be installed" OFF
"iwd" "list of apps to be installed" OFF
"wireless-tools" "list of apps to be installed" OFF
"libnss-mdns" "list of apps to be installed" OFF
"wireguard-tools" "list of apps to be installed" OFF
)

if command -v apt >/dev/null
then
	onion_repos_choose_content=("use_onion_repos" "use onion debian repo." OFF)
fi

# Tor
declare -ag Tor_Network_Array_now_=(
"install_tor_stuff" "list of apps to be installed" OFF
"install_torbrowser" "list of apps to be installed" OFF
"${onion_repos_choose_content[@]}"
)

#desktop
declare -ag desktop_Array_now_=(
"unzip" "list of apps to be installed" ON
"gparted" "list of apps to be installed" ON
"p7zip" "list of apps to be installed" OFF
"unrar-free" "list of apps to be installed" OFF
"baobab" "list of apps to be installed" OFF
"timeshift" "list of apps to be installed" OFF
"flameshot" "list of apps to be installed" OFF
"lshw-gtk" "list of apps to be installed" OFF
"gufw" "list of apps to be installed" OFF
"shotwell" "list of apps to be installed" OFF
"stacer" "list of apps to be installed" OFF
"bleachbit" "list of apps to be installed" OFF
)

#office
declare -ag office_Array_now_=(
"zathura" "list of apps to be installed" ON
"evince" "list of apps to be installed" ON
"fonts-noto" "list of apps to be installed" ON
"fonts-noto-cjk" "list of apps to be installed" ON
"fonts-noto-cjk-extra" "list of apps to be installed" ON
"fonts-noto-color-emoji" "list of apps to be installed" ON
"fonts-noto-extra" "list of apps to be installed" ON
"fonts-noto-hinted" "list of apps to be installed" ON
"fonts-noto-mono" "list of apps to be installed" ON
"fonts-noto-unhinted" "list of apps to be installed" ON
"fonts-roboto" "list of apps to be installed" ON
"fonts-cantarell" "list of apps to be installed" ON
"fonts-dejavu" "list of apps to be installed" ON
"fonts-ubuntu" "list of apps to be installed" ON
"fonts-ubuntu-console" "list of apps to be installed" ON
"ttf-ubuntu-font-family" "list of apps to be installed" ON
"cups" "list of apps to be installed" OFF
"cups-pdf" "list of apps to be installed" OFF
"libreoffice" "list of apps to be installed" OFF
"ttf-mscorefonts-installer" "list of apps to be installed" OFF
"hplip" "list of apps to be installed" OFF
"hplip-gui" "list of apps to be installed" OFF
"gutenprint" "list of apps to be installed" OFF
"printer-driver-gutenprint" "list of apps to be installed" OFF
)

#dev
declare -ag dev_Array_now_=(
"build-essential" "list of apps to be installed" ON
"cmake" "list of apps to be installed" ON
"android_stuff" "install android" off
"GO" "install GO" off
"MVSC" "Microsoft Visual Studio Code" off
"IntelliJ" "IntelliJ IDEA Ultimate" off
"GoLand" "install GoLand" off
"Postman" "install Postman" off
"Docker" "install Docker" off
"Maven" "install Maven" off
"PyCharm" "install PyCharm (snap)" off
"Robo_3T" "install Robo 3T(snap)" off
"DataGrid" "install DataGrid" off
"Mongo_Shell" "install Mongo Shell & MongoDB Database Tools" off
)

#extra
if [ ! -f /System/Applications/komorebi ] 
then
	komorebi_choose_content=("komorebi" "list of apps to be installed" ON)
fi

declare -ag extra_Array_now_=(
"VirtualBox" "list of apps to be installed" ON
"atom" "list of apps to be installed" ON
"sublime-text" "list of apps to be installed" ON
"calibre" "list of apps to be installed" ON
"gimp" "list of apps to be installed" ON
"recordmydesktop" "list of apps to be installed" ON
"${komorebi_choose_content[@]}"
)

if [ "$is_flatpak_installed" != "true" ]
then
	Flatpak_choose_content=("flatpak" "install flatpak and flatpak apps." "ON")
fi
declare -ag alt_installer_Array_now_=(
"synaptic" "list of apps to be installed" ON
"Snap" "list of apps to be installed" ON
"${Flatpak_choose_content[@]}"
"python-pip" "list of apps to be installed" ON
"python3-pip" "list of apps to be installed" ON
)


if [ "$gnome_desktop_environment" == "true" ]; then
	GNOME_GAMING_MODE=("GameMode" "enable GNOME GameMode." "ON")
fi

if [ "$DISTRO" == "Ubuntu" ] && [ "$ubuntu_similar_DISTRO" == "true" ]; then
	lowlatency_kernal_install=("lowlatency" "install lowlatency." "ON")
fi
declare -ag gaming_Array_now_=(
"GameHub" "install Discord (note: snapd will be installed)." ON
"Discord" "install Discord (note: snapd will be installed)." ON
"${GNOME_GAMING_MODE[@]}"
"GOverlay" "install GOverlay." ON
"HeroicGamesLauncher" "install HeroicGamesLauncher." ON
"Lutris" "install Lutris." ON
"MangoHud" "install MangoHud." ON
"Minigalaxy" "install Minigalaxy." ON
"vkbasalt" "install vkbasalt." ON
"mumble" "install mumble." ON
"dosbox" "install dosbox." ON
"yabause" "install yabause." ON
"playonlinux" "install playonlinux." ON
"retroarch" "install retroarch." ON
"NoiseTorch" "install NoiseTorch." ON
"OBS_Studio" "install OBS_Studio." ON
"OpenRGB" "install OpenRGB." ON
"Piper" "install Piper." ON
"Polychromatic" "install Polychromatic." ON
"ProtonUp_Qt" "install ProtonUp_Qt (note: flatpak will be installed)." ON
"Steam" "install Steam." ON
"Wine" "install Wine." ON
"WineHQ" "install Wine." ON
"Extra" "install Wine." ON
"stella" "install Wine." ON
"${lowlatency_kernal_install[@]}"
"The_xanmod_kernel" "install The xanmod kernel." ON
)


# emulators
declare -ag emulators_Array_now_=(
"GameHub" "list of apps to be installed." ON
"GameHub" "list of apps to be installed." ON
"GameHub" "list of apps to be installed." ON
"GameHub" "list of apps to be installed." ON
"GameHub" "list of apps to be installed." ON
)
