configure_shell_now()
{
show_mf "configure_shell_now "
show_m "configure ~/.zprofile "
# some stuff has been done from dotfile_cleanup_now_common_dot_sh
mkdir -p $temp_folder_for_skel_tweakterminalfolder && cd "$_"
mkdir -p $temp_folder_for_skel_tweakterminalfolder/$oldshell_folder_name

echo "source \$zshdotfiles/$zshrcfilename" >> $temp_folder_for_skel_tweakterminalfolder/zsh/zshrc

cat << 'eof' > $foldertempfornow/profile_extra
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/myshell/zsh"
export My_shell_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/myshell"
eof

cat $foldertempfornow/profile_extra >> $temp_folder_for_skel_tweakterminalfolder/bash/profile
cat $foldertempfornow/profile_extra >> $temp_folder_for_skel_tweakterminalfolder/zsh/zprofile

rm_if_link "$HOME/.profile"

show_m "configure new zsh and bash "
cp -r $temp_folder_for_shell_config/* $temp_folder_for_skel_tweakterminalfolder

mv ~/.bash_logout $temp_folder_for_skel_tweakterminalfolder/bash/bash_logout &> /dev/null || touch $temp_folder_for_skel_tweakterminalfolder/bash/bash_logout
echo 'source $BASHDOTDIR/bash_logout' >> $temp_folder_for_skel_tweakterminalfolder/bash/$bashrcfilename

mkdir -p $temp_folder_for_skel_tweakterminalfolder/z

cat > $temp_folder_for_skel_tweakterminalfolder/z.plugin.bash <<- EOM
if [ -f ~/$myshell_skel_folder/z/${outsidemyrepo_z_sh##*/} ]; then 
  _Z_CMD=j
  _Z_DATA=~/$myshell_skel_folder/z/z_database
  source ~/$myshell_skel_folder/z/${outsidemyrepo_z_sh##*/}
else 
  echo "${outsidemyrepo_z_sh##*/} does not exist wget it from (${outsidemyrepo_z_sh})."
fi
EOM

# Bash
show_m "adding z and thefuck  to $bashrcfilename"
mkdir -p $temp_folder_for_skel_tweakterminalfolder/bash/bplugins
mv $temp_folder_for_skel_tweakterminalfolder/z.plugin.bash $temp_folder_for_skel_tweakterminalfolder/bash/bplugins/z.plugin.bash
echo 'eval $(thefuck --alias f)' > $temp_folder_for_skel_tweakterminalfolder/bash/bplugins/thefuck.plugin.bash
echo 'source <(kitty + complete setup bash)' > $temp_folder_for_skel_tweakterminalfolder/bash/bplugins/kitty_auto_complete.plugin.bash

# ZSH
show_m "adding z , thefuck and antigen to $zshrcfilename"
mkdir -p $temp_folder_for_skel_tweakterminalfolder/zsh/antigen
mkdir -p $temp_folder_for_skel_tweakterminalfolder/zsh/zplugins
cp $temp_folder_for_skel_tweakterminalfolder/bash/bplugins/z.plugin.bash $temp_folder_for_skel_tweakterminalfolder/zsh/zplugins/z.plugin.zsh
echo 'eval $(thefuck --alias f)' > $temp_folder_for_skel_tweakterminalfolder/zsh/zplugins/thefuck.plugin.zsh
echo 'kitty + complete setup zsh | source /dev/stdin' > $temp_folder_for_skel_tweakterminalfolder/zsh/zplugins/kitty_auto_complete.plugin.zsh
local antigen_2_source='
# change default antigen folder
export ADOTDIR="$ZDOTDIR/antigen"
# sourcing antigen
source /usr/share/zsh-antigen/antigen.zsh
# sourcing my antigen stuff
source "$ZDOTDIR/antigen-plugins.zsh"
# Tell Antigen that you are done.
antigen apply
'
echo "$antigen_2_source" > $temp_folder_for_skel_tweakterminalfolder/zsh/zplugins/antigen.plugin.zsh
cat <<EOF > $temp_folder_for_skel_tweakterminalfolder/zsh/antigen-plugins.zsh
EOF

install -d ~/.config/tilix/schemes
mv $temp_folder_for_skel_tweakterminalfolder/Flat-Remix.json.tilix ~/.config/tilix/schemes/Flat-Remix.json

# add komorebi
test_if_bashrc_contain_komorebi=$(grep $temp_folder_for_skel_tweakterminalfolder/$bashrcfilename -e "komorebi-aliases")
if [ -f /System/Applications/komorebi ] && [ ! -z "$test_if_bashrc_contain_komorebi" ]
then
  echo '' >> $temp_folder_for_skel_tweakterminalfolder/$zshrcfilename
  echo 'source ~/.config/komorebi/komorebi-aliases' >> $temp_folder_for_skel_tweakterminalfolder/zsh/$zshrcfilename
  echo '' >> $temp_folder_for_skel_tweakterminalfolder/$bashrcfilename
  echo 'source ~/.config/komorebi/komorebi-aliases' >> $temp_folder_for_skel_tweakterminalfolder/bash/$bashrcfilename
fi

}


make_zsh_default_shell()
{
  show_mf "make_zsh_default_shell "
  show_m "make zsh default shell "
  sudo chsh -s $(command -v zsh) $(whoami)
}

