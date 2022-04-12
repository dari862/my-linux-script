purge_this_now()
{
declare -a StringArray=(aisleriot
anthy
kasumi
aspell
debian-reference-common
fcitx
fcitx-bin
fcitx-frontend-gtk2
fcitx-frontend-gtk3
fcitx-mozc
five-or-more
four-in-a-row
gnome-chess
gnome-klotski
gnome-mahjongg
gnome-mines
gnome-music
gnome-nibbles
gnome-robots
gnome-sudoku
gnome-taquin
gnome-tetravex
gnote
goldendict
hamster-applet
hdate-applet
hexchat
hitori
iagno
khmerconverter
lightsoff
mate-themes
mlterm
mlterm-tiny
mozc-utils-gui
quadrapassel
reportbug
rhythmbox
scim
simple-scan
sound-juicer
swell-foop
tali
uim
xboard
xiterm+thai
xterm)
apt_purge_with_error2info "${StringArray[@]}"
}

purge_this_all_except_Pop_now()
{
declare -a StringArray=(im-config)
apt_purge_with_error2info "${StringArray[@]}"
}

main_uninstall_unwanted_apps_now()
{
show_mf "main_uninstall_unwanted_apps_now"
show_m "purging app"
purge_this_now
if [ "$DISTRO" != "Pop" ]
then
purge_this_all_except_Pop_now
fi
}
