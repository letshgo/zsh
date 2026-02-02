## RUST
if type rustup-init &>/dev/null; then
  export CARGO_HOME=$HOME/.local/share/cargo
  export RUSTUP_HOME=$HOME/.local/share/rustup
  export PATH=$PATH:$CARGO_HOME/bin:$HOME/.local/share/rustup/bin
else
  MISSING_PKGS+=(rustup)
fi
[ ! type cargo &>/dev/null ] && MISSING_PKGS+=(cargo)

## HOMEBREW
if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  [[ -n "$HOMEBREW_PREFIX" ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)" || MISSING_PKGS+=(brew)
fi

## VOLTA
export VOLTA_HOME=$HOME/.config/volta
export PATH=$VOLTA_HOME/bin:$PATH

## PYENV
if type pyenv &>/dev/null; then
  export PYENV_ROOT=$HOME/.local/share/pyenv
  export PATH="/home/linuxbrew/.linuxbrew/opt/pyenv/bin:$PATH"
  export PATH="$PYENV_ROOT/shims:$PATH"
  [[ ! -n "$(typeset +f | grep -E '^pyenv$')" ]] && eval "$(pyenv init - zsh)" && eval "$(pyenv virtualenv-init -)"
fi

## TASKWARRIOR
if type task &>/dev/null; then
  export TASKDATA=$HOME/.config/task
  export TASKRC=$TASKDATA/taskrc
fi

## (NEO)VIM
if type nvim &>/dev/null; then
  export EDITOR=nvim
  export VISUAL=$EDITOR
  export MOST_EDITOR=nvim
  export MANPAGER="nvim +Man!"
elif type vim &>/dev/null; then
  export EDITOR=vim
  export VISUAL=$EDITOR
  export MOST_EDITOR=vim
  MISSING_PKGS+=(nvim)
else
  export EDITOR=vi
  export VISUAL=$EDITOR
  MISSING_PKGS+=(vim)
  MISSING_PKGS+=(nvim)
fi

## BITWARDEN
if type bw &>/dev/null; then
  export BITWARDENCLI_APPDATA_DIR=$HOME/.config/bw
else
  MISSING_PKGS+=(bw)
fi

## MOST
if type most &>/dev/null; then
  export PAGER=most
else
  MISSING_PKGS+=(most)
fi

# ZOXIDE
if type zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
else
  MISSING_PKGS+=(zoxide)
fi

# FZF
export FZF_DEFAULT_OPTS="--layout=reverse --inline-info"
if type fzf &>/dev/null; then
  [[ ! -n "$(typeset +f | grep -E '^_fzf_')" ]] && eval "$(fzf --zsh)"
else
  MISSING_PKGS+=(fzf)
fi
if type fd &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f'
else
  unset FZF_DEFAULT_COMMAND
  MISSING_PKGS+=(fdfind)
fi
if type bat &>/dev/null; then
  export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"
else
  unset FZF_CTRL_T_OPTS
  MISSING_PKGS+=(batcat)
fi

## WEGO
if type wego &>/dev/null; then
  export WEGORC=$HOME/.config/wego/wegorc
else
  MISSING_PKGS+=(batcat)
fi

## THEME
export AGKOZAK_MULTILINE=0
export AGKOZAK_LEFT_PROMPT_ONLY=1
export AGKOZAK_PROMPT_CHAR=( ❯ ❯ ❮ )
export AGKOZAK_COLORS_PROMPT_CHAR='green'
export AGKOZAK_USER_HOST_DISPLAY=0
export AGKOZAK_CUSTOM_SYMBOLS=( '⇣⇡' '⇣' '⇡' '+' 'x' '!' '>' '?' 'S')
export AGKOZAK_BRANCH_STATUS_SEPARATOR=''
ZSH_HIGHLIGHT_STYLES[comment]='fg=magenta,cursive'
