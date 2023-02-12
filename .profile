source /usr/share/defaults/etc/profile

# Default applications
export EDITOR="neovim"

# Directories
export PROJECTS="$HOME/projects"

# XDG Base Directory
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

# Dotfiles path overwrite
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GOPATH="$XDG_DATA_HOME/go"
export HISTFILE="$XDG_DATA_HOME/bash/history"
export LESSHISTFILE="$XDG_DATA_HOME/less/history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"

# Move xsession-errors
if [ -e "$HOME/.xsession-errors" ]; then
	mkdir -p "$XDG_CACHE_HOME/x11"
	mv -f "$HOME/.xsession-errors" "$XDG_CACHE_HOME/x11/xsession-errors"
fi
