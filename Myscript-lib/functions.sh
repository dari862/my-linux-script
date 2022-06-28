pre_script_now_now()
{
echo "pre_script_now_now."
# Reset the log files
mkdir -p $folder_to_my_script_linux_log
printf '' >> $debug_log >> $error_log >> $info_log

stop_unattended_upgrades_if_installed_now &>> $debug_log
aptupdate
install_whiptail_now
}

pre_install_script_now()
{
exec 3>&1
exec > ${debug_log} 2> >(tee ${error_log} >&1)
#########################
#show_wm (show welcoming massage)
show_wm "sourcing remotely source files."
show_mf "sourcing remotely source files."
Sourcing_Remote_Files_now
install_svn_now
install_wget_now
mkdir -p $temp_folder_for_skel_
mkdir -p $temp_folder_for_usr_bin_
mkdir -p $temp_folder_for_themes_and_apps
cp -r /etc/skel/. $temp_folder_for_skel_
}

###########################################################################################################################################################################
###########################################################################################################################################################################

mv_Temp_skel_folder_to_etc_skel_folder_now()
{
show_mf "mv_Temp_skel_folder_to_etc_skel_folder_now."

if [ -d $temp_folder_for_usr_bin_ ]
then
	sudo chown -R root:root $temp_folder_for_usr_bin_
	sudo cp -rv $temp_folder_for_usr_bin_/* "/usr/local/bin/"
fi

sudo cp -r $temp_folder_for_skel_/. /etc/skel/.
sudo chown -R root:root /etc/skel/

for d in /home/*/ ; do
	[ "$(dirname "$d")" = "/home" ] && ! id "$(basename "$d")" &>/dev/null && continue	# Skip dirs that no are homes 
	rm_if_link "$d.bashrc"
	rm_if_link "$d.profile"
	rm_if_link "$d.zprofile"
	rm_if_link "$d.Xresources"
	sudo cp -r /etc/skel/. "$d"
	sudo chown -R $(stat "$d" -c %u:%g) "$d"
done
}

###########################################################################################################################################################################
###########################################################################################################################################################################

if_error_exit_with_this_function_now()
{
restore_unattended_upgrades_if_installed_now
show_mf "error"
show_m "create_full_logs_now"
create_full_logs_now
show_m "clean_up_now"
clean_up_now

show_mf "error existing script"
show_m "error existing script"
}

stop_unattended_upgrades_if_installed_now()
{
if [ "$is_unattended_upgrades_installed_" == "false" ]
then
	return 0
fi

if [[ ! -f /etc/apt/apt.conf.d/20auto-upgrades ]]; then
	echo 'APT::Periodic::Update-Package-Lists "1";'| sudo tee /etc/apt/apt.conf.d/20auto-upgrades
	echo 'APT::Periodic::Unattended-Upgrade "1";' | sudo tee -a /etc/apt/apt.conf.d/20auto-upgrades
fi

if [[ ! -f /etc/apt/apt.conf.d/20auto-upgrades ]]; then
	is_unattended_upgrades_installed_="false"
	return 0
fi

if [[ ! -f /etc/apt/apt.conf.d/20auto-upgrades.bak ]]; then
	sudo cp /etc/apt/apt.conf.d/20auto-upgrades /etc/apt/apt.conf.d/20auto-upgrades.bak
	echo 'APT::Periodic::Update-Package-Lists "0";'| sudo tee /etc/apt/apt.conf.d/20auto-upgrades
	echo 'APT::Periodic::Unattended-Upgrade "0";' | sudo tee -a /etc/apt/apt.conf.d/20auto-upgrades
fi
sudo systemctl stop unattended-upgrades
}

restore_unattended_upgrades_if_installed_now()
{
if [ "$is_unattended_upgrades_installed_" == "false" ]
then
	return 0
fi

sudo rm /etc/apt/apt.conf.d/20auto-upgrades
sudo mv /etc/apt/apt.conf.d/20auto-upgrades.bak /etc/apt/apt.conf.d/20auto-upgrades
}

does_folder_or_file_exsist_if_yes_remove()
{
local folder_or_file_name="$1"
if [ -d "$folder_or_file_name" ]
then
rm -rdf "$folder_or_file_name"
fi

if [ -f "$folder_or_file_name" ]
then
rm -rdf "$folder_or_file_name"
fi
}

#####################################################################################
#####################################################################################
add_new_source_to_apt_now()
{
# add_new_source_to_apt_now -repolink "" -reponame "" -keylink "" -keyname ""
# add_new_source_to_apt_now -repolink "&&" -reponame "" -keylink "" -keyname "" # && for multible links

if [ "$2" == "ppa" ]; then
	if command -v add-apt-repository &>/dev/null; then
		sudo add-apt-repository -y ppa:$1 &>> $debug_log || show_im "failed to add $1 repo"
	else
		aptupdate
		$sudoaptinstall "software-properties-common" &>> $debug_log 
		sudo add-apt-repository -y ppa:$1 &>> $debug_log || show_im "failed to add $1 repo"
	fi
return 1
fi

local repolink="$4"
if [[ "$repolink" == *"&&"* ]]; then
    local link1=${repolink%&&*}
    local limk2=${repolink#*&&}
    echo $link1 | sudo tee /etc/apt/sources.list.d/$6.list &>> $debug_log || show_im "failed to install $link1"
    echo $limk2 | sudo tee -a /etc/apt/sources.list.d/$6.list &>> $debug_log || show_im "failed to install $limk2"
else
    echo "$4" | sudo tee /etc/apt/sources.list.d/$6.list &>> $debug_log || show_im "failed to install $4"
fi

if [ "$2" == "gpg" ]; then
	if [ -z "$(command -v gpg)" ]; then
		install_gpg_now
	fi
	curl -fsSL "$8" | gpg --dearmor > /tmp/${10} && sudo chown root:root /tmp/${10} && sudo mv /tmp/${10} /etc/apt/trusted.gpg.d
fi

if [ "$2" == "asc" ]; then
	curl -s "$8" | sudo tee /usr/share/keyrings/${10} >/dev/null
fi

if [ "$2" == "adv" ]; then
	sudo apt-key adv --recv-keys --keyserver "$8" "$9" &>/dev/null
fi
}

#####################################################################################
#####################################################################################
echo_2_helper_list()
{
echo "$1" >> $helper_list
}

check_for_internet_now_plz()
{
case "$(curl -s --max-time 2 -I https://www.google.com | head -n 1 | sed 's/^[^ ]*  *\([0-9]\).*/\1/; 1q')" in
	[23]) show_im "connectivity is up";;
	5) show_em "The web proxy won't let us through";;
	*) show_em "The network is down or very slow";;
esac
}

check_for_internet_then_if_up_continue_plz()
{
local internet_status=""
case "$(curl -s --max-time 2 -I https://www.google.com | head -n 1 | sed 's/^[^ ]*  *\([0-9]\).*/\1/; 1q')" in
	[23]) internet_status="up";;
	*) internet_status="down";;
esac

while [ "internet_status" == "down" ]
do
	ping $GATEWAY__IP__ -c 4 && break
	sleep 15
	echo "gateway is down ..."
	internet_status_right_now_is="gateway is up"
	
done

if [ "internet_status" == "down" ]
then
	echo "gateway is up ..."
	internet_status_right_now_is="gateway is up"
fi

while [ "internet_status" == "down" ]
do
	show_em "waiting for internet ..." || echo "waiting for internet ..."
	sleep 15
	case "$(curl -s --max-time 2 -I https://www.google.com | head -n 1 | sed 's/^[^ ]*  *\([0-9]\).*/\1/; 1q')" in
		[23]) internet_status="up";;
		*) internet_status="down";;
	esac
	internet_status_right_now_is="internet is down"
done

if [ "internet_status" == "down" ]
then
	echo "internet is up ..."
fi
internet_status_right_now_is="internet is up"
}

aptupdate()
{
check_for_internet_then_if_up_continue_plz
echo "updating your system"
sudo apt-get update &>> $debug_log
}

svn-export()
{
local failed_to_svn_now="false"
n=0
while [ "$n" -le 5 ]
do
   failed_to_svn_now="false"
   svn export $1 --force &>> $debug_log && break  || (check_for_internet_now_plz && svn export $1 --force &>> $debug_log && break) || failed_to_svn_now="true"
   if [ "$failed_to_svn_now" == "true" ]
   then
   show_im "failed to svn export $1 "
   fi   
   n=$((n+1)) 
   sleep 15
done

if [ "$failed_to_svn_now" == "true" ]
then
	show_em "failed to svn export $1 "
fi

}

git-clone()
{
local git_clone_failed="false"
local git_clone_download_url="$1"
local git_clone_download_path="$2"
rmove_this_sting_please=".git"
if [ -z "$git_clone_download_path" ]
then
	git_clone_download_path=${git_clone_download_url##*/}
	if [[ "$git_clone_download_path" == *"$rmove_this_sting_please" ]]
	then
		git_clone_download_path=${git_clone_download_path%"$rmove_this_sting_please"}
	fi
fi

n=0
while [ "$n" -le 5 ]
do
   git_clone_failed="false"
   git clone $1 $2 &>> $debug_log && break || (check_for_internet_now_plz && git clone $1 $2 &>> $debug_log && break) || git_clone_failed="true"
   
   if [ "$git_clone_failed" == "true" ]
   then
   show_im "failed to git clone $1"
   rm -rdf $git_clone_download_path
   fi
   
   n=$((n+1)) 
   sleep 15
done

if [ "$git_clone_failed" == "true" ]
then
	show_em "failed to git clone $1"
fi
}

_in_error__exit(){ (show_em "failed to wget $1" && exit 1) ; }

newwget()
{
  case "${1}" in
    -P)
      wget -P $2 $3 &>> $debug_log || (check_for_internet_now_plz && wget -P $2 $3 &>> $debug_log) || _in_error__exit $3;;
    -O)
      wget -O - $2 &>> $debug_log || (check_for_internet_now_plz && wget -O - $2 &>> $debug_log) || _in_error__exit $2;;
    -o)
      wget -O $2 $3 &>> $debug_log || (check_for_internet_now_plz && wget -O $2 $3 &>> $debug_log) || _in_error__exit $3;;
    *)
      wget $1 &>> $debug_log || (check_for_internet_now_plz && wget $1 &>> $debug_log) || _in_error__exit $1;;
  esac
}

keep_Sudo_refresed()
{
	while [ 1 ]
		do
			sudo -v
			sleep 10m
		done
}

#####################################################################################
#####################################################################################

apt_purge_with_error()
{
localarray=("$@")
for package in "${localarray[@]}"
do
	if dpkg -s "${package}" &>/dev/null; then
		show_m "Purging ${package}."
		sudo apt-get -y purge "$package" &>> $debug_log || show_em " Failed to purge $package "
	else
		show_em "Package ${package} is not installed. Skipping."
	fi
done

}

apt_purge_with_error2info()
{
localarray=("$@")
for package in "${localarray[@]}"
do
	if dpkg -s "${package}" &>/dev/null; then
		show_m "Purging ${package}."
		sudo apt-get -y purge "$package" &>> $debug_log || show_im " Failed to purge $package "
	else
		show_im "Package ${package} is not installed. Skipping."
	fi
done

}

#####################################################################################
#####################################################################################

apt_install_whith_error2info()
{
localarray=("$@")
for INDEX in "${localarray[@]}"
do
if ! dpkg -s "${INDEX}" > /dev/null 2>&1; then
	$sudoaptinstall "$INDEX" &>> $debug_log && printf "$INDEX " >> $helper_list && show_m "${INDEX} now installed." || show_im " Failed to install $INDEX "
else
	show_im "${INDEX} is already installed."
fi
done
}

apt_if_install_whith_error2info()
{
localarray=("$@")
local fist_app="${localarray[0]}"
local second_app="${localarray[1]}"
if ! dpkg -s "${INDEX}" > /dev/null 2>&1; then
	$sudoaptinstall "$fist_app" &>> $debug_log && printf "$fist_app " >> $helper_list || $sudoaptinstall "$second_app" &>> $debug_log && printf "$second_app " >> $helper_list || show_im " Failed to install $fist_app and $second_app . "
else
	show_im "${INDEX} is already installed."
fi
}

apt_install_whith_error_whitout_printf_2_helper_list_and_without_exit()
{
localarray=("$@")
for INDEX in "${localarray[@]}"
do
	if ! dpkg -s "${INDEX}" > /dev/null 2>&1; then
		$sudoaptinstall "$INDEX" &>> $debug_log && show_m "${INDEX} now installed." || show_em " Failed to install $INDEX "
	else
		show_im "${INDEX} is already installed."
	fi
done
}

apt_install_whith_error_whitout_exit()
{
localarray=("$@")
for INDEX in "${localarray[@]}"
do
	if ! dpkg -s "${INDEX}" > /dev/null 2>&1; then
		$sudoaptinstall "$INDEX" &>> $debug_log && printf "$INDEX " >> $helper_list && show_m "${INDEX} now installed." || show_em " Failed to install $INDEX "
	else
		show_im "${INDEX} is already installed."
	fi
done
}

apt_install_whith_error()
{
localarray=("$@")
for INDEX in "${localarray[@]}"
do
	if ! dpkg -s "${INDEX}" > /dev/null 2>&1; then
		$sudoaptinstall "$INDEX" && printf "$INDEX " >> $helper_list && show_m "${INDEX} now installed." 
	else
		show_im "${INDEX} is already installed."
	fi
done
}

apt_install_noninteractive_whith_error2info()
{
localarray=("$@")
for INDEX in "${localarray[@]}"
do
	if ! dpkg -s "${INDEX}" > /dev/null 2>&1; then
		$sudoaptinstall_noninteractive "$INDEX" &>> $debug_log && printf "$INDEX " >> $helper_list && show_m "${INDEX} now installed." || show_im " Failed to install $INDEX "
	else
		show_im "${INDEX} is already installed."
	fi
done
}

apt_install_noninteractive_whith_error_whitout_exit()
{
localarray=("$@")
for INDEX in "${localarray[@]}"
do
	if ! dpkg -s "${INDEX}" > /dev/null 2>&1; then
		$sudoaptinstall "$INDEX" &>> $debug_log && printf "$INDEX " >> $helper_list && show_m "${INDEX} now installed." || show_em " Failed to install $INDEX "
	else
		show_im "${INDEX} is already installed."
	fi
done
}

apt_install_noninteractive_whith_error()
{
localarray=("$@")
for INDEX in "${localarray[@]}"
do
	if ! dpkg -s "${INDEX}" > /dev/null 2>&1; then
		$sudoaptinstall_noninteractive "$INDEX" &>> $debug_log && printf "$INDEX " >> $helper_list && show_m "${INDEX} now installed." 
	else
		show_im "${INDEX} is already installed."
	fi
done
}

#####################################################################################
#####################################################################################

flatpak_install_with_error2info()
{
localarray=("$@")
for INDEX in "${localarray[@]}"
do
	$flatpakinstall "$INDEX" &>> $debug_log && printf "$INDEX " >> $helper_list && show_m "${INDEX} now installed." || show_em " Failed to flatpak install $INDEX "
done
}

#####################################################################################
#####################################################################################
#####################################################################################
#####################################################################################

RED='\033[0;31m'
GREEN='\033[0;32m'
Yellow='\033[0;33m'
Blue='\033[0;34m'
NC='\033[0m' # No Color

show_progress_list_at_stage()
{
clear
printf "\n"
printf "\n"
printf "################################################################## \n"
printf "${GREEN} Running script now  ${NC} \n"  >&3
printf "################################################################## \n"
printf "\n"
printf " $internet_status_right_now_is"
printf "\n"
#Stages_list defined in previce stage (installer.sh)
for INDEX in ${!Stages_list[*]}
do
newINDEX=$(expr $INDEX + 1) # $INDEX start at 0 we need to incress it by 1
if [ "$we_are_at_stage" -gt $newINDEX ] 
then
	if [ "${Stages_list[$INDEX]}" != "" ]
	then
	printf " 	[✅] ${Stages_list[$INDEX]} \n"
	fi
elif [ "$we_are_at_stage" -eq $newINDEX ] 
then
	if [ "${Stages_list[$INDEX]}" != "" ]
	then
	printf " 	[⚪] ${Stages_list[$INDEX]} \n"
	fi
else
	if [ "${Stages_list[$INDEX]}" != "" ]
	then
	printf " 	[  ] ${Stages_list[$INDEX]} \n"
	fi
fi
done
 printf "\n"
 printf "\n"
 
 printf "running main function is        : $running_function_show_it_in_progress_list \n"
 printf "running name of sub function is : \n"
 printf "	$sub_massage_in_running_function_show_it_in_progress_list \n"
 printf "	$prev1_sub_massage_in_running_function_show_it_in_progress_list \n"
 printf "	$prev2_sub_massage_in_running_function_show_it_in_progress_list \n"
 printf "\n"
 printf "####################\n"
 printf "error_log\n"
 printf "####################\n"
 cat $error_log
}

show_m()
{
prev2_sub_massage_in_running_function_show_it_in_progress_list="$prev1_sub_massage_in_running_function_show_it_in_progress_list"
prev1_sub_massage_in_running_function_show_it_in_progress_list="$sub_massage_in_running_function_show_it_in_progress_list"
sub_massage_in_running_function_show_it_in_progress_list="$1"
show_progress_list_at_stage >&3
printf "################################################################## \n"
printf "++ $1 \n"
printf "################################################################## \n"
}

show_em()
{
printf "++ $1 \n" >&2
show_progress_list_at_stage >&3
printf "################################################################## \n"
printf "++ $1 \n"
printf "################################################################## \n"
}

show_im()
{
printf "++ $1 \n" >> $info_log
show_progress_list_at_stage >&3
printf "################################################################## \n"
printf "++ $1 \n"
printf "################################################################## \n"
}

show_wm()
{
clear >&3
printf "\n" >&3
printf "\n" >&3
printf "################################################################## \n" >&3
printf "${GREEN} Running script now  ${NC} \n"  >&3
printf "################################################################## \n" >&3
printf "\n" >&3
printf "${RED}++${GREEN} $1 ${NC} \n"  >&3
printf "################################################################## \n"
printf "++ $1 \n"
printf "################################################################## \n"
}

show_mf()
{
running_function_show_it_in_progress_list="$1"
show_progress_list_at_stage >&3
printf "################################################################## \n"
printf "++ $1 \n"
printf "################################################################## \n"
}

create_full_logs_now()
{
show_progress_list_at_stage > $temp_full_log_file
if [ -f $missing_content_from_preWM_config_files ]
then
	echo "" >> $temp_full_log_file
	echo "####################################" >> $temp_full_log_file
	echo "# missing_content_from_preWM_config_files" >> $temp_full_log_file
	echo "####################################" >> $temp_full_log_file
	echo "" >> $temp_full_log_file
	cat $missing_content_from_preWM_config_files >> $temp_full_log_file
fi
echo "" >> $temp_full_log_file
echo "####################################" >> $temp_full_log_file
echo "# info log" >> $temp_full_log_file
echo "####################################" >> $temp_full_log_file
echo "" >> $temp_full_log_file
cat $info_log >> $temp_full_log_file
echo "" >> $temp_full_log_file
echo "####################################" >> $temp_full_log_file
echo "####################################" >> $temp_full_log_file
echo "####################################" >> $temp_full_log_file
echo "# debug log" >> $temp_full_log_file
echo "####################################" >> $temp_full_log_file
echo "" >> $temp_full_log_file
cat $debug_log >> $temp_full_log_file
mv -f $temp_full_log_file $final_full_log_file
}

Done_installing_Massage_now()
{
sleep 0.5
clear
running_function_show_it_in_progress_list="rebooting!"
show_progress_list_at_stage >&3
create_full_logs_now
if [ "$Tweak_my_terminal_status_now" == "true" ]
then
add_aliases_2_helper_list_now
fi
cat $helper_list > ~/installed_apps.txt
}



#####################################################################################
#####################################################################################

add_installed_apps_helper_list_now()
{
echo "####################################" >> $helper_list 
echo "#newly installed apps" >> $helper_list 
echo "####################################" >> $helper_list 
echo "" >> $helper_list 
}

add_aliases_2_helper_list_now()
{
echo "" >> $helper_list 
echo "####################################" >> $helper_list 
echo "# aliases" >> $helper_list 
echo "####################################" >> $helper_list 
echo "" >> $helper_list 
cat $soursepimpmyterminalfolder_fullpath/aliases >> $helper_list 
cat $soursepimpmyterminalfolder_fullpath/bash_only_aliases >> $helper_list 
cat $soursepimpmyterminalfolder_fullpath/zsh_only_aliases >> $helper_list 
echo "##########" >> $helper_list 
echo "# conky" >> $helper_list
echo "##########" >> $helper_list 
cat $soursepimpmyterminalfolder_fullpath/conky-aliases >> $helper_list 
echo "##########" >> $helper_list 
echo "#komorebi" >> $helper_list
echo "##########" >> $helper_list 
cat $soursepimpmyterminalfolder_fullpath/komorebi/komorebi-aliases >> $helper_list  
echo "##########" >> $helper_list 
echo "#functions" >> $helper_list
echo "##########" >> $helper_list 
cat $soursepimpmyterminalfolder_fullpath/functions >> $helper_list 
echo "" >> $soursepimpmyterminalfolder_fullpath/aliases
cat $helper_list > $soursepimpmyterminalfolder_fullpath/helper_list.txt
echo 'alias help-now="cat $BASHDOTDIR/helper_list.txt "' >> $soursepimpmyterminalfolder_fullpath/bash_only_aliases
echo 'alias help-now="cat $zshdotfiles/helper_list.txt "' >> $soursepimpmyterminalfolder_fullpath/zsh_only_aliases
}

#####################################################################################
#####################################################################################

clean_up_now()
{
show_mf "clean_up_now"
show_m "removing not needed dotfiles"

mkdir -p /tmp/clean_up_now_trash_folder

remove_this_Array=(
.Xauthority
.xsession-errors
.subversion
.wget-log
.wget-hsts
.zcompdump
.zshrc
.zshenv
.zsh_history
.zcompdump.zwc
.zshrc.zwc
.zshenv.zwc
.zsh_history.zwc
.bash_history
.bash_logout
.bash_login
.fehbg
.gnupg
.gtkrc-2.0
.dbus
.ICEauthority
)
for i in ${!remove_this_Array[*]}; do
 mv "${HOME}/${remove_this_Array[$i]}" /tmp/clean_up_now_trash_folder  &> /dev/null || show_im "${remove_this_Array[$i]} file does not exsist" ;
done

declare -a StringArray=(subversion xterm)
apt_purge_with_error2info "${StringArray[@]}"

declare -a StringArray=(
sassc
libsass1
libxml2-utils
)
apt_purge_with_error2info "${StringArray[@]}"

if [ "$DISTRO" != "Pop" ]
then
declare -a StringArray=(
make
)
apt_purge_with_error2info "${StringArray[@]}"
fi

if [ "$DISTRO" != "Pop" ] && [ -z "$(command -v networkmanager_dmenu)" ]
then
declare -a StringArray=(
libglib2.0-dev-bin
)
apt_purge_with_error2info "${StringArray[@]}"
fi

sudo apt-get autoremove -y
sudo apt-get autoclean -y
#sudo chown -R $USER:$USER /home/$USER/.config &>> $debug_log || echo ""
#sudo chown -R $USER:$USER /home/$USER/.local &>> $debug_log || echo ""
#sudo chown -R $USER:$USER /home/$USER &>> $debug_log || echo ""
create_full_logs_now
}

#####################################################################################
#####################################################################################

upgrade_my_system_now()
{
restore_unattended_upgrades_if_installed_now
show_mf "upgrade_my_system_now"
for run in {1..3}; do
	sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade &>> $debug_log || show_em "failed to upgrade."
done
}

#####################################################################################
#####################################################################################

install_whiptail_now()
{
if [ -z "$(command -v whiptail)" ]
then
	echo "installing whiptail please wait"
	$sudoaptinstall whiptail
else
	echo "whiptail already installed"
fi
}

install_svn_now()
{
if [ -z "$(command -v svn)" ]
then
	show_m "installing subversion please wait"
	$sudoaptinstall subversion
else
	show_m "subversion already installed"
fi
}

install_wget_now()
{
if [ -z "$(command -v wget)" ]
then
	show_m "installing wget please wait"
	$sudoaptinstall wget
else
	show_m "wget already installed"
fi
}

install_gpg_now()
{
show_m "installing gpg please wait"
$sudoaptinstall gnupg2
}

rm_if_link()
{ 
if [ -L "$1" ]; then
	rm "$1";
fi 
}

modularize_awesomeWM_rc_file()
{
# local var
local first_match="$1"
local new_module_name_="$2"
local new_module_folder_name_="$3"
if [ "$4" == "{" ]
then
	local first_match_line_number="$(grep -Fn "{{{ $first_match" $HOME/.config/awesome/rc.lua | cut -d: -f1)"
else
	if [[ $first_match == *"--"* ]]
	then
		local temp_first_match=${first_match//-- }
	fi
	local first_match_line_number="$(grep -Fn "$temp_first_match" $HOME/.config/awesome/rc.lua | cut -d: -f1)"
fi
local end_of_lua_function_line_number="$(sed -ne '/'"$first_match"'/,$ p' $HOME/.config/awesome/rc.lua | grep -Fn '}}}' | head -1 | cut -d: -f1 )"
local delete_from_line="$(expr $first_match_line_number + 1)"
local delete_to_line="$(expr $end_of_lua_function_line_number + $first_match_line_number - 1)"
# error check
if [ "$delete_from_line" -le "1" ] || [ "$end_of_lua_function_line_number" -le "1" ]
then
	show_em "failed to modularize awesomeWM at $first_match"
	return 0
fi

mkdir -p $HOME/.config/awesome/$new_module_folder_name_
if [ "$3" == "{" ]
then
	sed -nE "/-- \{\{\{ $first_match/,/-- \}\}\}/p" $HOME/.config/awesome/rc.lua >> $HOME/.config/awesome/$new_module_folder_name_/$new_module_name_.lua
else
	sed -nE "/$first_match/,/-- \}\}\}/p" $HOME/.config/awesome/rc.lua >> $HOME/.config/awesome/$new_module_folder_name_/$new_module_name_.lua
fi
sed -i "${delete_from_line},${delete_to_line}d" $HOME/.config/awesome/rc.lua
sed -i "/$first_match/c require(\"$new_module_folder_name_/$new_module_name_\")" $HOME/.config/awesome/rc.lua
}

temp_password_creater__()
{
local temp_password_for_now_=""
local re_enter_temp_password_for_now_=""

# Ask for temp password
while :
do
	temp_password_for_now_=$(whiptail --passwordbox "please enter your secret password" 8 78 --title "password dialog" 3>&1 1>&2 2>&3)
	exitstatus=$?
    if [ $exitstatus = 1 ]; then
		break
    fi
	re_enter_temp_password_for_now_=$(whiptail --passwordbox "please re-enter to confirm your secret password" 8 78 --title "password dialog" 3>&1 1>&2 2>&3)
	if [ ! -z "$temp_password_for_now_" ]
	then
		if [ "$temp_password_for_now_" == "$re_enter_temp_password_for_now_" ]
		then
			break
		fi
	fi
done
echo "$temp_password_for_now_"
}

update_grub_now()
{
sudo update-grub &>> $debug_log || show_em "to update grub menu."
}

source_this_url()
{
	Remote_source_URL="$1"
	Remote_source_File=${Remote_source_URL##*/};
	if test -f "$temp_folder_4_Remote_source_file/$Remote_source_File"; then
	    source $temp_folder_4_Remote_source_file/$Remote_source_File;
	else
	    curl -s ${Remote_source_URL} > $temp_folder_4_Remote_source_file/$Remote_source_File;
	    source $temp_folder_4_Remote_source_file/$Remote_source_File;
	fi
}


