#!/usr/bin/env zsh
# ANTIDOTE
source $ZDOTDIR/.antidote/antidote.zsh
antidote load
zstyle ':antidote:compatibility-mode' 'antibody' 'on'
# EXPORT
export HISTFILE=$ZDOTDIR/.histfile
export HISTSIZE=10000
export SAVEHIST=10000
export CARGO_HOME=~/.local/share/cargo
export RUSTUP_HOME=~/.local/share/rustup
export PATH=$PATH:$ZDOTDIR/scripts:$HOME/.local/bin:$CARGO_HOME/bin
## (NEO)VIM
if command -v nvim &>/dev/null; then
  export EDITOR=nvim
  export MOST_EDITOR=nvim
  export MANPAGER="nvim +Man!"
elif command -v vim &>/dev/null; then
  export EDITOR=vim
  export MOST_EDITOR=vim
else
  echo "Please, install vim and nvim"
fi
## MOST
if command -v most &>/dev/null; then
  export PAGER=most
else
  echo "Please, install most"
fi
# ZOXIDE
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
else
  echo "Please, install zoxide"
fi
# ALIAS
alias g=git
alias ..="cd .."
alias v=$EDITOR
alias irc=weechat
alias ls="ls --color=auto"
alias sumo='sudo machinectl shell root@'
alias bw="BITWARDENCLI_APPDATA_DIR=~/.config/bw-krypta /usr/local/bin/bw $@"
alias bwl="BW_CLIENTID=$(pass bw-krypta/clientid) BW_CLIENTSECRET=$(pass bw-krypta/clientsecret) BITWARDENCLI_APPDATA_DIR=~/.config/bw-krypta /usr/local/bin/bw $@ login --apikey"
alias bl='bao login -method=userpass username=$VAULT_USER password=$VAULT_PASSWD'
alias vl='vault login -method=userpass username=$VAULT_USER password=$VAULT_PASSWD'
## EZA
if command -v eza &>/dev/null; then
  alias l='eza -lhgbF --git --group-directories-first --icons=always'
  alias ll='eza -lahbgF --git --group-directories-first --icons=always'
  alias llm='eza -lbGd --git --sort=modified --group-directories-first'
  alias la='eza -lbhHigmuSa --time-style=long-iso --git --color-scale --group-directories-first'
  alias lx='eza -lbhHigmuSa@ --time-style=long-iso --git --color-scale --group-directories-first'
  alias lt='eza --tree --level=2 --group-directories-first'
else
  alias l='ls -lhg'
  alias ll='ls -lahg'
  echo "Please, install eza"
fi
# FZF
export FZF_DEFAULT_OPTS="--layout=reverse --inline-info"
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
else
  echo "Please, install fzf"
fi
if command -v fd &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f'
fi
if command -v bat &>/dev/null; then
  export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"
fi
# OS
## COMMON
if grep Arch /etc/os-release &>/dev/null; then
  alias pkg_add='yay -Slq | fzf --multi --preview 'yay -Si {1}' | xargs -ro yay -S'
  alias pkg_del='yay -Qq | fzf --multi --preview 'yay -Qi {1}' | xargs -ro yay -Rns'
fi
## DEBIAN
if grep debian /etc/os-release &>/dev/null; then
  alias bat=batcat
  alias fd=fdfind
  if command -v fdfind &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fdfind --type f'
  fi
  if command -v batcat &>/dev/null; then
    export FZF_CTRL_T_OPTS="--preview 'batcat -n --color=always {}'"
  fi
fi
## P10K
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
