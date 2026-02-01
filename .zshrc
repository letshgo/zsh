#!/usr/bin/env zsh
# ANTIDOTE
source $ZDOTDIR/.antidote/antidote.zsh
antidote load
zstyle ':antidote:compatibility-mode' 'antibody' 'on'

# EXPORT
export HISTFILE=$ZDOTDIR/.histfile
export HISTSIZE=10000
export SAVEHIST=10000
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
## EZA
if type eza &>/dev/null; then
  alias l='eza -lhgbF --git --group-directories-first --icons=always'
  alias ll='eza -lahbgF --git --group-directories-first --icons=always'
  alias llm='eza -lbGd --git --sort=modified --group-directories-first'
  alias la='eza -lbhHigmuSa --time-style=long-iso --git --color-scale --group-directories-first'
  alias lx='eza -lbhHigmuSa@ --time-style=long-iso --git --color-scale --group-directories-first'
  alias lt='eza --tree --level=2 --group-directories-first'
else
  alias l='ls -lhg'
  alias ll='ls -lahg'
  MISSING_PKGS+=(eza)
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
fi
## P10K
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
