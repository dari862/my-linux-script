##################################################################
# debian
##################################################################

main_Debian_now()
{
if [ "$Codename" == "bullseye" ]; then
  echo "This is Debian bullseye"
elif [ "$Codename" != "bullseye" ]; then
  echo "This is Debian but not bullseye"
fi

#enable bleeding edge
if [ "$do_you_want_to_switch_to_bleeding_edge_now" == "true" ] 
then
	show_mf "switching to debian bleeding edge. "
	show_m "switching to debian bleeding edge. "
	sudo mv /etc/apt/sources.list /etc/apt/sources.list.backup-before-sid
	sudo bash -c 'sudo cat << eof > /etc/apt/sources.list
	deb http://deb.debian.org/debian/ sid main
	deb-src http://deb.debian.org/debian/ sid main
	eof'
	aptupdate
fi

#enable backport
if [ "$do_you_want_enable_backport_now" == "true" ] 
then
	show_mf "enable backport to debian."
	show_m "enable backport to debian."
	add_new_source_to_apt_now mod "" repolink "deb http://deb.debian.org/debian/ ${Codename,,}-backports main &&deb-src http://deb.debian.org/debian/ ${Codename,,}-backports main" reponame "${Codename,,}-backports"	
	aptupdate
fi

show_m "Add Debian repositories contrib and non-free"
sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
# INFO: Contrib and non-free repositories are not enabled by default in Debian install
(
# Add contrib section
deb_lines_contrib="$(egrep '^(deb|deb-src) (http://deb.debian.org/debian/|http://security.debian.org/debian-security)' /etc/apt/sources.list | grep -v contrib)" || echo "contrib already enabled"
IFS=$'\n'
if [ "$deb_lines_contrib" != "" ]
then
	for l in $deb_lines_contrib; do
		sudo sed -i "s\\^$l$\\$l contrib\\" /etc/apt/sources.list
	done
fi

# Add non-free section
deb_lines_nonfree="$(egrep '^(deb|deb-src) (http://deb.debian.org/debian/|http://security.debian.org/debian-security)' /etc/apt/sources.list | grep -v non-free)" || echo "non-free already enabled"
if [ "$deb_lines_nonfree" != "" ]
then
	for l in $deb_lines_nonfree; do
		sudo sed -i "s\\^$l$\\$l non-free\\" /etc/apt/sources.list
	done
fi
)

aptupdate
sudo apt-get install -y --reinstall bash-completion

show_mf "configure_debian_now"
show_m "configure Debian"
}

##################################################################
# ubuntu
##################################################################

change_main_repo_for_ubuntu_and_ububuntu_similer_repo()
{
show_m "Edit sources.list"
sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
sleep 3
local repo_country=$(grep "archive.ubuntu" /etc/apt/sources.list | head -1 | grep -o -P '(?<=://).*(?=.archive)')
if [ -z "$repo_country" ]
then
      sudo sed -i 's|http://archive|http://fr.archive|g' /etc/apt/sources.list | show_em "failed to edit sources.list"
else
      sudo sed -i "s|http://$repo_country.archive|http://fr.archive|g" /etc/apt/sources.list | show_em "failed to edit sources.list"
fi

show_m "adding universe and multiverse repository."
sudo add-apt-repository -y universe
sudo add-apt-repository -y multiverse

aptupdate
}

main_Ubuntu_now()
{
show_mf "edit_ubuntu_sources_list_now"
change_main_repo_for_ubuntu_and_ububuntu_similer_repo
}

##################################################################
# Pop-OS
##################################################################

main_Pop_now()
{
sudo pkill -9 -f io.elementary.a
sudo systemctl stop pop-upgrade.service
sudo systemctl stop pop-upgrade-init.service
$sudoaptinstall gnome-shell-extension-ubuntu-dock 
show_mf "Edit_Pop_sources_list_now "
change_main_repo_for_ubuntu_and_ububuntu_similer_repo
}


##################################################################
# Failed Distro
##################################################################
failed_to_configure_Distro()
{
if [[ $(type -t main_${DISTRO}_now) == function ]] 
then
	show_mf "failed to configure $DISTRO !!!" 
	show_em "failed to configure $DISTRO !!!"
else
	show_mf "can't configure $DISTRO, don't have function to configure it !!!"
	show_em "can't configure $DISTRO, don't have function to configure it !!!"
fi

exit 1
}
