#!/bin/bash
set -e
[ "$(id -u)" -ne 0 ] && { echo "sudo not installed, so you must run script as root" 1>&2; exit 1; }

wifi_interface="$(ip link | awk -F: '$0 !~ "^[^0-9]"{print $2;getline}' | awk '/w/{ print $0 }')"
ip link set $wifi_interface up

if command -v wpa_supplicant &> /dev/null
then
	read -p "ssid:" ssid_var
	read -p "pass:" pass_var 
	wpa_passphrase "$ssid_var" "$pass_var" | tee wpa_passphrase_output
	unset ssid_var
	unset pass_var
	wpa_supplicant -c wpa_passphrase_output -i $wifi_interface & || exit 1
	dhclient $wifi_interface
	ping -c4 google.com || (echo "no internet connection" ; exit 1)
	rm wpa_passphrase_output
	apt-get update
	apt-get install -y network-manager
	killall wpa_supplicant
	systemctl start NetworkManager.service 
	systemctl enable NetworkManager.service
	nmcli dev wifi connect network-ssid password "network-password"
elif command -v nmcli &> /dev/null
	nmcli radio wifi on
	while :
	do
		nmcli --ask dev wifi connect && break
	fi
fi

if command -v curl &> /dev/null
then
	bash <(curl -s https://raw.githubusercontent.com/dari862/my-linux-script/main/installer.sh)
elif command -v wget &> /dev/null
	bash <(wget -q -O - https://raw.githubusercontent.com/dari862/my-linux-script/main/installer.sh)
fi
