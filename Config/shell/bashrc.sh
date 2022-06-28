# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# -------------------------------   Prompt  -----------------------------------
BASH_THEME="amazing"

# ----------------------------   BASH  PLUGINS ---------------------------------
bashplugins=(
z
thefuck
kitty_auto_complete
)

# ------------------------------------------------------------------------------
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Configure color-scheme
COLOR_SCHEME=dark # dark/light


# --------------------------------- SETTINGS ----------------------------------
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar
# append to the history file, don't overwrite it
shopt -s histappend
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5000
HISTFILESIZE=5000
HISTFILE=$BASHDOTDIR/bash_history

# Bash Completion
if [ -f /usr/share/bash-completion/bash_completion ]
then
	source /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]
then
	source /etc/bash_completion
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# ---------------------------------  source  ----------------------------------
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f $BASHDOTDIR/aliases ]; then
    . $BASHDOTDIR/aliases
    . $BASHDOTDIR/bash_only_aliases
fi
source $BASHDOTDIR/misc
source $BASHDOTDIR/functions

# -------------------------------   Prompt    ---------------------------------

if builtin test -f $BASHDOTDIR/bashthemes/${BASH_THEME}.bash-prompt-theme; then
  		source $BASHDOTDIR/bashthemes/${BASH_THEME}.bash-prompt-theme
else
    		echo "BASH theme '$BASH_THEME' not found"
fi

# ------------------------------- BASH PLUGINS Applyer --------------------------
# Add all defined plugins to fpath. This must be done
# before running compinit.
for bashplugin in ${bashplugins[@]}; do
	if builtin test -f $BASHDOTDIR/bplugins/${bashplugin}.plugin.bash; then
  		source $BASHDOTDIR/bplugins/${bashplugin}.plugin.bash
  	else
    		echo "plugin '$bashplugin' not found"
  	fi
done

# ------------------------------------------------------------------------------
