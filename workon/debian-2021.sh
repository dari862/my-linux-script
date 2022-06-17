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

installations_sh()
{

###################
## 00-install_fonts.sh
##################
# Install fonts
# This takes a long time rn, because we clone the whole nerd font repo

# Clone repo
cd /tmp/
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts/

chmod +x install.sh
# Install fonts of choice here
./install.sh FiraCode
./install.sh FiraMono
./install.sh Hack

# Other fonts/emoji stuff
sudo apt install -y fonts-noto-color-emoji fonts-font-awesome
 
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
## 05-install_dwm.sh
##################
#!/bin/bash

cd /tmp/
git clone https://github.com/FancyChaos/dwm.git
cd dwm/
make
sudo make install
 
###################
## 10-install_st.sh
##################
#!/bin/bash

# Build st by instantOS (Custom version with "scrollback" patch)
cd /tmp/
git clone https://github.com/FancyChaos/st-instantos.git
cd st-instantos/
rm config.h || true
make
sudo make install
 
###################
## 15-install_dwmblocks.sh
##################
#!/bin/bash

cd /tmp/
git clone https://github.com/FancyChaos/dwmblocks.git
cd dwmblocks/
chmod +x build.sh
./build.sh
 
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
## 20-install_zsh.sh
##################
#!/bin/bash

# Path of custom zsh folder
ZSH_CUSTOM=~/.oh-my-zsh/custom

# Install zsh
sudo apt install zsh -y

# Set zsh as default shell (Also set SHELL in .xinitrc)
sudo chsh -s $(which zsh)

# Install oh-my-zsh
cd /tmp/
export RUNZSH=no
export CHSH=no
export KEEP_ZSHRC=yes
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install autocomplete
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install zsh-completion
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions

# Install zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search

# Install spaceship theme
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

# Install autojump
cd /tmp/
git clone git://github.com/wting/autojump.git
cd autojump/
python3 install.py

 
###################
## 25-install_bat.sh
##################
#!/bin/bash

cd /tmp/
wget https://github.com/sharkdp/bat/releases/download/v0.19.0/bat_0.19.0_amd64.deb
sudo dpkg -i bat*.deb
 
###################
## 30-install_logo-ls.sh
##################
#!/bin/bash

cd /tmp/
wget https://github.com/Yash-Handa/logo-ls/releases/download/v1.3.7/logo-ls_amd64.deb
sudo dpkg -i logo-ls*.deb
 
###################
## 31-install_ranger.sh
##################
#!/bin/bash

cd /tmp/
git clone https://github.com/ranger/ranger.git
cd ranger/
sudo make install
 
###################
## 35-install_neovim.sh
##################
#!/bin/bash

cd /tmp/

### Install neovim v.0.5.0
git clone https://github.com/neovim/neovim.git
cd neovim/
git checkout tags/v0.6.1
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

cd /tmp/

### Install neovim plugins
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
pip3 install --user neovim

mkdir -p $HOME/.config/nvim/plugged/ || true

nvim -c PlugInstall -c UpdateRemotePlugins -c quitall
 
###################
## 40-install_spotify.sh
##################
#!/bin/bash

curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update -y && sudo apt-get install -y spotify-client
 
###################
## 45-install_arandr.sh
##################
#!/bin/bash

# Clone custom arandr version
cd /tmp/
git clone https://github.com/FancyChaos/arandr.git
cd arandr

# Install docutils for python3
sudo pip install docutils

# Install arandr
sudo ./setup.py install
 
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
 
###################
## 60-install_dunst.sh
##################
#!/bin/bash

cd /tmp/

git clone https://github.com/dunst-project/dunst.git
cd dunst
make
sudo make install

}

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

### This script is for executing the main script and logging its output

### Start sudo session (will last 15minutes)
echo "Enter sudo password"
sudo echo ""

if [ "$?" != "0" ]; then
	exit
fi

### Get path of script
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
export SCRIPTPATH

### Install essentials if they are not yet installed
sudo apt install -y coreutils build-essential rsync wget curl bash fasttrack-archive-keyring

cd $SCRIPTPATH

# Make sure everything is executable

chmod +x install.sh
chmod +x installations.sh

### Execute the main script
{
	# Get endless sudo permissions
	while true
	do
		sudo -v
		sleep 5
	done &
	
	echo "Building and installing a dwm system for user $USER into $HOME"
	echo "Installing packages..."
	
	### Update
	sudo apt update && sudo apt upgrade -y
	
	### installing packages and default applications
	sudo apt install -y ${packages_list}
	
	echo "Installing main Applications..."
	
	installations_sh # function installations_sh
	
	echo "Done installing main Applications"
	
	echo "Running final steps..."
	
	cd $SCRIPTPATH
	
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
	
	### Deactivate systemd-networkd for good measure
	sudo systemctl disable systemd-networkd.service
	sudo systemctl enable NetworkManager.service
	
	### Cleanup
	sudo apt autoremove -y
	sudo apt remove python-is-python2 -y || true
	sudo ln -s $(which python3) /usr/local/bin/python
	
	sudo systemctl disable unattended-upgrades.service
	sudo systemctl disable cups.service
	sudo systemctl disable exim4.service
	sudo systemctl disable bluetooth.service
	sudo systemctl disable blueman-mechanism.service
	
	# Disable tracker (Data indexing for GNOME mostly)
	systemctl --user mask tracker-store.service tracker-miner-fs.service tracker-miner-rss.service tracker-extract.service tracker-miner-apps.service tracker-writeback.service
	systemctl --user mask gvfs-udisks2-volume-monitor.service gvfs-metadata.service gvfs-daemon.service
	
	### Disable webcam by default
	### Toogle back on with 'sudo modprobe uvcvideo'
	# sudo modprobe -r uvcvideo
	
	### Boot into command line
	sudo systemctl set-default multi-user.target
	
	### Done
	echo "Installation done"
	sudo reboot
} | tee $SCRIPTPATH/install.log
