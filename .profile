# Path
# ------------------------------------------------------------------------------
export PATH="$PATH:$HOME/.local/bin"

# Bash
# ------------------------------------------------------------------------------
export HISTSIZE=

# Theme
# ------------------------------------------------------------------------------
export GTK_THEME="Adwaita:dark"

# Programs
# ------------------------------------------------------------------------------
export SHELL="bash"
export PAGER="less"
export EDITOR="helix"
export VISUAL="helix"
export BROWSER="firefox"
export TERMINAL="footclient"

# Dotfiles
# ------------------------------------------------------------------------------
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export HISTFILE="$XDG_DATA_HOME/bash/history"
export LESSHISTFILE="$XDG_DATA_HOME/less/history"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export PASSWORD_STORE_DIR="`xdg-user-dir PROJECTS`/.password-store"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"

# NVIDIA
# ------------------------------------------------------------------------------
export WLR_NO_HARDWARE_CURSORS=1
export LIBVA_DRIVER_NAME=nvidia
export GBM_BACKEND=nvidia-drm
export __GLX_VENDOR_LIBRARY_NAME=nvidia

# Window manager
# ------------------------------------------------------------------------------
[ "$(tty)" = "/dev/tty1" ] && exec dbus-run-session sway --unsupported-gpu
