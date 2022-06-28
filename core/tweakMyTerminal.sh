configure_shell_now()
{
show_mf "configure_shell_now "
show_m "configure ~/.zprofile "
# some stuff has been done from dotfile_cleanup_now_common_dot_sh
mkdir -p $temp_folder_for_skel_tweakterminalfolder && cd "$_"
mkdir -p $temp_folder_for_skel_tweakterminalfolder/$oldshell_folder_name

echo "source \$zshdotfiles/$zshrcfilename" >> $temp_folder_for_skel_tweakterminalfolder/zshrc

cat << 'eof' > $foldertempfornow/profile_extra
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/myshell"
export zshdotfiles="${XDG_CONFIG_HOME:-$HOME/.config}/myshell"
eof

cat $foldertempfornow/profile_extra >> $temp_folder_for_skel_tweakterminalfolder/profile
cat $foldertempfornow/profile_extra >> $temp_folder_for_skel_tweakterminalfolder/zprofile

rm_if_link "$HOME/.profile"

show_m "configure new zsh and bash "
cp -r $temp_folder_for_shell_config/* $temp_folder_for_skel_tweakterminalfolder

mv ~/.bash_logout $temp_folder_for_skel_tweakterminalfolder/bash_logout &> /dev/null || touch $temp_folder_for_skel_tweakterminalfolder/bash_logout
echo 'source $BASHDOTDIR/bash_logout' >> $temp_folder_for_skel_tweakterminalfolder/$bashrcfilename

mkdir -p $temp_folder_for_skel_tweakterminalfolder/z
local source_z_='if [ -f ~/$myshell_skel_folder/z/z.sh ]; then 
  
  source ~/$myshell_skel_folder/z.sh
else 
  echo "z.sh does not exist wget it from (https://raw.githubusercontent.com/rupa/z/master/z.sh)." 
fi'

# Bash
show_m "adding z and thefuck  to $bashrcfilename"
mkdir -p $temp_folder_for_skel_tweakterminalfolder/bplugins
echo "$source_z_" > $temp_folder_for_skel_tweakterminalfolder/bplugins/z.plugin.bash
echo 'eval $(thefuck --alias f)' > $temp_folder_for_skel_tweakterminalfolder/bplugins/thefuck.plugin.bash
echo 'source <(kitty + complete setup bash)' > $temp_folder_for_skel_tweakterminalfolder/bplugins/kitty_auto_complete.plugin.bash

# ZSH
show_m "adding z , thefuck and antigen to $zshrcfilename"
mkdir -p $temp_folder_for_skel_tweakterminalfolder/antigen
mkdir -p $temp_folder_for_skel_tweakterminalfolder/zplugins
echo "$source_z_" > $temp_folder_for_skel_tweakterminalfolder/zplugins/z.plugin.zsh
echo 'eval $(thefuck --alias f)' > $temp_folder_for_skel_tweakterminalfolder/zplugins/thefuck.plugin.zsh
echo 'kitty + complete setup zsh | source /dev/stdin' > $temp_folder_for_skel_tweakterminalfolder/zplugins/kitty_auto_complete.plugin.zsh
local antigen_2_source='
# change default antigen folder
export ADOTDIR="$zshdotfiles/antigen"
# sourcing antigen
source /usr/share/zsh-antigen/antigen.zsh
# sourcing my antigen stuff
source "$zshdotfiles/antigen-plugins.zsh"
# Tell Antigen that you are done.
antigen apply
'
echo "$antigen_2_source" > $temp_folder_for_skel_tweakterminalfolder/zplugins/antigen.plugin.zsh
cat <<EOF > $temp_folder_for_skel_tweakterminalfolder/antigen-plugins.zsh
EOF

install -d ~/.config/tilix/schemes
mv $temp_folder_for_skel_tweakterminalfolder/Flat-Remix.json.tilix ~/.config/tilix/schemes/Flat-Remix.json

# add komorebi
test_if_bashrc_contain_komorebi=$(grep $temp_folder_for_skel_tweakterminalfolder/$bashrcfilename -e "komorebi-aliases")
if [ -f /System/Applications/komorebi ] && [ ! -z "$test_if_bashrc_contain_komorebi" ]
then
  echo '' >> $temp_folder_for_skel_tweakterminalfolder/$zshrcfilename
  echo 'source ~/.config/komorebi/komorebi-aliases' >> $temp_folder_for_skel_tweakterminalfolder/$zshrcfilename
  echo '' >> $temp_folder_for_skel_tweakterminalfolder/$bashrcfilename
  echo 'source ~/.config/komorebi/komorebi-aliases' >> $temp_folder_for_skel_tweakterminalfolder/$bashrcfilename
fi

}


make_zsh_default_shell()
{
  show_mf "make_zsh_default_shell "
  show_m "make zsh default shell "
  sudo chsh -s $(command -v zsh) $(whoami)
}

