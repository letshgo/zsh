# BREW
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"

export ASDF_DATA_DIR="$HOME/.local/share/asdf"
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export ZSH_COMP_DIR="$HOME/.local/share/zsh/completions"
export ZSH_CACHE_DIR="$HOME/.local/share/zsh/cache"
export ZSH_PLUGIN_DIR="$HOME/.local/share/zsh/plugins"
mkdir -p "$ZSH_PLUGIN_DIR"
mkdir -p "$ZSH_CACHE_DIR"
mkdir -p "$ZSH_COMP_DIR"

declare -A zsh_plugins=(
  [ohmyzsh]="https://github.com/ohmyzsh/ohmyzsh.git"
  [zsh-completions]="https://github.com/zsh-users/zsh-completions.git"
  [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
  [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions.git"
  [powerlevel10k]="https://github.com/romkatv/powerlevel10k.git"
)

# PLUGINS
function zcompile-many() {
  local f
  for f; do zcompile -R -- "$f".zwc "$f"; done
}
if [[ ! -e $ZSH_PLUGIN_DIR/ohmyzsh ]]; then
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$ZSH_PLUGIN_DIR"/ohmyzsh
  zcompile-many "$ZSH_PLUGIN_DIR"/ohmyzsh/plugins/gpg-agent/gpg-agent.plugin.zsh
  zcompile-many "$ZSH_PLUGIN_DIR"/ohmyzsh/plugins/ssh-agent/ssh-agent.plugin.zsh
  zcompile-many "$ZSH_PLUGIN_DIR"/ohmyzsh/plugins/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh
  zcompile-many "$ZSH_PLUGIN_DIR"/ohmyzsh/lib/completion.zsh
  zcompile-many "$ZSH_PLUGIN_DIR"/ohmyzsh/lib/functions.zsh
  zcompile-many "$ZSH_PLUGIN_DIR"/ohmyzsh/lib/termsupport.zsh
fi
if [[ ! -e $ZSH_PLUGIN_DIR/zsh-completions ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-completions.git "$ZSH_PLUGIN_DIR"/zsh-completions
  zcompile-many "$ZSH_PLUGIN_DIR"/zsh-completions/{zsh-completions.plugin.zsh}
fi
if [[ ! -e $ZSH_PLUGIN_DIR/zsh-syntax-highlighting ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_PLUGIN_DIR"/zsh-syntax-highlighting
  zcompile-many "$ZSH_PLUGIN_DIR"/zsh-syntax-highlighting/{zsh-syntax-highlighting.zsh,highlighters/**/*.zsh}
fi
if [[ ! -e $ZSH_PLUGIN_DIR/zsh-autosuggestions ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_PLUGIN_DIR/zsh-autosuggestions
  zcompile-many $ZSH_PLUGIN_DIR/zsh-autosuggestions/{zsh-autosuggestions.zsh,src/**/*.zsh}
fi
if [[ ! -e $ZSH_PLUGIN_DIR/powerlevel10k ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_PLUGIN_DIR/powerlevel10k
  make -C $ZSH_PLUGIN_DIR/powerlevel10k pkg
fi

ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# POWERLEVEL10K
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

fpath=($ZSH_COMP_DIR $fpath)

# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit
[[ $ZDOTDIR/.zcompdump.zwc -nt $ZDOTDIR/.zcompdump ]] || zcompile-many $ZDOTDIR/.zcompdump

# Load plugins.
source $ZSH_PLUGIN_DIR/ohmyzsh/lib/completion.zsh
source $ZSH_PLUGIN_DIR/ohmyzsh/lib/functions.zsh
source $ZSH_PLUGIN_DIR/ohmyzsh/lib/termsupport.zsh
source $ZSH_PLUGIN_DIR/ohmyzsh/plugins/gpg-agent/gpg-agent.plugin.zsh
source $ZSH_PLUGIN_DIR/ohmyzsh/plugins/ssh-agent/ssh-agent.plugin.zsh
source $ZSH_PLUGIN_DIR/ohmyzsh/plugins/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh
source $ZSH_PLUGIN_DIR/zsh-completions/zsh-completions.plugin.zsh
source $ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH_PLUGIN_DIR/powerlevel10k/powerlevel10k.zsh-theme
source $ZDOTDIR/.p10k.zsh

unfunction zcompile-many

# EXPORT
export HISTFILE=$ZDOTDIR/.histfile
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
export EDITOR=nvim
export VISUAL=$EDITOR
export MOST_EDITOR=nvim
export MANPAGER="nvim +Man!"
export PAGER=most
export FZF_DEFAULT_OPTS="--layout=reverse --inline-info"
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"
export TASKDATA=$HOME/.config/task
export TASKRC=$TASKDATA/taskrc
export BITWARDENCLI_APPDATA_DIR=$HOME/.config/bw
export PATH=$PATH:$ZDOTDIR/scripts:$HOME/.local/bin

# EVAL
source <(fzf --zsh)
eval "$(zoxide init zsh)"

# ALIAS
alias l='eza -lhgbF --git --time-style=iso --group-directories-first --icons=always'
alias ll='eza -lahbgF --git --group-directories-first --icons=always'
alias lt='eza --tree --level=2 --git --color-scale --group-directories-first'
alias la='eza -lbhHigmuSaZ --time-style=long-iso --git --color-scale --group-directories-first  --icons=always'
alias lta='eza -a --tree --level=2 --git --color-scale --group-directories-first'
alias k=kubectl
alias ke='kubectl exec -t -i'
alias kaf='kubectl apply -f'
alias kn='kubectl get namespaces'
alias kc='kubectl config get-contexts'
alias v=nvim
alias g=git
alias t=tmux
alias irc=weechat
alias news=newsboat
alias mail=aerc
alias calendar=calcurse
alias tasks=taskwarrior-tui
alias ls="ls --color=auto"
alias sumo='sudo machinectl shell root@'
alias ..="cd .."
alias ...="cd ../.."
alias md="mkdir -p"
alias rsync-copy="rsync -avz --progress -h"
alias rsync-move="rsync -avz --progress -h --remove-source-files"
alias rsync-update="rsync -avzu --progress -h"
alias rsync-synchronize="rsync -avzu --delete --progress -h"

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
