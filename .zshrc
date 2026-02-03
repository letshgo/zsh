## BREW
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"

# If not in tmux, start tmux.
#if [[ -z ${TMUX+X}${ZSH_SCRIPT+X}${ZSH_EXECUTION_STRING+X} ]]; then
#  exec tmux
#fi

export ZPLUGINDIR=$HOME/.local/share/zsh_plugins

function zcompile-many() {
  local f
  for f; do zcompile -R -- "$f".zwc "$f"; done
}

# Clone and compile to wordcode missing plugins.
if [[ ! -e $ZPLUGINDIR/ohmyzsh ]]; then
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git $ZPLUGINDIR/ohmyzsh
  zcompile-many $ZPLUGINDIR/ohmyzsh/plugins/{gpg-agent/gpg-agent.plugin.zsh,ssh-agent/ssh-agent.plugin.zsh,zsh-interactive-cd/zsh-interactive-cd.plugin.zsh}
fi
if [[ ! -e $ZPLUGINDIR/zsh-completions ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-completions.git $ZPLUGINDIR/zsh-completions
  zcompile-many $ZPLUGINDIR/zsh-completions/{zsh-completions.plugin.zsh,src/*}
fi
if [[ ! -e $ZPLUGINDIR/zsh-syntax-highlighting ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git $ZPLUGINDIR/zsh-syntax-highlighting
  zcompile-many $ZPLUGINDIR/zsh-syntax-highlighting/{zsh-syntax-highlighting.zsh,highlighters/*/*.zsh}
fi
if [[ ! -e $ZPLUGINDIR/zsh-autosuggestions ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git $ZPLUGINDIR/zsh-autosuggestions
  zcompile-many $ZPLUGINDIR/zsh-autosuggestions/{zsh-autosuggestions.zsh,src/**/*.zsh}
fi
if [[ ! -e $ZPLUGINDIR/powerlevel10k ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZPLUGINDIR/powerlevel10k
  make -C $ZPLUGINDIR/powerlevel10k pkg
fi

# Activate Powerlevel10k Instant Prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Load plugins.
source $ZPLUGINDIR/ohmyzsh/plugins/gpg-agent/gpg-agent.plugin.zsh
source $ZPLUGINDIR/ohmyzsh/plugins/ssh-agent/ssh-agent.plugin.zsh
source $ZPLUGINDIR/ohmyzsh/plugins/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh
source $ZPLUGINDIR/zsh-completions/zsh-completions.plugin.zsh
source $ZPLUGINDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZPLUGINDIR/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZPLUGINDIR/powerlevel10k/powerlevel10k.zsh-theme
source $ZDOTDIR/.p10k.zsh

# Enable the "new" completion system (compsys).
autoload -Uz compinit && compinit
[[ $ZDOTDIR/.zcompdump.zwc -nt $ZDOTDIR/.zcompdump ]] || zcompile-many $ZDOTDIR/.zcompdump
unfunction zcompile-many

# EXPORT
## HISTORY
export HISTFILE=$ZDOTDIR/.histfile
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
## EDITOR
export EDITOR=nvim
export VISUAL=$EDITOR
export MOST_EDITOR=nvim
export MANPAGER="nvim +Man!"
export PAGER=most
## FZF
export FZF_DEFAULT_OPTS="--layout=reverse --inline-info"
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"
## RUST
export CARGO_HOME=$HOME/.local/share/cargo
export RUSTUP_HOME=$HOME/.local/share/rustup
## TASK
export TASKDATA=$HOME/.config/task
export TASKRC=$TASKDATA/taskrc
## VOLTA
export VOLTA_HOME=$HOME/.config/volta
## PYENV
export PYENV_ROOT=$HOME/.local/share/pyenv
## BW
export BITWARDENCLI_APPDATA_DIR=$HOME/.config/bw
## PATH
export PATH=$PATH:$ZDOTDIR/scripts:$HOME/.local/bin:$CARGO_HOME/bin:$HOME/.local/share/rustup/bin:$VOLTA_HOME/bin:$PYENV_ROOT/shims:/home/linuxbrew/.linuxbrew/opt/pyenv/bin

# EVAL
eval "$(fzf --zsh)"
eval "$(pyenv init - --no-rehash zsh)"
__vew_init() {
	pyenv virtualenvwrapper
}
mkvirtualenv() {
	__vew_init
	mkvirtualenv "$@"
}
workon() {
	__vew_init
	workon "$@"
}
mktmpenv() {
	__vew_init
	mktmpenv "$@"
}
rmvirtualenv() {
	__vew_init
	rmvirtualenv "$@"
}

# ALIAS
## EZA
alias l='eza -lhgbF --git --group-directories-first --icons=always'
alias ll='eza -lahbgF --git --group-directories-first --icons=always'
alias llm='eza -lbGd --git --sort=modified --group-directories-first'
alias la='eza -lbhHigmuSa --time-style=long-iso --git --color-scale --group-directories-first'
alias lx='eza -lbhHigmuSa@ --time-style=long-iso --git --color-scale --group-directories-first'
alias lt='eza --tree --level=2 --group-directories-first'
## KUBECTL
alias k=kubectl
alias ke='kubectl exec -t -i'
alias kaf='kubectl apply -f'
alias kak='kubectl apply -k'
alias kc='kubectl config get-contexts'
## PROD
alias v=nvim
alias g=git
alias irc=weechat
alias news=newsboat
alias mail=aerc
alias calendar=calcurse
alias tasks=taskwarrior-tui
## MISC
alias ls="ls --color=auto"
alias sumo='sudo machinectl shell root@'
alias ..="cd .."
alias ...="cd ../.."
## RSYNC
alias rsync-copy="rsync -avz --progress -h"
alias rsync-move="rsync -avz --progress -h --remove-source-files"
alias rsync-update="rsync -avzu --progress -h"
alias rsync-synchronize="rsync -avzu --delete --progress -h"

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
