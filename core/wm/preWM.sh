configure_PreWM_now()
{
show_m "install preWM_apps"
cd $temp_folder_for_preWM
mkdir -p ~/.config/gtk-3.0
mv $temp_folder_for_preWM/preWM_config_files/gtk-3.0/* ~/.config/gtk-3.0 && rm -rdf $temp_folder_for_preWM/preWM_config_files/gtk-3.0 || echo "falied to move all gtk-3.0 files"
mv $temp_folder_for_preWM/preWM_config_files/* ~/.config &> /dev/null || echo "falied to move all preWM_config_files files"
if [ -z "$(ls -A $temp_folder_for_preWM/preWM_config_files)" ]; then
   echo "preWM_config_files copyed without any errors"
else
   ls -aR $temp_folder_for_preWM/preWM_config_files > $missing_content_from_preWM_config_files && show_em "falied to move all preWM_config_files files"
fi

if [ "$virtual_machine" == "true" ]
then
   sed -i 's|# vsync = false|vsync = false;|g' ~/.config/picom.conf
   sed -i 's|vsync = true;|# vsync = true|g' ~/.config/picom.conf
fi

####################################
# PreWM_themeing_now
####################################
show_m "PreWM_themeing_now "

sudo mkdir -p /usr/share/fonts
sudo mv $temp_folder_for_preWM/fonts/* /usr/share/fonts &> /dev/null || show_em "falied to move all fonts files"
sudo fc-cache -vf

# Download Nordic Theme
sudo mv $temp_folder_for_preWM/Nordic /usr/share/themes/ &> /dev/null || show_em "falied to move all Nordic theme files"
# Layan Cursors
cd $temp_folder_for_preWM/build_Layan_Cursors
sudo ./install.sh

cd
rm_if_link "$HOME/.Xresources"
ln -s $HOME/.config/x11/xresources .Xresources

}

main_PreWM_now()
{
show_mf "Pre-WM."
configure_PreWM_now
}
