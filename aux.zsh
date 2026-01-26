## RUST
if command -v rustup-init &>/dev/null; then
  export CARGO_HOME=$HOME/.local/share/cargo
  export RUSTUP_HOME=$HOME/.local/share/rustup
  export PATH=$PATH:$CARGO_HOME/bin:$HOME/.local/share/rustup/bin
else
  MISSING_PKGS+=(rustup)
fi
if ! command -v cargo &>/dev/null; then
  MISSING_PKGS+=(cargo)
fi

## HOMEBREW
if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
else
  MISSING_PKGS+=(brew)
fi

## PYENV
if command -v pyenv &>/dev/null; then
  export PYENV_ROOT=$HOME/.local/share/pyenv
  export PATH="/home/linuxbrew/.linuxbrew/opt/pyenv/bin:$PATH"
  export PATH="$PYENV_ROOT/shims:$PATH"
  export TK_PREFIX="$(brew --prefix tcl-tk)"
  export CPPFLAGS="-I${TK_PREFIX}/include ${CPPFLAGS}"
  export LDFLAGS="-L${TK_PREFIX}/lib ${LDFLAGS}"
  export PKG_CONFIG_PATH="${TK_PREFIX}/lib/pkgconfig:${PKG_CONFIG_PATH}"
  export OPENSSL_PREFIX="$(brew --prefix openssl@3)"
  export PYTHON_CONFIGURE_OPTS="--with-openssl=${OPENSSL_PREFIX}"
  eval "$(pyenv init - zsh)"
  eval "$(pyenv virtualenv-init -)"
fi

## TASKWARRIOR
if command -v task &>/dev/null; then
  export TASKDATA=$HOME/.config/task
  export TASKRC=$TASKDATA/taskrc
fi

## (NEO)VIM
if command -v nvim &>/dev/null; then
  export EDITOR=nvim
  export VISUAL=$EDITOR
  export MOST_EDITOR=nvim
  export MANPAGER="nvim +Man!"
elif command -v vim &>/dev/null; then
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
if command -v bw &>/dev/null; then
  export BITWARDENCLI_APPDATA_DIR=$HOME/.config/bw
else
  MISSING_PKGS+=(bw)
fi

## MOST
if command -v most &>/dev/null; then
  export PAGER=most
else
  MISSING_PKGS+=(most)
fi

# ZOXIDE
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
else
  MISSING_PKGS+=(zoxide)
fi

# FZF
export FZF_DEFAULT_OPTS="--layout=reverse --inline-info"
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
else
  MISSING_PKGS+=(fzf)
fi
if command -v fd &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f'
else
  unset FZF_DEFAULT_COMMAND
  MISSING_PKGS+=(fdfind)
fi
if command -v bat &>/dev/null; then
  export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"
else
  unset FZF_CTRL_T_OPTS
  MISSING_PKGS+=(batcat)
fi

## WEGO
export WEGORC=$HOME/.config/wego/wegorc

## THEME
ZSH_HIGHLIGHT_STYLES[comment]='fg=magenta,cursive'
ZSH_HIGHLIGHT_STYLES[path]='fg=magenta'
