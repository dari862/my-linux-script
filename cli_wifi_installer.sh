#!/bin/bash
set -e

[ "$(id -u)" -ne 0 ] && { echo "you must run script as root" 1>&2; exit 1; }
wifi_interface="$(ip link | awk -F: '$0 !~ "^[^0-9]"{print $2;getline}' | awk '/w/{ print $0 }')"

run_wpa_supplicant_now()
{
	tmpfile="$(mktemp)"
	echo -e "\n These hotspots are available \n"
	iwlist $wifi_interface scan | grep ESSID | sed 's/ESSID://g;s/"//g;s/^                    //g'
	read -p "ssid:" ssid_var
	(iw $wifi_interface scan | grep 'SSID' | grep "$ssid_var") || (echo "wrong ssid")
	read -p "pass:" pass_var 
	wpa_passphrase "$ssid_var" "$pass_var" | tee $tmpfile
	wpa_supplicant -B -c $tmpfile -i $wifi_interface &
	echo "sleep 10"
	sleep 10 
	dhclient $wifi_interface
	ping -c4 google.com || (echo "no internet connection" ; exit 1)
	rm $tmpfile
	apt-get update
	apt-get install -y network-manager
	killall wpa_supplicant
	nmcli dev wifi connect $ssid_var password "$pass_var"	
	unset ssid_var
	unset pass_var
}

run_nmcli_now()
{
	nmcli radio wifi on
	while :
	do
		nmcli --ask dev wifi connect && break
	done
}

install_my_linux_script_now()
{
if command -v curl &> /dev/null
then
	bash <(curl -s https://raw.githubusercontent.com/dari862/my-linux-script/main/installer.sh)
elif command -v wget &> /dev/null
then
	bash <(wget -q -O - https://raw.githubusercontent.com/dari862/my-linux-script/main/installer.sh)
fi
}

main()
{	
	if [ -z "$wifi_interface" ]
	then
		echo "no wifi interface"
		exit 1
	fi
	
	ip link set $wifi_interface up
	
	if command -v nmcli &> /dev/null
	then
		run_nmcli_now
	elif command -v wpa_supplicant &> /dev/null
	then
		run_wpa_supplicant_now
	fi
	install_my_linux_script_now
}

main
