create_wallpapers_folder_now()
{
show_m "creating wallpapers folder."

if [ ! -d "$wallpapers_location_now" ]
then
    sudo mkdir -p "$wallpapers_location_now"
fi

if [ "$gnome_desktop_environment" == "true"  ] 
then
    if [ ! -d "$gnome_wallpaper_folder" ]
    then
        sudo mkdir -p "$gnome_wallpaper_folder"
    fi
    sudo ln -s $wallpapers_location_now $gnome_wallpaper_folder
fi

if [ "$kde_desktop_environment" == "true"  ]
then
    if [ ! -d "$kde_wallpaper_folder" ]
    then
        sudo mkdir -p "$kde_wallpaper_folder"
    fi
    sudo ln -s $wallpapers_location_now $kde_wallpaper_folder
fi
}

wallpaper_download_Now()
{
show_mf "wallpaper_download_Now"
create_wallpapers_folder_now
show_m "downloading wallpapers."
mkdir -p $foldertempfornow
cd $foldertempfornow
svn-export https://github.com/dari862/my-linux-script/trunk/data/wallpaper

if [ "$1" == "extra" ]
then
	svn-export https://github.com/dari862/wallpapers/trunk/wallpaper
fi

sudo mv $foldertempfornow/wallpaper/* $wallpapers_location_now
sudo chown -R root:root $wallpapers_location_now
}

system_configration_now()
{
show_m "Edit Time "
sudo timedatectl set-timezone Asia/Kuwait
if [ "$kde_desktop_environment" == "true"  ] || [ "$gnome_desktop_environment" == "true"  ] 
then
show_m "making some folders "
mkdir -p $HOME/.config/autostart/
fi
}

Config_users_home_directorie_permissions_to_750_now()
{
show_m "Config users home directories permissions to 750 (for current and future users)"
# INFO: By default home directories permissions are 755 and grant read permissions to everyone
# Config adduser for create users with $HOME permisions 0750
[ -f /etc/adduser.conf ] && sudo sed -i 's/DIR_MODE=[0-9]*/DIR_MODE=0750/g' /etc/adduser.conf

for d in  /home/*/; do
    [ "$(dirname "$d")" = "/home" ] && ! id "$(basename "$d")" &>/dev/null && continue	# Skip dirs that no are homes 
	# Set current home permissions
	sudo chmod -v 0750 "$d"
done
}

Disable_some_unnecessary_services_now()
{
show_m "Disable some unnecessary services"
# INFO: Some boot services included in Debian are unnecesary for most usres (like NetworkManager-wait-online.service, ModemManager.service or pppd-dns.service)

sudo systemctl stop NetworkManager-wait-online.service &>> $debug_log || show_im "fail to stop NetworkManager-wait-online.service"
sudo systemctl mask NetworkManager-wait-online.service &>> $debug_log || show_im "fail to mask NetworkManager-wait-online.service"

sudo systemctl stop wpa_supplicant &>> $debug_log || show_im "fail to stop wpa_supplicant"
sudo systemctl disable wpa_supplicant &>> $debug_log || show_im "fail to disable wpa_supplicant"	# No mask, may be needed by network manager

sudo systemctl stop ModemManager.service &>> $debug_log || show_im "fail to stop ModemManager.service"
sudo systemctl disable ModemManager.service &>> $debug_log || show_im "fail to disable ModemManager.service"

sudo systemctl stop pppd-dns.service &>> $debug_log || show_im "fail to stop pppd-dns.service"
sudo systemctl disable pppd-dns.service &>> $debug_log || show_im "fail to disable pppd-dns.service"

if systemctl status NetworkManager.service &>/dev/null; then
	#apt-get purge ifupdown; rm -rf /etc/network/*
	sudo systemctl networking disable &>> $debug_log || show_im "fail to disable networking"

	#apt-get purge network-dispacher
	sudo systemctl stop systemd-networkd.service &>> $debug_log || show_im "fail to stop systemd-networkd.service"
	sudo systemctl disable systemd-networkd.service &>> $debug_log || show_im "fail to disable systemd-networkd.service"
fi

}

libaoconf_use_PulseAudio_() {
	libaoconf="/etc/libao.conf"
	show_m "Configuring ${libaoconf} to use PulseAudio instead of ALSA."
	sudo cp ${libaoconf} ${libaoconf}_ALSA.backup
	sudo sh -c "echo 'default_driver=pulse' > ${libaoconf}"
}

disable_pulseaudio_suspend(){
  pulseconfig="/etc/pulse/default.pa"
  show_m "Disabling suspend on PulseAudio when sinks/sources idle."
  if [ -f ${pulseconfig} ]; then
    sudo sed -i "s/^load-module module-suspend-on-idle$/#load-module module-suspend-on-idle/g" ${pulseconfig}
  else
    show_em "PulseAudio config file missing. Exiting."
  fi
}

enable_intel_iommu(){
	grubdefault="/etc/default/grub"
	grubcfg="/boot/grub/grub.cfg"
	show_m "Enabling Intel IOMMU"
    # "Setting Intel IOMMU kernel parameter."
    if [ -f "${grubdefault}" ]; then
      local oldline
      local bootparams
      oldline=$(grep ^GRUB_CMDLINE_LINUX= "${grubdefault}")
      bootparams=$(echo "${oldline}" | sed -n "s/^GRUB_CMDLINE_LINUX=\"\(.*\)\"/\1/p")
      if [[ ${bootparams} =~ intel_iommu= ]]; then
        sudo sed -i "s|intel_iommu=\(on\|off\|0\|1\)|intel_iommu=on|g" ${grubdefault}
      else
        if test "${bootparams}"; then
          sudo sed -i "s|${bootparams}|${bootparams} intel_iommu=on|g" ${grubdefault}
        else
          sudo sed -i "s|${oldline}|GRUB_CMDLINE_LINUX=\"intel_iommu=on\"|g" ${grubdefault}
        fi
        sudo sed -i "\|^GRUB_CMDLINE_LINUX=| a\#${oldline}" ${grubdefault} # backup
        sudo grub-mkconfig -o ${grubcfg}
      fi
    fi
    if [[ "$(sudo bootctl is-installed)" = yes ]]; then
      local cmdline
      for entry in "$(bootctl -p)"/loader/entries/*.conf; do
        cmdline=$(sed -n "s/^options\s\+\(.*\)/\1/p" "${entry}")
        if [[ ${cmdline} =~ intel_iommu= ]]; then
          sudo sed -i "s|intel_iommu=\(1\|0\)|intel_iommu=on|g" "${entry}"
        else
          if test "${cmdline}"; then
            sudo sed -i "s|${cmdline}|${cmdline} intel_iommu=on|g" ${grubdefault}
          else
            echo "options	intel_iommu=on" | sudo tee -a "${entry}"
          fi
        fi
      done
    fi
}

disable_11n_now_() {
  iwlwificonf="/etc/modprobe.d/iwlwifi.conf"
  show_m "Disabling 802.11n networking in iwlwifi."
  if ! [ "$(ls -A /etc/modprobe.d/)" ]; then
    sudo sh -c "echo 'options iwlwifi 11n_disable=1' >> ${iwlwificonf}"
  else
    if ! find /etc/modprobe.d/ -type f \
         -exec grep "^options iwlwifi .*11n_disable=1.*" {} + >/dev/null 2>&1; then
      sudo sh -c "echo 'options iwlwifi 11n_disable=1' >> ${iwlwificonf}"
    else
      show_im "11n_disable=1 flag is already set."
    fi
  fi
  echo "802.11n networking disabled in ${iwlwificonf}."
}
