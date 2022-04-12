configuring_bspwm_now()
{
cp -r $temp_folder_for_bspwm/bspwm_config_files/dotfiles/* /home/$USER/.config/
}

main_bspwm_now()
{
show_mf "main_PreWM_now "
configuring_bspwm_now
}
