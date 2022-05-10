dotfile_cleanup_now()
{

if [ -d "/etc/skel/$oldshell_skel_folder" ]
then
	return 0
fi

show_mf "dotfile clean-up"
show_m "Home dotfile clean-up"

if [ -f "$soursepimpmyterminalfolder_fullpath/$bashrcfilename" ]; then
	cat "$soursepimpmyterminalfolder_fullpath/$bashrcfilename" > "$HOME/bashrc_111111111"
	rm "$HOME/.bashrc"
	mv "$HOME/bashrc_111111111" "$HOME/.bashrc"
	mkdir -p $backup_old_config_file_to_
	mv ~/.config/wget $backup_old_config_file_to_
	mv ~/.config/user-dirs.dirs $backup_old_config_file_to_
	mv ~/.config/user-dirs.locale $backup_old_config_file_to_
	mv $soursepimpmyterminalfolder_fullpath $backup_old_config_file_to_
fi

rm_if_link "$HOME/.bashrc"
rm_if_link "$HOME/.profile"
rm_if_link "$HOME/.zprofile"

mkdir -p $HOME/$oldshell_skel_folder
declare -a rc_dot_files=(
bashrc
profile
zshrc
zprofile
)
for INDEX in ${!rc_dot_files[*]}; do
	local rc_dot_file=${rc_dot_files[$INDEX]}
	if test -f "$HOME/.$rc_dot_file"; then
		mv $HOME/.$rc_dot_file $HOME/$oldshell_skel_folder
	fi
done

if [ ! -d "$HOME/.gnupg" ]; then
	mkdir -p $HOME/.local/share/gnupg
	chmod 700 $HOME/.local/share/gnupg
fi

if [ -d "$HOME/.gnupg" ]; then
	mkdir -p $HOME/.local/share
	mv $HOME/.gnupg $HOME/.local/share/gnupg/
fi

show_m "creating temp skel dotfile"
mkdir -p $temp_folder_for_oldskel_file_shell_folder

mkdir -p $temp_folder_for_skel_config/wget
echo 'hsts-file=~/.cache/wget-hsts' > $temp_folder_for_skel_config/wget/wgetrc

cp /etc/skel/.bashrc $temp_folder_for_skel_shell_folder/$bashrcfilename
cat /etc/skel/.profile > $temp_folder_for_oldskel_file_shell_folder/profile

echo "source \$BASHDOTDIR/$bashrcfilename" > $temp_folder_for_skel_shell_folder/bashrc

cat << 'eof' > $temp_folder_for_skel_shell_folder/profile
# profile file. Runs on login. Environmental variables are set here.

# set tty colours.
if [ "$TERM" = "linux" ]; then
    printf "\e]P0000000" # color0
    printf "\e]P19e1828" # color1
    printf "\e]P2aece92" # color2
    printf "\e]P3968a38" # color3
    printf "\e]P4414171" # color4
    printf "\e]P5963c59" # color5
    printf "\e]P6418179" # color6
    printf "\e]P7bebebe" # color7
    printf "\e]P8888888" # color8
    printf "\e]P9cf6171" # color9
    printf "\e]PAc5f779" # color10
    printf "\e]PBfff796" # color11
    printf "\e]PC4186be" # color12
    printf "\e]PDcf9ebe" # color13
    printf "\e]PE71bebe" # color14
    printf "\e]PFffffff" # color15
#   clear # removes artefacts but also removes /etc/{issue,motd}
fi

# Default programs:
export EDITOR="nano"
export TERMINAL="x-terminal-emulator"
export BROWSER="firefox"

# ~/ Clean-up:
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XINITRC="${XDG_CONFIG_HOME:-$HOME/.config}/x11/xinitrc"
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc"
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/shell/inputrc"
export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc-2.0"
export LESSHISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/lesshst"
export GNUPGHOME="${XDG_DATA_HOME:-$HOME/.local/share}/gnupg"
export PASSWORD_STORE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/password-store"
#export XDG_RUNTIME_DIR="/run/user/$UID"
#export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority" # This line will break some DM.
#export TMUX_TMPDIR="$XDG_RUNTIME_DIR"

# Other program settings:
#export ALSA_CONFIG_PATH="$XDG_CONFIG_HOME/alsa/asoundrc"
#export WINEPREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/wineprefixes/default"
#export KODI_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/kodi"
#export ANDROID_SDK_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/android"
#export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
#export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
#export ANSIBLE_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/ansible/ansible.cfg"
#export UNISON="${XDG_DATA_HOME:-$HOME/.local/share}/unison"
#export LESS=-R
#export LESS_TERMCAP_mb="$(printf '%b' '^[[1;31m')"
#export LESS_TERMCAP_md="$(printf '%b' '^[[1;36m')"
#export LESS_TERMCAP_me="$(printf '%b' '^[[0m')"
#export LESS_TERMCAP_so="$(printf '%b' '^[[01;44;33m')"
#export LESS_TERMCAP_se="$(printf '%b' '^[[0m')"
#export LESS_TERMCAP_us="$(printf '%b' '^[[1;32m')"
#export LESS_TERMCAP_ue="$(printf '%b' '^[[0m')"
#export AWT_TOOLKIT="MToolkit wmname LG3D"       #May have to install wmname
export QT_QPA_PLATFORMTHEME="gtk2"      # Have QT use gtk2 theme.
export MOZ_USE_XINPUT2="1"              # Mozilla smooth scrolling/touchpads.

if [ ! -d "$GNUPGHOME" ]; then
	mkdir -p $GNUPGHOME
	[ -d "$HOME/.gnupg" ] && cp -r "$HOME/.gnupg/*" "$GNUPGHOME" && rm -rdf "$HOME/.gnupg"
	chmod 700 $GNUPGHOME
fi

# bash var
export BASHDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/myshell"
export BASH_THEME="amazing"

# Set environment path
export PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin:/usr/games:/usr/local/games
eof

cat /etc/skel/.profile >> $temp_folder_for_skel_shell_folder/profile || cat /etc/skel-old/.profile >> $temp_folder_for_skel_shell_folder/profile

cp $temp_folder_for_skel_shell_folder/profile $temp_folder_for_skel_shell_folder/zprofile

ln -sr $temp_folder_for_skel_shell_folder/zshrc $temp_folder_for_skel_shell_folder/.zshrc

cat << 'eof' > $temp_folder_for_skel_shell_folder/xsessionrc
#! /bin/sh
# Xsession - run as user
case $SHELL in
  */bash)
    [ -z "$BASH" ] && exec $SHELL $0 "$@"
	. ${HOME}/.config/myshell/profile
    ;;
*/zsh)
    [ -z "$ZSH_NAME" ] && exec $SHELL $0 "$@"
    . ${HOME}/.config/myshell/zprofile
    ;;
  */csh|*/tcsh)
    # [t]cshrc is always sourced automatically.
    # Note that sourcing csh.login after .cshrc is non-standard.
    xsess_tmp=`mktemp /tmp/xsess-env-XXXXXX`
    $SHELL -c "if (-f /etc/csh.login) source /etc/csh.login; if (-f ~/.login) so                                                                                                                                                                                 urce ~/.login; /bin/sh -c 'export -p' >! $xsess_tmp"
    . $xsess_tmp
    rm -f $xsess_tmp
    ;;
  */fish)
    . ${HOME}/.config/myshell/profile
    xsess_tmp=`mktemp /tmp/xsess-env-XXXXXX`
    $SHELL --login -c "/bin/sh -c 'export -p' > $xsess_tmp"
    . $xsess_tmp
    rm -f $xsess_tmp
    ;;
  *) # Plain sh, ksh, and anything we do not know.
    . ${HOME}/.config/myshell/profile
    ;;
esac

eof

cat << EOF > $temp_folder_for_skel_/.profile
rm -rdf ~/.bashrc
rm -rdf ~/.profile
rm -rdf ~/.zshrc
rm -rdf ~/.zprofile
rm -rdf ~/.xsessionrc
ln -sr ~/$myshell_skel_folder/xsessionrc ~/.xsessionrc
ln -sr ~/$myshell_skel_folder/bashrc ~/.bashrc
xdg-user-dirs-update # this command will create ~/.config/user-dirs.dirs and ~/.config/user-dirs.locale
source ~/.xsessionrc
EOF

cp $temp_folder_for_skel_/.profile $temp_folder_for_skel_/.zprofile

show_m "skel dotfile clean-up"
sudo cp -r /etc/skel/ /etc/skel-old/
sudo rm -rdf /etc/skel/
sudo mkdir -p /etc/skel/
}
