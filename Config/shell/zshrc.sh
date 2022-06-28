# ---------------------------------  Theme  -----------------------------------

ZSH_THEME="headline"

# ------------------------------- ZSH PLUGINS ---------------------------------
zplugins=(zsh-syntax-highlighting zsh-autosuggestions autojump)

zplugins=(you-should-use $zplugins)

zplugins=($zplugins
command-not-found
thefuck
kitty_auto_complete
antigen
auto-notify
zsh-history-substring-search
)

# -----------------------------------------------------------------------------

# If ZSH is not defined, use the current script's directory.
[[ -z "$zshdotfiles" ]] && export zshdotfiles="${${(%):-%x}:a:h}"

# Configure color-scheme
COLOR_SCHEME=dark # dark/light

# --------------------------------- SSH Theme ---------------------------------

if [[ -n $SSH_CONNECTION ]]; then
  ZSH_THEME="SSH"
else
  ZSH_THEME="$ZSH_THEME"
fi

# --------------------------------- SETTINGS ----------------------------------
setopt AUTO_CD
setopt BEEP
#setopt CORRECT
setopt HIST_BEEP
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt INTERACTIVE_COMMENTS
setopt MAGIC_EQUAL_SUBST
setopt NO_NO_MATCH
setopt NOTIFY
setopt NUMERIC_GLOB_SORT
setopt PROMPT_SUBST
setopt SHARE_HISTORY

HISTFILE=$zshdotfiles/zsh_history
HIST_STAMPS=mm/dd/yyyy
HISTSIZE=5000
SAVEHIST=5000
ZLE_RPROMPT_INDENT=0
WORDCHARS=${WORDCHARS//\/}
PROMPT_EOL_MARK=
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# tilix zsh fix
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi

# ZSH completion system
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Key bindings
bindkey -e
bindkey '^U' backward-kill-line
bindkey '^[[2~' overwrite-mode
bindkey '^[[3~' delete-char
bindkey '^[[H' beginning-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[3;5~' kill-word
bindkey '^[[5~' beginning-of-buffer-or-history
bindkey '^[[6~' end-of-buffer-or-history
bindkey '^[[Z' undo
bindkey ' ' magic-space

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty)
	precmd() { print -Pnr -- $'\e]0;%n@%m: %~\a' }
	;;
esac

# -------------------------------  theme Applyer -------------------------------
if builtin test -f $zshdotfiles/zthemes/${ZSH_THEME}.zsh-theme; then
	source $zshdotfiles/zthemes/${ZSH_THEME}.zsh-theme
else
	echo "plugin '$zplugin' not found"
fi

# ------------------------------- ZSH PLUGINS Applyer --------------------------
for zplugin ($zplugins); do
	if builtin test -f $zshdotfiles/zplugins/${zplugin}.plugin.zsh; then
  		source $zshdotfiles/zplugins/${zplugin}.plugin.zsh
	elif builtin test -f $zshdotfiles/zplugins/${zplugin}.zsh; then
  		source $zshdotfiles/zplugins/${zplugin}.zsh
  	elif builtin test -f /usr/share/${zplugin}/${zplugin}.zsh; then
  		source /usr/share/${zplugin}/${zplugin}.zsh
  	else
    		echo "plugin '$zplugin' not found"
  	fi
done

# ------------------------------- source files ---------------------------------
source $zshdotfiles/aliases
source $zshdotfiles/zsh_only_aliases
source $zshdotfiles/misc
source $zshdotfiles/functions

# ------------------------------------------------------------------------------
