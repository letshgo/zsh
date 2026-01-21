## HOMEBREW
if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
else
  MISSING_PKGS+=(brew)
fi
## RUST
if command -v cargo &>/dev/null; then
  export CARGO_HOME=$HOME/.local/share/cargo
  export RUSTUP_HOME=$HOME/.local/share/rustup
  export PATH=$PATH:$CARGO_HOME/bin
elif command -v rustc &>/dev/null; then
  MISSING_PKGS+=(cargo)
else
  MISSING_PKGS+=(cargo)
  MISSING_PKGS+=(rustup)
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

# PYENV
if command -v pyenv &>/dev/null; then
  eval "$(pyenv init - zsh)"
else
  MISSING_PKGS+=(pyenv)
fi

# FZF
export FZF_DEFAULT_OPTS="--layout=reverse --inline-info"
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
else
  MISSING_PKGS+=(fzf)
fi
if command -v fd &>/dev/null && ! grep debian /etc/os-release &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f'
else
  unset FZF_DEFAULT_COMMAND
  MISSING_PKGS+=(fdfind)
fi
if command -v bat &>/dev/null && ! grep debian /etc/os-release &>/dev/null; then
  export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"
else
  unset FZF_CTRL_T_OPTS
  MISSING_PKGS+=(batcat)
fi
## DEBIAN
if grep debian /etc/os-release &>/dev/null; then
  alias bat=batcat
  alias fd=fdfind
  if command -v fdfind &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fdfind --type f'
  else
    unset FZF_DEFAULT_COMMAND
    MISSING_PKGS+=(fdfind)
  fi
  if command -v batcat &>/dev/null; then
    export FZF_CTRL_T_OPTS="--preview 'batcat -n --color=always {}'"
  else
    unset FZF_CTRL_T_OPTS
    MISSING_PKGS+=(batcat)
  fi
fi
