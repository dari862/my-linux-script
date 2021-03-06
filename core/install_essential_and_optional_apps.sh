# https://github.com/exgade/linux-gaming
pre_install_all_picked_apps_now()
{
local delete=""
show_mf "pre_install_all_picked_apps_now"

if [[ " ${drivers_Array[*]} " =~ " Btrfs " ]]; then
delete="Btrfs"
drivers_Array=( "${drivers_Array[@]/$delete}" )
declare -g do_you_want_to_optimize_Btrfs="true"
fi

if [[ " ${internet_Array[*]} " =~ " brave-browser " ]]; then
	show_m "adding brave browser repo"
	add_new_source_to_apt_now mod "gpg" repolink "deb [signed-by=/etc/apt/trusted.gpg.d/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" reponame "brave-browser-release" keylink "https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg" keyname "brave-browser-archive-keyring.gpg"
	aptupdate
fi

if [[ " ${internet_Array[*]} " =~ " google-chrome-stable " ]]; then
show_m "Download and install Google Chrome, add to repositories "
# INFO: Google Chrome is most popular web browser
# INFO: Its recommended config official repositories for weekly updates
	if ! grep -R "dl.google.com/linux/chrome/deb/" /etc/apt/ &> /dev/null; then
		newwget -P /tmp/ https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb 
		sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb || { $sudoaptinstall -f && sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb ; }
		$sudoaptinstall -f
	fi
fi

if [[ " ${internet_Array[*]} " =~ " librewolf " ]]; then
	show_m "adding librewolf browser repo"
	add_new_source_to_apt_now mod "gpg" repolink "deb [arch=amd64] http://deb.librewolf.net $(lsb_release -sc) main" reponame "librewolf" keylink "https://deb.librewolf.net/keyring.gpg" keyname "librewolf.gpg"
	aptupdate
fi

if [[ " ${office_Array[*]} " =~ " ttf-mscorefonts-installer " ]]; then
	show_m "accpet mscorefonts eul"
	echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
fi

if [[ " ${extra_Array[*]} " =~ " sublime-text " ]]; then
show_m "Install Sublime Text, add repositories and set as default editor"
# INFO: Sublime Text is propietary and multiplataform text editor, very fast and beautiful, that supports many programming and markup languages
# Install repositories and update
	if ! grep -R "download.sublimetext.com" /etc/apt/ &> /dev/null; then
		add_new_source_to_apt_now mod "gpg" -repolink "deb https://download.sublimetext.com/ apt/stable/" -reponame "sublime-text.list" -keylink "https://download.sublimetext.com/sublimehq-pub.gpg" -keyname "sublimehq-pub.gpg"
		aptupdate
	fi
fi

if [[ " ${extra_Array[*]} " =~ " komorebi " ]]; then
	show_m "Downloading live wallpaper app (komorebi)"
	komorebi_deb_file_name=${outsidemyrepo_komorebi##*/}
	delete="komorebi"
	extra_Array=( "${extra_Array[@]/$delete}" )
	newwget -P $foldertempfornow $outsidemyrepo_komorebi
	show_m "installing live wallpaper app (komorebi) dependancy "
	$sudoaptinstall $foldertempfornow/$komorebi_deb_file_name gstreamer1.0-libav
	declare -g is_komorebi_installed="true"
fi

if [[ " ${extra_Array[*]} " =~ " atom " ]]; then
	show_m "add atom repo"
	add_new_source_to_apt_now mod "gpg" repolink "deb [signed-by=/etc/apt/trusted.gpg.d/AtomEditor_atom-archive-keyring.gpg] https://packagecloud.io/AtomEditor/atom/any/ any main && deb-src [signed-by=/etc/apt/trusted.gpg.d/AtomEditor_atom-archive-keyring.gpg] https://packagecloud.io/AtomEditor/atom/any/ any main" reponame "atom" keylink "https://packagecloud.io/AtomEditor/atom/gpgkey" keyname "AtomEditor_atom-archive-keyring.gpg"
	aptupdate
fi

if [[ " ${extra_Array[*]} " =~ " VirtualBox " ]]; then
	show_m "add VirtualBox repo"
	if [[ " ${extra_Array[*]} " =~ " VirtualBox " ]]; then
		delete="VirtualBox"
		extra_Array=( "${extra_Array[@]/$delete}" )
		VirtualBox_Array=(linux-headers-$(uname -r) dkms virtualbox)
		extra_Array=(${extra_Array[@]} ${VirtualBox_Array[@]})
	fi
	add_new_source_to_apt_now mod "gpg" repolink "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" reponame "virtualbox" keylink "https://www.virtualbox.org/download/oracle_vbox_2016.asc && https://www.virtualbox.org/download/oracle_vbox.asc" keyname "oracle_vbox.gpg"
	aptupdate
	
fi

if [[ " ${Network_Array[*]} " =~ " Avahi " ]]; then
	if [[ " ${Network_Array[*]} " =~ " Avahi " ]]; then
		delete="Avahi"
		Network_Array=( "${Network_Array[@]/$delete}" )
		VirtualBox_Array=(avahi-autoipd avahi-daemon avahi-discover)
		Network_Array=(${Network_Array[@]} ${VirtualBox_Array[@]})
	fi
	  echo "Enabling local hostname resolution in Avahi."
	  local oldhostsline="hosts: files mymachines myhostname resolve \[!UNAVAIL=return\] dns"
	  local newhostsline="hosts: files mymachines myhostname mdns_minimal \[NOTFOUND=return\] resolve \[!UNAVAIL=return\] dns"
	  sudo sed -i "/^${oldhostsline}/s/^${oldhostsline}/${newhostsline}/g" ${nsconf}
	  sudo systemctl enable avahi-daemon.service
	  sudo systemctl start avahi-daemon.service
fi

if [[ " ${Network_Array[*]} " =~ " openssh-server " ]]; then
	echo "Disabling SSH root login and forcing SSH v2."
	sudo sed -i \
	  -e "/^#PermitRootLogin prohibit-password$/a PermitRootLogin no" \
	  -e "/^#Port 22$/i Protocol 2" \
	  /etc/ssh/sshd_config
fi


if [[ " ${dev_Array[*]} " =~ " MVSC " ]]; then
	delete="MVSC"
	dev_Array=( "${dev_Array[@]/$delete}" )
	add_new_source_to_apt_now mod "gpg" repolink "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" reponame "vscode" keylink "https://packages.microsoft.com/keys/microsoft.asc" keyname "packages.microsoft.gpg"
	aptupdate
	dev_Array=(${dev_Array[@]} "code")
fi
if [[ " ${dev_Array[*]} " =~ " Docker " ]]; then
	delete="Docker"
	dev_Array=( "${dev_Array[@]/$delete}" )
	show_m "installing Dropbox"
	if [ "$DISTRO" == "Debian" ]; then
		DISTRO_NAME_4_Dropbox="debian"
	elif [ "$DISTRO" == "Fedora" ]; then
		DISTRO_NAME_4_Dropbox="fedora"
	else
		DISTRO_NAME_4_Dropbox="Ubuntu"
	fi
	add_new_source_to_apt_now mod "gpg" repolink "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/${DISTRO_NAME_4_Dropbox} $(lsb_release -cs) stable" reponame "docker" keylink "https://download.docker.com/linux/debian/gpg" keyname "docker-archive-keyring.gpg"
    aptupdate
    dev_Array=(${dev_Array[@]} docker-ce docker-ce-cli containerd.io)
fi

}

############################################################################################################################################

post_install_all_picked_apps_now()
{
show_mf "post_install_all_picked_apps_now"

temp_command="libreoffice"
if command -v $temp_command >/dev/null
then
	show_m "make $temp_command default office"
	sudo update-alternatives --install /usr/bin/x-office x-office $(command -v $temp_command) 90
	sudo update-alternatives --set x-office $(command -v $temp_command)
fi

temp_command="lpadmin"
if command -v $temp_command >/dev/null
then
	show_m "add user 1000 to lpadmin group to manage CUPS printer system"
	# CUPS is a printer system for config printers and printer queue
	# Can be managed in http://localhost:631 and admin users must be in lpadmin group
	user1000=$(cat /etc/passwd | cut -f 1,3 -d: | grep :1000$ | cut -f1 -d:)
	[ "$user1000" ] && sudo adduser "$user1000" $temp_command
fi

temp_command="firefox"
if command -v $temp_command >/dev/null
then
	show_m "make $temp_command default browser"
	sudo update-alternatives --set x-www-browser $(command -v $temp_command)
fi

temp_command="firefox-esr"
if command -v $temp_command >/dev/null
then
	show_m "make $temp_command default browser"
	sudo update-alternatives --set x-www-browser $(command -v $temp_command)
fi

if [ "$is_komorebi_installed" == "true"]
then

	show_m "create komorebi bash aliases"
	sudo mkdir -p /etc/skel/.config/komorebi
	sudo mv ~/.config/autostart/komorebi.desktop /etc/skel/.config/komorebi
cat <<EOF >> /tmp/komorebi-aliases
alias nowkomorebi-autostart="cp -r ~/.config/komorebi/komorebi.desktop ~/.config/autostart/"
alias nowkomorebi-removeautostart="rm -f ~/.config/autostart/komorebi.desktop"
EOF

	sudo mv /tmp/komorebi-aliases /etc/skel/.config/komorebi/
	sudo chown root:root /etc/skel/.config/komorebi/komorebi-aliases
	cp -r /etc/skel/.config/komorebi ~/.config/
	
	if [ -f "$temp_folder_for_skel_shell_folder/$bashrcfilename" ] || [ -f "/etc/skel/$myshell_skel_folder/$bashrcfilename" ]
	then
		echo '' >> $temp_folder_for_skel_shell_folder/$bashrcfilename
		echo 'source ~/.config/komorebi/komorebi-aliases' >> $temp_folder_for_skel_shell_folder/$bashrcfilename
	else
		echo '' | sudo tee -a /etc/skel/.bash_aliases
		echo 'source ~/.config/komorebi/komorebi-aliases' | sudo tee -a /etc/skel/.bash_aliases
		cat /etc/skel/.bash_aliases >> ~/.bash_aliases
	fi
	
	
fi

temp_command="subl"
if command -v $temp_command >/dev/null
then
	sudo update-alternatives --install /usr/bin/x-text-editor x-text-editor $(command -v $temp_command) 90
	sudo update-alternatives --set x-text-editor $(command -v $temp_command)
fi

temp_command="atom"
if command -v $temp_command >/dev/null
then
	sudo update-alternatives --install /usr/bin/x-text-editor x-text-editor $(command -v $temp_command) 90
	sudo update-alternatives --set x-text-editor $(command -v $temp_command)
fi

if [ "$do_you_want_to_optimize_Btrfs" == "true" ]; then
show_mf "running Btrfs optimizations"
	if [ "$(mount | grep ' on / type btrfs' -c)" = "1" ] ; then
		show_m "BTRFS detected, running optimizations"
		if [ "$(mount | grep 'on /home' -c)" = "0" ] ; then
			show_m "BTRFS: running optimizations in /home"
			for loopdir in /home/*; do
				loopuser="${loopdir/\/home\//}"
				if [ "${loopdir}" = "/home/${loopuser}" ]; then
					realuser="$(grep "${loopuser}:" /etc/passwd -c)"
					if [ "$realuser" = "1" ] ; then
						show_m "optimizing for user ${loopuser}"
						# Winetricks Default Directory for Wine Bottles
						if [ ! -d "${loopdir}/.local/share/wineprefixes" ] ; then
							mkdir -p "${loopdir}/.local/share/wineprefixes"
							chown "${loopuser}" "${loopdir}/.local/"
							chown "${loopuser}" "${loopdir}/.local/share/"
							chown "${loopuser}" "${loopdir}/.local/share/wineprefixes"
						fi
						chattr +C -R "${loopdir}/.local/share/wineprefixes"
						# Lutris default Game Directory
						if [ ! -d "${loopdir}/Games" ] ; then
							mkdir "${loopdir}/Games"
							chown "${loopuser}" "${loopdir}/Games"
						fi
						chattr +C -Rf "${loopdir}/Games"
						# Nvidia GL Cache
						if [ ! -d "${loopdir}/.nv/GLCache" ] ; then
							mkdir -p "${loopdir}/.nv/GLCache"
							chown "${loopuser}" "${loopdir}/.nv"
							chown "${loopuser}" "${loopdir}/.nv/GLCache"
						fi
						chattr +C -R "${loopdir}/.nv/GLCache"
						# Steam Default Directory for Downloads, etc.
						if [ ! -d "${loopdir}/.steam" ] ; then
							mkdir "${loopdir}/.steam"
							chown "${loopuser}" "${loopdir}/.steam"
						fi
						# less error messages (-f), since there are a lot of symlinks
						chattr +C -Rf "${loopdir}/.steam"
						# Steam Default Directory for Downloads, etc.
						if [ ! -d "${loopdir}/.local/share/Steam" ] ; then
							mkdir "${loopdir}/.local/share/Steam"
							chown "${loopuser}" "${loopdir}/.local/share/Steam"
						fi
						# less error messages (-f), since there are probably a lot of symlinks
						chattr +C -Rf "${loopdir}/.local/share/Steam"
					fi
				else
					show_m "Error: Folder ${loopdir} ignored: is it not in /home/ ?"
				fi
			done
		fi
		# arch pkg cache
		if [ -d "/var/cache/pacman/pkg" ] ; then
			show_m "BTRFS: running pacman cache optimization"
			chattr +C -R /var/cache/pacman/pkg
		fi
		# debian/ ubuntu apt cache
		if [ -d "/var/cache/apt" ] ; then
			show_m "BTRFS: running apt cache optimization"
			chattr +C -R /var/cache/apt
		fi
	fi
fi

}


############################################################################################################################################
# Tor_Network_Array functions
############################################################################################################################################

install_tor_stuffs_(){
  show_m "installing tor stuffs"
  tor_stuff_=(apt-transport-tor onionshare tor torsocks)
  apt_install_noninteractive_whith_error2info "${tor_stuff_[@]}"
  echo "Enabling and starting tor service."
  sudo systemctl enable tor
  sudo systemctl start tor
}

use_onion_repos_for_apt(){
  srclist="/etc/apt/sources.list"
  show_m "Tunneling apt over tor for Debian $(lsb_release -sc)."

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

  aptupdate
}

install_torbrowser_(){
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

############################################################################################################################################

install_all_picked_apps_now()
{
show_mf "install_all_picked_apps_now"

####################################
# laptops_Array
####################################

if [ ! -z "${laptops_Array[*]}" ]
then
	show_m "install laptops app "
	echo_2_helper_list "# laptops app"
		if [[ " ${base_Array[*]} " =~ " tlp " ]]; then
			base_Array+=("tlp-rdw")
			sudo tlp start  &>> $debug_log 
  			sudo systemctl enable tlp  &>> $debug_log 
		fi
	apt_install_noninteractive_whith_error2info "${laptops_Array[@]}"
	echo_2_helper_list ""

  #cd /tmp
  #git-clone https://github.com/AdnanHodzic/auto-cpufreq.git auto-cpufreq
  #cd auto-cpufreq && sudo ./auto-cpufreq-installer --install
fi

####################################
# base_Array
####################################

if [ ! -z "${base_Array[*]}" ]
then
	show_m "install base app "
	echo_2_helper_list "# base app"
		if [[ " ${base_Array[*]} " =~ " xkill " ]]; then
			delete="xkill"
			base_Array=( "${base_Array[@]/$delete}" )
			install_base_app_xkill=(xkill x11-utils)
			apt_if_install_whith_error2info "${install_base_app_xkill[@]}"
		fi
	apt_install_noninteractive_whith_error2info "${base_Array[@]}"
	echo_2_helper_list ""
fi

####################################
# drivers_Array
####################################

if [ ! -z "${drivers_Array[*]}" ]
then
	show_m "install drivers app "
	echo_2_helper_list "# drivers app"
	if [[ " ${drivers_Array[*]} " =~ " Nvidia " ]] || [[ " ${drivers_Array[*]} " =~ " Amd " ]] || [[ " ${drivers_Array[*]} " =~ " Intel " ]]
	then
		drivers_Array+=("firmware-linux-nonfree")
	fi
	
	check_for_this="Nvidia"
	if [[ " ${drivers_Array[*]} " =~ " $check_for_this " ]]; then
		delete="$check_for_this"
		drivers_Array=( "${drivers_Array[@]/$delete}" )
		if [ "$DISTRO" == "Ubuntu" ]; then
			if [ ! -f "/etc/apt/sources.list.d/graphics-drivers-ubuntu-ppa-${Codename,,}.list" ] ; then
				show_m "adding ubuntu's GPU Drivers PPA."
				add_new_source_to_apt_now mod "ppa" "graphics-drivers/ppa"
				aptupdate
			fi
			newest_nvidia_version="$(apt-cache search "nvidia-driver-*" | awk '{print $1}' | grep "nvidia-driver-*" | grep -v "server" | grep -Eo '[0-9]{1,4}' | sort -n | tail -n1)"
			newest_installed_nvidia_drivers_version="$(dpkg --list | less | grep "nvidia-driver-*" | awk '{print $2}' | grep -Eo '[0-9]{1,4}' | sort -n | tail -n1 || :)"
			installed_nvidia_drivers=($(dpkg --list | less | grep "nvidia-driver-*" | awk '{print $2}' || :))
			if [[ "$newest_installed_nvidia_drivers_version" < "$newest_nvidia_version" ]] ; then
				show_m " removing old nvidia driver"
				apt_purge_with_error2info "${installed_nvidia_drivers[@]}"
				show_m " adding nvidia proprietary driver to installation list"
				drivers_Array+=("nvidia-driver-${newest_nvidia_version}" "libnvidia-gl-${newest_nvidia_version}" "libnvidia-gl-${newest_nvidia_version}:i386 nvidia-settings" "nvidia-driver-${newest_nvidia_version}" "nvidia-utils-${newest_nvidia_version}")
			fi
			if [[ "$newest_installed_nvidia_drivers_version" = "$newest_nvidia_version" ]] ; then
				show_im "newest nvidia drivers already installed, installed=$newest_installed_nvidia_drivers_version , repo=$newest_nvidia_version ."
				show_m "newest nvidia drivers already installed."
			fi
		else
			drivers_Array+=("nvidia-driver")
		fi
	fi
	check_for_this="Amd"
	if [[ " ${drivers_Array[*]} " =~ " $check_for_this " ]]; then
		delete="$check_for_this"
		drivers_Array=( "${drivers_Array[@]/$delete}" )
		dpkg_add_architecture_i386
		show_m " adding Amd Gpu driver to installation list"
		if [ "$DISTRO" == "Ubuntu" ]; then
		drivers_Array+=("libgl1-mesa-dri:i386" "mesa-vulkan-drivers" "mesa-vulkan-drivers:i386" "mesa-utils")
		else
		drivers_Array+=("libgl1-mesa-dri" "libgl1-mesa-dri:i386" "xserver-xorg-video-ati" "xserver-xorg-video-amdgpu" "mesa-vulkan-drivers" "mesa-vulkan-drivers:i386")
		fi
	fi
	check_for_this="Intel"
	if [[ " ${drivers_Array[*]} " =~ " $check_for_this " ]]; then
		delete="$check_for_this"
		drivers_Array=( "${drivers_Array[@]/$delete}" )
		sudo mkdir -p /etc/X11/xorg.conf.d/
cat << EOF > $foldertempfornow/20-intel.conf
Section "Device"
	Identifier  "Intel Graphics"
	Driver      "XXXXXX"
	Option      "AccelMethod"  "sna"
	Option      "TearFree"	"True"
	Option      "Tiling"	"True"
	Option      "SwapbuffersWait" "True"
	#Option      "AccelMethod"  "uxa"
EndSection
EOF
sed -i "s/XXXXXX/Intel/g" $foldertempfornow/20-intel.conf
		sudo chown root:root $foldertempfornow/20-intel.conf
		sudo mv $foldertempfornow/20-intel.conf /etc/X11/xorg.conf.d/
	fi
	show_m " installing drivers now."
	apt_install_noninteractive_whith_error2info "${drivers_Array[@]}"
	echo_2_helper_list ""
fi

####################################
# media_Array
####################################

if [ ! -z "${media_Array[*]}" ]
then
	show_m "install sound app "
	echo_2_helper_list "# Sound apps"
	apt_install_noninteractive_whith_error2info "${media_Array[@]}"
	echo_2_helper_list ""
fi

####################################
# codecs_list_Array
####################################

if [ ! -z "${codecs_list_Array[*]}" ]
then
	show_m "install codecs app "
	echo_2_helper_list "# codecs app"
	apt_install_noninteractive_whith_error2info "${codecs_list_Array[@]}"
	echo_2_helper_list ""
fi

####################################
# internet_Array
####################################

if [ ! -z "${internet_Array[*]}" ]
then
	show_m "install browsers , email client and downloader apps"
	echo_2_helper_list "# internet apps"
	if [[ " ${internet_Array[*]} " =~ " Slack " ]]; then
		delete="Slack"
		internet_Array=( "${internet_Array[@]/$delete}" )
		install_Snap_now
		show_m "installing Slack"
		if [ -f /snap/bin/Slack ]; then
			echo 'Slack is already installed.'
		else
			snap install Slack --classic &>> $debug_log || show_em "failed to install discord"
			echo_2_helper_list "Slack"
		fi
	fi
	
	if [[ " ${internet_Array[*]} " =~ " Dropbox " ]]; then
		local DISTRO_NAME_4_Dropbox=""
		delete="Dropbox"
		internet_Array=( "${internet_Array[@]/$delete}" )
		show_m "installing Dropbox"
		if [ "$DISTRO" == "Debian" ]; then
			DISTRO_NAME_4_Dropbox="debian"
		elif [ "$DISTRO" == "Fedora" ]; then
			DISTRO_NAME_4_Dropbox="fedora"
		else
			DISTRO_NAME_4_Dropbox="Ubuntu"
		fi
		DropBox_latest_ver="$(curl https://linux.dropbox.com/packages/ubuntu/ 2>/dev/null | grep -v nautilus | awk '{print $2}' | grep dropbox | grep -o -P '(?<=">dropbox_).*(?=_amd64.deb)' | tail -1)"
		wget -O dropbox.deb https://www.dropbox.com/download?dl=packages/${DISTRO_NAME_4_Dropbox}/dropbox_${DropBox_latest_ver}_amd64.deb
    		$sudoaptinstall ./dropbox.deb
		echo_2_helper_list "Dropbox"
	fi
	
	apt_install_noninteractive_whith_error2info "${internet_Array[@]}"
	install_firefox_app_now_
	echo_2_helper_list ""
fi

####################################
# Network_Array
####################################

if [ ! -z "${Network_Array[*]}" ]
then
	show_m "install network apps"
	echo_2_helper_list "# network apps"
	apt_install_noninteractive_whith_error2info "${Network_Array[@]}"
	echo_2_helper_list ""
fi

####################################
# Tor_Network_Array
####################################

if [ ! -z "${Tor_Network_Array[*]}" ]
then
	show_m "install Tor network apps"
	echo_2_helper_list "# Tor network apps"
	if [[ " ${Tor_Network_Array[*]} " =~ " install_tor_stuff " ]]; then
		install_tor_stuffs_
	fi
	if [[ " ${Tor_Network_Array[*]} " =~ " use_onion_repos " ]]; then
		use_onion_repos_for_apt
	fi
	if [[ " ${Tor_Network_Array[*]} " =~ " install_torbrowser " ]]; then
		install_torbrowser_
	fi
	echo_2_helper_list ""
fi
####################################
# desktop_Array
####################################

if [ ! -z "${desktop_Array[*]}" ]
then
	show_m "install desktop app "
	echo_2_helper_list "# desktop app"
	apt_install_noninteractive_whith_error2info "${desktop_Array[@]}"
	echo_2_helper_list ""
fi

####################################
# office_Array
####################################

if [ ! -z "${office_Array[*]}" ]
then
	show_m "install office apps"
	echo_2_helper_list "# office apps"
	apt_install_noninteractive_whith_error2info "${office_Array[@]}"
	echo_2_helper_list ""
fi

####################################
# dev_Array
####################################

if [ ! -z "${dev_Array[*]}" ]
then
	show_m "install dev apps."
	echo_2_helper_list "# dev app"
	if [[ " ${dev_Array[*]} " =~ " GO " ]]; then
			delete="GO"
			dev_Array=( "${dev_Array[@]/$delete}" )
			go_latest_ver="$(curl https://go.dev/dl/ 2>/dev/null | grep .linux-amd64.tar.gz | awk '{print $4}' | grep -o -P '(?<=">go).*(?=.linux-amd64.tar.gz)' | head -1)"
			wget https://go.dev/dl/go${go_latest_ver}.linux-amd64.tar.gz
    		rm -rf /usr/local/go && tar -C /usr/local -xzf go${go_latest_ver}.linux-amd64.tar.gz
    		local profile_name_=""
    		if [ -f "$HOME/.profile" ]; then
    		profile_name_=".profile"
    		elif [ -f "$HOME/.zprofile" ]; then
    		profile_name_=".zprofile"
    		fi
    		
    		echo ' ' >> $HOME/$profile_name_
    		echo '# GoLang configuration ' >> $HOME/$profile_name_
    		echo 'export PATH="$PATH:/usr/local/go/bin"' >> $HOME/$profile_name_
    		echo 'export GOPATH="$HOME/go"' >> $HOME/$profile_name_
    		source $HOME/$profile_name_
	fi

	if [[ " ${dev_Array[*]} " =~ " IntelliJ " ]]; then
			delete="IntelliJ"
			dev_Array=( "${dev_Array[@]/$delete}" )
			install_Snap_now
			show_m "installing intellij-idea-community"
			if [ -f /snap/bin/intellij-idea-community ]; then
				echo 'intellij-idea-community is already installed.'
			else
				snap install intellij-idea-community --classic &>> $debug_log || show_em "failed to install discord"
			fi
	fi
	if [[ " ${dev_Array[*]} " =~ " GoLand " ]]; then
			delete="GoLand"
			dev_Array=( "${dev_Array[@]/$delete}" )
			install_Snap_now
			show_m "installing GoLand"
			if [ -f /snap/bin/goland ]; then
				echo 'GoLand is already installed.'
			else
				snap install goland --classic &>> $debug_log || show_em "failed to install discord"
			fi
	fi
	if [[ " ${dev_Array[*]} " =~ " Postman " ]]; then
			delete="Postman"
			dev_Array=( "${dev_Array[@]/$delete}" )
			install_Snap_now
			show_m "installing Postman"
			if [ -f /snap/bin/postman ]; then
				echo 'Postman is already installed.'
			else
				snap install postman &>> $debug_log || show_em "failed to install discord"
			fi
	fi
	
	if [[ " ${dev_Array[*]} " =~ " PyCharm " ]]; then
			delete="PyCharm"
			dev_Array=( "${dev_Array[@]/$delete}" )
			install_Snap_now
			show_m "installing PyCharm"
			if [ -f /snap/bin/pycharm-community ]; then
				echo 'PyCharm is already installed.'
			else
				snap install pycharm-community --classic &>> $debug_log || show_em "failed to install discord"
			fi
	fi
	if [[ " ${dev_Array[*]} " =~ " Robo_3T " ]]; then
			delete="Robo_3T"
			dev_Array=( "${dev_Array[@]/$delete}" )
			
			install_Snap_now
			show_m "installing robo3t-snap"
			if [ -f /snap/bin/robo3t-snap ]; then
				echo 'robo3t-snap is already installed.'
			else
				snap install robo3t-snap &>> $debug_log || show_em "failed to install discord"
			fi
	fi
	if [[ " ${dev_Array[*]} " =~ " DataGrid " ]]; then
			delete="DataGrid"
			dev_Array=( "${dev_Array[@]/$delete}" )
			install_Snap_now
			show_m "installing DataGrid"
			if [ -f /snap/bin/datagrip ]; then
				echo 'DataGrid is already installed.'
			else
				snap install datagrip --classic &>> $debug_log || show_em "failed to install discord"
			fi
	fi
	if [[ " ${dev_Array[*]} " =~ " Mongo_Shell " ]]; then
			delete="Mongo_Shell"
			dev_Array=( "${dev_Array[@]/$delete}" )
			wget -O mongosh.deb https://downloads.mongodb.com/compass/mongodb-mongosh_1.2.2_amd64.deb
    		dpkg -i ./mongosh.deb
		
    		wget -O mongodb-database-tools.deb https://fastdl.mongodb.org/tools/db/mongodb-database-tools-debian92-x86_64-100.5.2.deb
    		dpkg -i ./mongodb-database-tools.deb
	fi
	
	if [[ " ${dev_Array[*]} " =~ " android_stuff " ]]; then
			delete="android_stuff"
			dev_Array=( "${dev_Array[@]/$delete}" )
			dev_Array=(${dev_Array[@]} adb android-libandroidfw android-libcutils android-libdex android-libetc1 android-libext4-utils android-tools-fsutils f2fs-tools fastboot go-mtpfs heimdall-flash libmtp9 mmc-utils)
	fi
	apt_install_noninteractive_whith_error2info "${dev_Array[@]}"
	if command -v docker &>/dev/null; then
		docker run hello-world
    	sudo groupadd docker
    	sudo usermod -aG docker $USER
    	sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    	sudo chmod +x /usr/local/bin/docker-compose
    	sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    	docker-compose --version
	fi
	echo_2_helper_list ""
fi

####################################
# extra_Array
####################################

if [ ! -z "${extra_Array[*]}" ]
then
	show_m "install extra app "
	echo_2_helper_list "# extra app"
	if [ "is_komorebi_installed" == "true"]
	then
		echo_2_helper_list " komorebi "
	fi
	apt_install_noninteractive_whith_error2info "${extra_Array[@]}"
	echo_2_helper_list ""
fi

####################################
# alt_installer_Array
####################################

if [ ! -z "${alt_installer_Array[*]}" ]
then
	show_m "install alt_installer app "
	echo_2_helper_list "# alt_installer app"
		if [[ " ${alt_installer_Array[*]} " =~ " Snap " ]]; then
			delete="Snap"
			alt_installer_Array=( "${alt_installer_Array[@]/$delete}" )
			install_Snap_now
		fi

		if [[ " ${alt_installer_Array[*]} " =~ " flatpak " ]]; then
			delete="flatpak"
			alt_installer_Array=( "${alt_installer_Array[@]/$delete}" )
			installing_flatpak_now
			installing_flatpak_apps_now
		fi
	apt_install_noninteractive_whith_error2info "${alt_installer_Array[@]}"
	echo_2_helper_list ""
fi

####################################
# gaming_Array
####################################

if [ ! -z "${gaming_Array[*]}" ]
then
	main_Gaming_now
fi

####################################
# emulators_Array
####################################

if [ ! -z "${emulators_Array[*]}" ]
then
	show_m "install emulators app "
	echo_2_helper_list "# emulators app"
	apt_install_noninteractive_whith_error2info "${emulators_Array[@]}"
	echo_2_helper_list ""
fi
}

full_install_all_picked_apps_now()
{
show_mf "full_install_all_picked_apps_now"
pre_install_all_picked_apps_now
install_all_picked_apps_now
post_install_all_picked_apps_now
unset dpkg_add_architecture_i386_status
}


##################################################################################################################################################
# Snap
##################################################################################################################################################

install_Snap_now()
{
show_m "Install Snap"
echo_2_helper_list "# Snap"
apt_install_whith_error_whitout_exit "${Install_snap_[@]}"
echo_2_helper_list ""
show_m "Install Snap core"
sudo snap install core &>> $debug_log
show_m "configure Snap"
sudo systemctl enable snapd
sudo systemctl start snapd
if [ ! -f "/etc/X11/Xsession.d/99snap" ]
then
	sudo ln -s /etc/profile.d/apps-bin-path.sh /etc/X11/Xsession.d/99snap || echo "can not link /etc/profile.d/apps-bin-path.sh to /etc/X11/Xsession.d/99snap"
fi
sudo sed  -i 's|/usr/local/games|/usr/local/games:/snap/bin|g' /etc/environment
}

##################################################################################################################################################
# flatpak
##################################################################################################################################################

installing_flatpak_now()
{
show_m "installing flatpak"
echo_2_helper_list "# flatpak"
apt_install_whith_error2info "${install_Flatpak_[@]}"
echo_2_helper_list ""
show_m "flatpak clean up"
flatpak remove --unused
}

installing_flatpak_apps_now()
{
show_m "adding flathub repo."
flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || show_em "can not add flathub repo."
show_m "installing flatpak apps "
flatpak_install_with_error2info "${Flatpak_apps_2_install[@]}"
echo_2_helper_list ""
}

##################################################################################################################################################
# Gaming
##################################################################################################################################################

main_Gaming_now()
{
# https://gitlab.com/rswat09/gamebuntu/
mkdir -p $temp_folder_for_gaming
cd $temp_folder_for_gaming

show_mf "main_Gaming_now"
echo_2_helper_list "# Gaming apps"

###################################
if [[ " ${gaming_Array[*]} " =~ " GameHub " ]]
then
	show_m "installing GameHub"
	if [ "$(dpkg-query -W --showformat='${db:Status-Status}' com.github.tkashkin.gamehub 2>&1)" = installed ]; then
		echo 'GameHub is already installed.'
	else
		add_new_source_to_apt_now mod "adv" repolink "deb http://ppa.launchpad.net/tkashkin/gamehub/ubuntu focal main" reponame "gamehub-ppa" keylink "keyserver.ubuntu.com" "5B63B42CE14BA47CC1B69E7C32B600D632AF380D"
		aptupdate
		apt_install_whith_error_whitout_exit "dirmngr"
		apt_install_whith_error_whitout_exit "com.github.tkashkin.gamehub"
	fi
fi
###################################
if [[ " ${gaming_Array[*]} " =~ " GOverlay " ]]
then
	show_m "installing GOverlay"
	if [ "$(dpkg-query -W --showformat='${db:Status-Status}' goverlay 2>&1)" = installed ]; then
	  echo 'GOverlay is already installed.'
	else
		if [ "$DISTRO" == "Ubuntu" ] || [ "$ubuntu_similar_DISTRO" == "true" ]; then
			add_new_source_to_apt_now mod "ppa" "flexiondotorg/mangohud"
		fi
		apt_install_whith_error_whitout_exit "goverlay"
	fi
fi
###################################
if [[ " ${gaming_Array[*]} " =~ " HeroicGamesLauncher " ]]
then
	show_m "installing HeroicGamesLauncher"
	if [ "$(dpkg-query -W --showformat='${db:Status-Status}' heroic 2>&1)" = installed ]; then
		  echo 'Heroic Games Launcher is already installed.'
	else
		heroic_latest_release=$(wget -qO- 'https://api.github.com/repos/Heroic-Games-Launcher/HeroicGamesLauncher/releases/latest' \
		  | grep '"browser_download_url"' \
		  | grep '.deb' \
		  | cut -f2,3 -d':' \
		  | tr -d '"')
		  newwget -o "$temp_folder_for_gaming/heroic.deb" $heroic_latest_release
		  apt_install_whith_error_whitout_exit "$temp_folder_for_gaming/heroic.deb"
	fi
fi
###################################
if [[ " ${gaming_Array[*]} " =~ " lowlatency " ]]
then
	show_m "installing lowlatency"
	if [ "$(dpkg-query -W --showformat='${db:Status-Status}' linux-lowlatency 2>&1)" = installed ]; then
		echo 'The lowlatency kernel is already installed.'
	else
		apt_install_whith_error_whitout_exit "linux-lowlatency"
	fi
fi
###################################
if [[ " ${gaming_Array[*]} " =~ " Lutris " ]]
then
	show_m "installing Lutris"
	if [ "$(dpkg-query -W --showformat='${db:Status-Status}' lutris 2>&1)" = installed ]; then
		echo 'Lutris is already installed.'
	else
		apt_install_whith_error_whitout_exit "lutris"
	fi
fi
###################################
if [[ " ${gaming_Array[*]} " =~ " MangoHud " ]]
then
	show_m "installing MangoHud"
	if [ "$(dpkg-query -W --showformat='${db:Status-Status}' mangohud 2>&1)" = installed ]; then
	  echo 'MangoHud is already installed.'
	else
		if [ "$DISTRO" == "Ubuntu" ] || [ "$ubuntu_similar_DISTRO" == "true" ]; then
			add_new_source_to_apt_now mod "ppa" "flexiondotorg/mangohud"
		fi
		apt_install_whith_error_whitout_exit "mangohud"
	fi
fi
###################################
if [[ " ${gaming_Array[*]} " =~ " vkbasalt " ]]
then
	show_m "installing vkbasalt"
	if [ "$(dpkg-query -W --showformat='${db:Status-Status}' vkbasalt 2>&1)" = installed ]; then
		echo 'vkbasalt is already installed.'
	else
		apt_install_whith_error_whitout_exit "vkbasalt"
	fi
fi
###################################
if [[ " ${gaming_Array[*]} " =~ " dosbox " ]]
then
	show_m "installing dosbox"
	if [ "$(dpkg-query -W --showformat='${db:Status-Status}' dosbox 2>&1)" = installed ]; then
		echo 'dosbox is already installed.'
	else
		apt_install_whith_error_whitout_exit "dosbox"
	fi
fi
###################################
if [[ " ${gaming_Array[*]} " =~ " mumble " ]]
then
	show_m "installing mumble"
	if [ "$(dpkg-query -W --showformat='${db:Status-Status}' mumble 2>&1)" = installed ]; then
		echo 'mumble is already installed.'
	else
		apt_install_whith_error_whitout_exit "mumble"
	fi
fi
###################################
if [[ " ${gaming_Array[*]} " =~ " yabause " ]]
then
	show_m "installing yabause"
	if [ "$(dpkg-query -W --showformat='${db:Status-Status}' yabause 2>&1)" = installed ]; then
		echo 'yabause is already installed.'
	else
		apt_install_whith_error_whitout_exit "yabause"
	fi
fi
###################################
if [[ " ${gaming_Array[*]} " =~ " playonlinux " ]]
then
	show_m "installing playonlinux"
	if [ "$(dpkg-query -W --showformat='${db:Status-Status}' playonlinux 2>&1)" = installed ]; then
		echo 'playonlinux is already installed.'
	else
		apt_install_whith_error_whitout_exit "playonlinux"
	fi
fi
###################################
if [[ " ${gaming_Array[*]} " =~ " retroarch " ]]
then
	show_m "installing retroarch"
	if [ "$(dpkg-query -W --showformat='${db:Status-Status}' retroarch 2>&1)" = installed ]; then
		echo 'retroarch is already installed.'
	else
		apt_install_whith_error_whitout_exit "retroarch"
	fi
fi
###################################
if [[ " ${gaming_Array[*]} " =~ " stella " ]]
then
	show_m "installing stella"
	if [ "$(dpkg-query -W --showformat='${db:Status-Status}' stella 2>&1)" = installed ]; then
		echo 'stella is already installed.'
	else
		apt_install_whith_error_whitout_exit "stella"
	fi
fi
###################################
if [[ " ${gaming_Array[*]} " =~ " Minigalaxy " ]]
then
	show_m "installing Minigalaxy"
	if [ "$(dpkg-query -W --showformat='${db:Status-Status}' minigalaxy 2>&1)" = installed ]; then
		echo 'Minigalaxy is already installed.'
	else
		apt_install_whith_error_whitout_exit "jq"
		minigalaxy_latest_release=$(wget -qO- 'https://api.github.com/repos/sharkwouter/minigalaxy/releases/latest' \
		  | grep '"browser_download_url"' \
		  | grep '.deb' \
		  | cut -f2,3 -d':' \
		  | tr -d '"')
		  newwget -o "$temp_folder_for_gaming/minigalaxy.deb" $minigalaxy_latest_release
		  apt_install_whith_error_whitout_exit "$temp_folder_for_gaming/minigalaxy.deb"
	fi
fi
###################################
if [[ " ${gaming_Array[*]} " =~ " OBS_Studio " ]]
then
	show_m "installing OBS_Studio"
	if [ "$(dpkg-query -W --showformat='${db:Status-Status}' obs-studio 2>&1)" = installed ]; then
		echo 'OBS Studio is already installed.'
	else
		apt_install_whith_error_whitout_exit "obs-studio"
	fi
fi
###################################
if [[ " ${gaming_Array[*]} " =~ " OpenRGB " ]]
then
	show_m "installing OpenRGB"
	if [ "$(dpkg-query -W --showformat='${db:Status-Status}' openrgb 2>&1)" = installed ]; then
	echo 'OpenRGB is already installed.'
	else
		apt_install_whith_error_whitout_exit "lsb-release"
		cd /tmp
		[[ "$(lsb_release -r)" == *'20.04'* ]] && \
		  wget -qO openrgb.deb https://openrgb.org/releases/release_0.7/openrgb_0.7_amd64_buster_6128731.deb \
		  || wget -qO openrgb.deb https://openrgb.org/releases/release_0.7/openrgb_0.7_amd64_bullseye_6128731.deb 
		apt_install_whith_error_whitout_exit "./openrgb.deb"
	fi
fi
###################################
if [[ " ${gaming_Array[*]} " =~ " Piper " ]]
then
	show_m "installing Piper"
	if [ "$(dpkg-query -W --showformat='${db:Status-Status}' piper 2>&1)" = installed ]; then
		echo 'Piper is already installed.'
	else
		apt_install_whith_error_whitout_exit "piper"
	fi
fi
###################################
if [[ " ${gaming_Array[*]} " =~ " Polychromatic " ]]
then
	show_m "installing Polychromatic"
	if [ "$(dpkg-query -W --showformat='${db:Status-Status}' polychromatic 2>&1)" = installed ]; then
		echo 'Polychromatic is already installed.'
	else
		add_new_source_to_apt_now mod "adv" repolink "deb http://ppa.launchpad.net/polychromatic/stable/ubuntu focal main" reponame "polychromatic" keylink "keyserver.ubuntu.com" "96B9CD7C22E2C8C5"
		add_new_source_to_apt_now mod "gpg" repolink "deb http://download.opensuse.org/repositories/hardware:/razer/Debian_Unstable/ /" reponame "hardware:razer" keylink "https://download.opensuse.org/repositories/hardware:razer/Debian_Unstable/Release.key" keyname "hardware_razer.gpg"
		aptupdate
		apt_install_whith_error_whitout_exit "openrazer-meta"
		apt_install_whith_error_whitout_exit "polychromatic"
	fi
fi
###################################
if [[ " ${gaming_Array[*]} " =~ " Steam " ]]
then
	show_m "installing Steam"
	if [ "$(dpkg-query -W --showformat='${db:Status-Status}' steam 2>&1)" = installed ]; then
		echo 'Steam is already installed.'
	else
		dpkg_add_architecture_i386
		echo steam steam/license note '' | sudo debconf-set-selections
		echo steam steam/question select "I AGREE" | sudo debconf-set-selections
		apt_install_whith_error_whitout_exit "steam"
		
	fi
fi
###################################
if [[ " ${gaming_Array[*]} " =~ " Wine " ]]
then
	show_m "installing Wine"
	if [ "$(dpkg-query -W --showformat='${db:Status-Status}' wine 2>&1)" = installed ]; then
		echo 'Wine is already installed.'
	else
		apt_install_whith_error_whitout_exit "wine wine64 wine-binfmt winetricks fonts-wine mpg123"
	fi
fi
###################################
if [[ " ${gaming_Array[*]} " =~ " WineHQ " ]]
then
	if [ "$DISTRO" == "Debian" ]; then
		add_new_source_to_apt_now mod "gpg" repolink "deb https://dl.winehq.org/wine-builds/${DISTRO,,}/ ${Codename,,} main" reponame "winehq" keylink "https://dl.winehq.org/wine-builds/winehq.key" keyname "winehq.gpg"
		dpkg_add_architecture_i386
	fi
	show_m "installing WineHQ"
	apt_install_whith_error_whitout_exit "winehq-staging"
fi
###################################
if [[ " ${gaming_Array[*]} " =~ " Extra " ]]
then
	show_m "installing extra"
	dpkg_add_architecture_i386
	apt_install_whith_error_whitout_exit "ttf-mscorefonts-installer dxvk dxvk-wine32-development dxvk-wine64-development libvkd3d1 xboxdrv vulkan-tools libgnutls30:i386 libldap-2.4-2:i386 libgpg-error0:i386 libsqlite3-0:i386 libxml2:i386 libsdl2-2.0-0:i386 libfreetype6:i386 libdbus-1-3:i386 libsdl-image1.2 libsdl-mixer1.2"
	if [ "$DISTRO" == "Ubuntu" ]; then
		apt_install_whith_error_whitout_exit "libasound2-plugins:i386"
		apt_install_whith_error_whitout_exit "mono-runtime-common"
	fi
fi
###################################
if [[ " ${gaming_Array[*]} " =~ " The_xanmod_kernel " ]]
then
	show_m "installing The_xanmod_kernel"
	if [ "$(dpkg-query -W --showformat='${db:Status-Status}' linux-xanmod 2>&1)" = installed ]; then
		echo 'The xanmod kernel is already installed.'
	else
		add_new_source_to_apt_now mod "gpg" repolink "deb http://deb.xanmod.org releases main" reponame "xanmod-kernel" keylink "https://dl.xanmod.org/gpg.key" keyname "xanmod-kernel.gpg"
		aptupdate && apt_install_whith_error_whitout_exit "linux-xanmod"
	fi
fi
###################################
if [[ " ${gaming_Array[*]} " =~ " ProtonUp_Qt " ]]
then
	installing_flatpak_now
	show_m "installing ProtonUp_Qt"
	if [ -d /var/lib/flatpak/app/net.davidotek.pupgui2 ]; then
		echo 'ProtonUp-Qt is already installed.'
	else
		flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || show_em "can not add flathub repo."
		flatpak install -y --noninteractive net.davidotek.pupgui2 &>> $debug_log || show_em "failed to install ProtonUp_Qt"
	fi
fi
###################################
if [[ " ${gaming_Array[*]} " =~ " Discord " ]]
then
	install_Snap_now
	show_m "installing Discord"
	if [ -f /snap/bin/discord ]; then
		echo 'Discord is already installed.'
	else
		sudo snap install discord &>> $debug_log || show_em "failed to install discord"
	fi
fi
###################################
if [[ " ${gaming_Array[*]} " =~ " GameMode " ]]
then
	show_m "installing GameMode"
	if [ "$(dpkg-query -W --showformat='${db:Status-Status}' gamemode 2>&1)" = installed ]; then
		echo 'GameMode is already installed.'
	else
		SHELL_EXT="$(which gnome-shell &>/dev/null && echo gnome-shell-extension-gamemode)"
		$sudoaptinstall gamemode $SHELL_EXT &>> $debug_log || show_em "failed to enable GNOME GameMode"
	fi
fi
###################################
if [[ " ${gaming_Array[*]} " =~ " NoiseTorch " ]]
then
	show_m "installing NoiseTorch"
	if [ -f "$HOME/.local/bin/noisetorch" ]; then
		echo 'NoiseTorch is already installed.'
	else
		wget -qO - https://api.github.com/repos/lawl/NoiseTorch/releases/latest \
		    | grep '/NoiseTorch_x64.tgz' \
		    | cut -d : -f 2,3 \
		    | tr -d \" \
		    | wget -qi -
		tar -C "$HOME" -xzf NoiseTorch_x64.tgz && gtk-update-icon-cache
		sudo setcap 'CAP_SYS_RESOURCE=+ep' "$HOME/.local/bin/noisetorch"
	fi
fi
echo_2_helper_list ""
}

############################################################################################################################################
############################################################################################################################################
dpkg_add_architecture_i386()
{
if [ "$dpkg_add_architecture_i386_status" != "enabled" ]
then
	show_m " adding dpkg --add-architecture i386"
	sudo dpkg --add-architecture i386
	aptupdate
	declare -g dpkg_add_architecture_i386_status="enabled"
fi
}
############################################################################################################################################
############################################################################################################################################
############################################################################################################################################
############################################################################################################################################
############################################################################################################################################
############################################################################################################################################
############################################################################################################################################

default_item_is="L"
create_APPS_CHOICES_Array_now_()
{
declare -ag APPS_CHOICES_Array_now_=("L" "list of apps to be installed")
for i in ${!name_of_all_array_now[*]}; do
	temp=${name_of_all_array_now[i]//_Array/}
	APPS_CHOICES_Array_now_+=("$temp" "install $temp apps.")
done
APPS_CHOICES_Array_now_+=("D" "select default." "A" "select all." "N" "dselect all." "C" "cancel." "F" "finshed")
}

show_app_menu_now()
{
echo "${APPS_CHOICES_Array_now_[@]}" >> /tmp/testtesteateatea.txt
CHOICES=$(whiptail --nocancel --menu "pick your apps" $(stty size) $whiptail_listheight "${APPS_CHOICES_Array_now_[@]}" --default-item $default_item_is 3>&1 1>&2 2>&3)
	for CHOICE in $CHOICES; do
		case "$CHOICE" in
		"L")
			default_item_is="L"
			local status=()
			for i in ${!name_of_all_array_now[*]}; do
				temp=${name_of_all_array_now[i]//_Array/}
				declare -n temp2="${name_of_all_array_now[i]}"
				status+="$temp apps: ${temp2[*]} \n "
			done
			local information=$(whiptail --title "Example Dialog" --scrolltext --msgbox " $status" $(stty size)  3>&1 1>&2 2>&3)
			show_app_menu_now
		;;
		"N")
			default_item_is="N"
			empty_all_apps_arrays
			show_app_menu_now
		;;
		"D")
			default_item_is="D"
			set_array_eq2_default_apps_array
			show_app_menu_now
		;;
		"A")
			default_item_is="A"
			set_array_eq2_select_All_apps_array
			show_app_menu_now
		;;
		"C")
			if (whiptail --title "Example Dialog" --yesno "Are you sure you want to cancel?." 8 78); then
			    do_you_want_to_install_essential_apps="false"
			    unset do_we_need_to_install_essential_apps
			else
			    show_app_menu_now
			fi
		;;
		"F")
		;;
		*)
			declare temp="$CHOICE"
			declare tempA="${temp}_Array"
			declare tempB="${temp}_Array_now_"
			declare -n temp1=$tempA
			declare -n temp2=$tempB
			
			default_item_is="$temp"
			temp1=$(whiptail --separate-output --checklist "Choose options" $(stty size) $whiptail_listheight "${temp2[@]}" 3>&1 1>&2 2>&3)
			temp1=($( echo $temp1 | tr '\n' ' '))
			show_app_menu_now
		;;
	esac
done
}

##############################################################################################
##############################################################################################
##############################################################################################


set_array_eq_2_select_default()
{
local x=0
local temp_array_4_now=("$@")
for ((i=0;i<${#temp_array_4_now[@]};i+=3)); do
	x=$(expr $i + 2)
	if [ "${temp_array_4_now[x]}" == "ON" ]
	then
	echo "${temp_array_4_now[i]}"
	fi
done
}

set_array_eq_2_select_All()
{
local temp_array_4_now=("$@")
for ((i=0;i<${#temp_array_4_now[@]};i+=3)); do
	echo "${temp_array_4_now[i]}"
done
}

pre_show_app_menu_now()
{

declare -g name_of_all_array_now=""
readarray -t name_of_all_array_now < <(grep $temp_folder_4_Remote_source_file/${Sourcing_list_of_apps_dot_sh##*/} -e "declare" | sed 's/.*declare -ag \(.*\)_now_=(/\1/')
to_be_deleted=()
for i in ${!name_of_all_array_now[*]}; do
	declare -n tmpArr="${name_of_all_array_now[i]}_now_"
	if [ ! -z "${tmpArr[*]}" ]
	then
		declare -g ${name_of_all_array_now[i]}=""
		declare -g default_${name_of_all_array_now[i]}=""
		declare -g allapps_${name_of_all_array_now[i]}=""

		declare -n tempA="default_${name_of_all_array_now[i]}"
		declare -n tempB="allapps_${name_of_all_array_now[i]}"
		declare -n tempC="${name_of_all_array_now[i]}_now_"

		tempA=($(set_array_eq_2_select_default "${tempC[@]}"))
		tempB=($(set_array_eq_2_select_All "${tempC[@]}"))
	else
		to_be_deleted="${name_of_all_array_now[i]}"
		name_of_all_array_now=( "${name_of_all_array_now[@]/$to_be_deleted}" )
		is_there_null_value_in_array="true"
	fi
done

if [ "$is_there_null_value_in_array" == "true" ]
then
	for i in "${!name_of_all_array_now[@]}"; do
		if [ ! -z "${name_of_all_array_now[i]}" ]
		then
			temp_name_of_all_array_now+=( "${name_of_all_array_now[i]}" )
		fi
	done
	name_of_all_array_now=("${temp_name_of_all_array_now[@]}")
	unset temp_name_of_all_array_now
fi
set_array_eq2_default_apps_array
create_APPS_CHOICES_Array_now_
}

empty_all_apps_arrays()
{
for i in ${!name_of_all_array_now[*]}; do
	declare -n tempA="${name_of_all_array_now[i]}"
	tempA=("")
done
}

set_array_eq2_default_apps_array()
{
for i in ${!name_of_all_array_now[*]}; do
	declare -n tempA="default_${name_of_all_array_now[i]}"
	declare -n tempB="${name_of_all_array_now[i]}"
	tempB=("${tempA[@]}")
done
}

set_array_eq2_select_All_apps_array()
{
for i in ${!name_of_all_array_now[*]}; do
	declare -n tempA="allapps_${name_of_all_array_now[i]}"
	declare -n tempB="${name_of_all_array_now[i]}"
	tempB=("${tempA[@]}")
done
}
