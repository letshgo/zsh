#!/usr/bin/env zsh
#zmodload zsh/zprof
# ANTIDOTE
zstyle ':omz:update' mode disabled
source $ZDOTDIR/.antidote/antidote.zsh
zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins
[[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt
fpath=($ZDOTDIR/.antidote/functions $fpath)
autoload -Uz antidote
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
fi
source ${zsh_plugins}.zsh
zstyle ':antidote:compatibility-mode' 'antibody' 'on'

# EXPORT
export HISTFILE=$ZDOTDIR/.histfile
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
export PATH=$PATH:$ZDOTDIR/scripts:$HOME/.local/bin
export MISSING_PKGS=()

# SOURCE
source $ZDOTDIR/aux.zsh

# ALIAS
alias g=git
alias ..="cd .."
alias v=$EDITOR
alias irc=weechat
alias news=newsboat
alias mail=aerc
alias calendar=calcurse
alias tasks=taskwarrior-tui
alias ls="ls --color=auto"
if type machinectl &>/dev/null; then
  alias sumo='sudo machinectl shell root@'
else
  MISSING_PKGS+=(systemd-container)
fi
## OS
if grep Arch /etc/os-release &>/dev/null && type yay &>/dev/null; then
  alias pkg_add='yay -Slq | fzf --multi --preview 'yay -Si {1}' | xargs -ro yay -S'
  alias pkg_del='yay -Qq | fzf --multi --preview 'yay -Qi {1}' | xargs -ro yay -Rns'
elif grep Arch /etc/os-release &>/dev/null && ! type yay &>/dev/null; then
  alias pkg_add='sudo pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S'
  alias pkg_del='sudo pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns'
  MISSING_PKGS+=(yay)
fi

# POST
if [ ! ${#MISSING_PKGS[@]} -eq 0 ]; then
  echo "Install the following applications:"
  printf '%s\n' "${MISSING_PKGS[@]}"
  unset MISSING_PKGS
fi
#zprof
