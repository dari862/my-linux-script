#!/bin/sh

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

###################
## 01-install_libxft.sh
##################
#!/bin/bash

# Install fixed libxft library to /usr/lib/
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

###################
## 17-install_instantlock.sh
##################
#!/bin/bash

cd /tmp/
git clone https://github.com/FancyChaos/instantlock.git
cd instantlock/
chmod +x build.sh
./build.sh
 
###################
## 30-install_logo-ls.sh
##################
#!/bin/bash

cd /tmp/
wget https://github.com/Yash-Handa/logo-ls/releases/download/v1.3.7/logo-ls_amd64.deb
sudo dpkg -i logo-ls*.deb

###################
## 50-install_librewolf.sh
##################
#!/bin/bash

echo "deb [arch=amd64] http://deb.librewolf.net $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/librewolf.list

sudo wget https://deb.librewolf.net/keyring.gpg -O /etc/apt/trusted.gpg.d/librewolf.gpg

sudo apt update

sudo apt install librewolf -y
 
###################
## 55-install_golang.sh
##################
#!/bin/bash

golink="https://go.dev/dl/go1.17.6.linux-amd64.tar.gz"

sudo rm -rf /usr/local/go/ || true
wget -qO- "$golink" | sudo tar xvz -C /usr/local/


###############################################################################################################
###############################################################################################################
###############################################################################################################
###############################################################################################################


	### creating dirs like "Pictures", "Downloads" etc.
	xdg-user-dirs-update
	
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
