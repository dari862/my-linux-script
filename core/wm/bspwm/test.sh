do_you_want_to_switch_to_bleeding_edge_now="true"
main_debian_now

mkdir -p ~/.local/share/wallpapers
newwget -P ~/.local/share/wallpapers https://raw.githubusercontent.com/dari862/my-linux-script/main/wallpaper/nord1.png

sudo apt-get install -y sddm neofetch 

main_bspwm_now

show_m "you need to reboot."
