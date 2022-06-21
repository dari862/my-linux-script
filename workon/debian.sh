function install_timed_backgrounds {
https://github.com/adi1090x/dynamic-wallpaper
https://github.com/saint-13/Linux_Dynamic_Wallpapers

}

##################################################################################################
# Install fixed libxft library to /usr/lib/
install_libxft() {
cd /tmp/
git clone https://github.com/uditkarode/libxft-bgra
cd libxft-bgra/
sh autogen.sh --sysconfdir=/etc --prefix=/usr --mandir=/usr/share/man
sudo make install

# Link fixed files
sudo rm /usr/lib/x86_64-linux-gnu/libXft.so.2.3.3 || true
sudo rm /usr/lib/x86_64-linux-gnu/libXft.so.2 || true
sudo rm /usr/lib/x86_64-linux-gnu/libXft.so || true

sudo ln -s /usr/lib/libXft.so.2.3.3 /usr/lib/x86_64-linux-gnu/libXft.so.2.3.3
sudo ln -s /usr/lib/libXft.so.2.3.3 /usr/lib/x86_64-linux-gnu/libXft.so.2
sudo ln -s /usr/lib/libXft.so.2.3.3 /usr/lib/x86_64-linux-gnu/libXft.so
}

install_librewolf() {
echo "deb [arch=amd64] http://deb.librewolf.net $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/librewolf.list
sudo wget https://deb.librewolf.net/keyring.gpg -O /etc/apt/trusted.gpg.d/librewolf.gpg
sudo apt update
sudo apt install librewolf -y
 }
 
function install_network {
  networking="${dir}/packages/network.list"
  nmconf="/etc/NetworkManager/NetworkManager.conf"
  show_header "Setting up networking."
  check_installed "${networking}"
  check_fail
  show_success "Networking applications installed."

  show_info "Setting up MAC address randomization in Network Manager."
  if ! test "$(grep "mac-address=random" ${nmconf})"; then
    sudo sh -c "echo "" >> ${nmconf}"
    sudo sh -c "echo '# Enabling built-in MAC Address randomization' >> ${nmconf}"
    sudo sh -c "echo '[connection-mac-randomization]' >> ${nmconf}"
    sudo sh -c "echo 'wifi.cloned-mac-address=random' >> ${nmconf}"
    sudo sh -c "echo 'ethernet.cloned-mac-address=random' >> ${nmconf}"
  fi

  show_info "Disabling SSH root login and forcing SSH v2."
  sudo sed -i \
    -e "/^#PermitRootLogin prohibit-password$/a PermitRootLogin no" \
    -e "/^#Port 22$/i Protocol 2" \
    /etc/ssh/sshd_config
}

function install_discovery {
  discovery="${dir}/packages/discover.list"
  nsconf="/etc/nsswitch.conf"
  show_header "Setting up local network discovery."
  check_installed "${discovery}"
  check_fail
  show_success "Discovery applications installed."

  show_info "Enabling local hostname resolution in Avahi."
  local oldhostsline="hosts: files mymachines myhostname resolve \[!UNAVAIL=return\] dns"
  local newhostsline="hosts: files mymachines myhostname mdns_minimal \[NOTFOUND=return\] resolve \[!UNAVAIL=return\] dns"
  sudo sed -i "/^${oldhostsline}/s/^${oldhostsline}/${newhostsline}/g" ${nsconf}
  sudo systemctl enable avahi-daemon.service
  sudo systemctl start avahi-daemon.service
}


##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################

function tor_list(){
apt-transport-tor
onionshare
tor
torsocks
}

function install_tor {
  tor="${dir}/packages/tor.list"
  show_header "Installing Tor programs."
  check_installed "${tor}"
  check_fail
  show_success "Tor installed."

  show_info "Enabling and starting tor service."
  sudo systemctl enable tor
  sudo systemctl start tor
}

function use_onion_repos {
  srclist="/etc/apt/sources.list"
  show_header "Tunneling apt over tor for Debian $(lsb_release -sc)."

  local is_contrib
  grep -q contrib ${srclist}; is_contrib=$?
  local is_nonfree
  grep -q non-free ${srclist}; is_nonfree=$?

  local release
  release=$(lsb_release -sc)
  sudo cp -f ${srclist} ${srclist}.${RANDOM}.bak
  sudo cp -f "${dir}/sources/${release}-sources.list" ${srclist}

  [ ${is_contrib} == 0 ] && \
    sudo sed -i "s,\(.* ${release} main.*\)$,\1 contrib,g" ${srclist} && \
    sudo sed -i "s,\(.* ${release}-updates main.*\)$,\1 contrib,g" ${srclist}
    sudo sed -i "s,\(.* ${release}-backports main.*\)$,\1 contrib,g" ${srclist}
  [ ${is_nonfree} == 0 ] && \
    sudo sed -i "s,\(.* ${release} main.*\)$,\1 non-free,g" ${srclist} && \
    sudo sed -i "s,\(.* ${release}-updates main.*\)$,\1 non-free,g" ${srclist}
    sudo sed -i "s,\(.* ${release}-backports main.*\)$,\1 non-free,g" ${srclist}
  sudo sed -i "s,https://deb.debian.org,tor+http://vwakviie2ienjx6t.onion,g" ${srclist}
  sudo sed -i "s,https://security.debian.org/,tor+http://sgvtcaew4bxjd7ln.onion/debian-security/,g" ${srclist}

  sudo apt update
}


function install_torbrowser {
  torbrowser_path="${HOME}/.local/share/tor-browser"
  local_applications="${HOME}/.local/share/applications"
  show_m "Installing Tor browser."
  local torbrowser_version
  local torbrowser_package
  local torbrowser_url="https://www.torproject.org/dist/torbrowser"
  local arch

  # "Downloading Tor developers' GPG key."
  gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org

  torbrowser_version=$(curl https://www.torproject.org/download/ | \
                       sed -n 's,^ \+<a class="downloadLink" href="/dist/torbrowser/\([0-9\.]\+\)/tor-browser-linux.*">,\1,p')
  arch=$(uname -m)
  if [ "${arch:(-2)}" = "86" ]; then
    torbrowser_package=tor-browser-linux32-${torbrowser_version}_en-US.tar.xz
  elif [ "${arch:(-2)}" = "64" ]; then
    torbrowser_package=tor-browser-linux64-${torbrowser_version}_en-US.tar.xz
  fi

  # "Downloading release tarball."
  wget "${torbrowser_url}/${torbrowser_version}/${torbrowser_package}"
  wget "${torbrowser_url}/${torbrowser_version}/${torbrowser_package}.asc"
  # "Extracting..."
  gpg --verify "${torbrowser_package}.asc" "${torbrowser_package}"
  tar xf "${torbrowser_package}"

  # "Putting things into place..."
  mkdir -p "${local_applications}"
  rm -rf "${torbrowser_path}"
  mv tor-browser_en-US "${torbrowser_path}"
  cp -f "${torbrowser_path}/start-tor-browser.desktop" "${local_applications}/"
  chmod -x "${local_applications}/start-tor-browser.desktop"
  sed -i \
    -e "s,^Name=.*,Name=Tor Browser,g" \
    -e "s,^Icon=.*,Icon=browser-tor,g" \
    -e "s,^Exec=.*,Exec=sh -c '\"${torbrowser_path}/Browser/start-tor-browser\" --detach || ([ !  -x \"${torbrowser_path}/Browser/start-tor-browser\" ] \&\& \"\$(dirname \"\$*\")\"/Browser/start-tor-browser --detach)' dummy %k,g" \
      "${local_applications}/start-tor-browser.desktop"
  update-desktop-database "${local_applications}"

  # "Cleaning up..."
  rm -f "${torbrowser_package}"
  rm -f "${torbrowser_package}.asc"
}

##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################
##################################################################################################


function android_list(){
adb
android-libandroidfw
android-libcutils
android-libdex
android-libetc1
android-libext4-utils
android-tools-fsutils
f2fs-tools
fastboot
go-mtpfs
heimdall-flash
libmtp9
mmc-utils
}
#######################

function codecs_list(){
gstreamer1.0-libav
gstreamer1.0-plugins-bad
gstreamer1.0-plugins-base
gstreamer1.0-plugins-good
gstreamer1.0-plugins-ugly
}
#######################

function discover_list(){
avahi-autoipd
avahi-daemon
avahi-discover
gvfs
libnss-mdns
}
#######################

function extra_list(){
calibre
gifsicle
gimp
recordmydesktop
subtitleeditor
}
#######################

function firmware_list(){
amd64-microcode
bluez-firmware
firmware-iwlwifi
firmware-linux
firmware-linux-free
firmware-linux-nonfree
intel-microcode
}
#######################

function games_list(){
desmume
dolphin-emu
higan
mupen64plus
visualboyadvance-gtk
}
#######################

function network_list(){
iwd
openssh-server
wireguard-tools
wireless-tools
}
#######################

function printer_list(){
cups
cups-pk-helper
foomatic-db
foomatic-db-compressed-ppds
foomatic-db-engine
foomatic-filters
gutenprint
hplip
hplip-gui
printer-driver-gutenprint
system-config-printer
}
#######################

function utils_list(){
acpi
bc
cpio
dmidecode
dos2unix
dosfstools
encfs
ethtool
exfat-utils
gddrescue
gdisk
gnupg
hfsprogs
libbcprov-java
libcommons-lang3-java
libnotify-bin
lm-sensors
mtools
net-tools
nmap
ntfs-3g
nvme-cli
p7zip
parallel
parted
pdftk
pigz
pixz
pv
reiserfsprogs
rkhunter
rsync
screen
signify-openbsd
squashfs-tools
s-tui
time
tmux
unhide
unrar-free
usbutils
zip
zstd
}
#######################

packages_list="
firmware-linux-free
firmware-linux-nonfree
firmware-iwlwifi
firmware-realtek
libx11-dev
libxft-dev
libxinerama1
libxinerama-dev
network-manager
curl
wget
apt-transport-https
dirmngr
rsync
dmenu
python3
autoconf
suckless-tools
xorg
software-properties-common
cmake
fonts-font-awesome
fonts-roboto
devscripts
file-roller
feh
build-essential
gtk2-engines-murrine
gtk2-engines
vim
caca-utils
highlight
atool
w3m
poppler-utils
mediainfo
compton
python3-pip
libcanberra-gtk-module
libgtk2.0-dev
libgtk-3-dev
gnome-devel
imagemagick
nnn
tig
htop
mesa-utils
mesa-utils-extra
emacs
xsel
bluez-cups
blueman
gpick
tree
ninja-build
gettext
libtool-bin
g++
unzip
jq
nmap
thunderbird
ack
neofetch
crda
net-tools
npm
python
picom
xutils-dev
libx11-xcb-dev
libxcb-res0-dev
thunar
git
dbus-x11
pavucontrol
tldr
liblz4-tool
xclip
libnotify-dev
libxss-dev
keepassxc
python3-venv
tcpdump
gparted
"


##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################
##############################################################################################################################


  C5 "Slack" off
  # D: dev_Array_now_

  # F: Utility
  F1 "Dropbox" off
  F3 "Virtualbox" off
  
  C5)
    snap install slack --classic
    ;;
  F1)
    wget -O dropbox.deb https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2020.03.04_amd64.deb
    apt -y install ./dropbox.deb
    ;;
  F3)
    add-apt-repository "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian bullseye contrib"
    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -
    apt-get update
    apt-get -y install virtualbox-6.1


###############################################################################################################
###############################################################################################################
###############################################################################################################
###############################################################################################################

	# Update tldr database
	tldr -u
	
	### Git env
	git config --global user.email "Felixs.Developer@tutanota.com"
	git config --global user.name "FancyChaos"
	
	# Generate new ssh keys without a password
	ssh-keygen -q -f $HOME/.ssh/git_key -t ecdsa -b 521 -N ""
	
	### Fix broken packages for good measure (why not?)
	sudo apt install -f -y
	
	# Disable tracker (Data indexing for GNOME mostly)
	systemctl --user mask tracker-store.service tracker-miner-fs.service tracker-miner-rss.service tracker-extract.service tracker-miner-apps.service tracker-writeback.service
	systemctl --user mask gvfs-udisks2-volume-monitor.service gvfs-metadata.service gvfs-daemon.service
