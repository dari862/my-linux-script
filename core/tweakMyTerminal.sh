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
export ZSH_THEME="headline"
eof

cat $foldertempfornow/profile_extra >> $temp_folder_for_skel_tweakterminalfolder/profile
cat $foldertempfornow/profile_extra >> $temp_folder_for_skel_tweakterminalfolder/zprofile

rm_if_link "$HOME/.profile"

show_m "configure new zsh and bash "
cp -r $temp_folder_for_shell_config/* $temp_folder_for_skel_tweakterminalfolder

mv ~/.bash_logout $temp_folder_for_skel_tweakterminalfolder/bash_logout &> /dev/null || touch $temp_folder_for_skel_tweakterminalfolder/bash_logout
echo 'source $BASHDOTDIR/bash_logout' >> $temp_folder_for_skel_tweakterminalfolder/$bashrcfilename

local autojump_sh_location="/usr/share/autojump/autojump.sh"

local autojump_2_source=" if [ -f /usr/share/autojump/autojump.sh ]; then . /usr/share/autojump/autojump.sh else echo \"autojump.sh at ( /usr/share/autojump/autojump.sh ) does not exist.\" ; fi"

show_m "adding autojump and thefuck  to $bashrcfilename"
cat <<EOF_bashrc >> $temp_folder_for_skel_tweakterminalfolder/$bashrcfilename

#############
# autojump 
#############
$autojump_2_source

#############
# thefuck 
#############
eval \$(thefuck --alias f)

#############
# Completion for kitty 
#############
source <(kitty + complete setup bash)

EOF_bashrc

mkdir -p $temp_folder_for_skel_tweakterminalfolder/antigen
show_m "adding autojump , thefuck and antigen to $zshrcfilename"
cat <<EOF_zshrc >> $temp_folder_for_skel_tweakterminalfolder/$zshrcfilename

#############
# autojump 
#############
$autojump_2_source

#############
# thefuck 
#############
eval \$(thefuck --alias f)

###################### 
# antigen
###################### 
# change default antigen folder
export ADOTDIR="\$zshdotfiles/antigen"
# sourcing antigen
source /usr/share/zsh-antigen/antigen.zsh
# sourcing my antigen stuff
source "\$zshdotfiles/antigen-plugins.zsh"
# Tell Antigen that you're done.
antigen apply

#############
# Completion for kitty 
#############
kitty + complete setup zsh | source /dev/stdin 

EOF_zshrc

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

