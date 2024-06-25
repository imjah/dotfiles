# Path
# ------------------------------------------------------------------------------
export PATH="$PATH:$HOME/.local/bin"

# Bash
# ------------------------------------------------------------------------------
export HISTSIZE=

# Programs
# ------------------------------------------------------------------------------
export SHELL="/bin/bash"
export PAGER="/bin/less"
export EDITOR="/bin/nvim"
export VISUAL="/bin/nvim"
export BROWSER="/bin/firefox"

# Dotfiles
# ------------------------------------------------------------------------------
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export HISTFILE="$XDG_DATA_HOME/bash/history"
export LESSHISTFILE="$XDG_DATA_HOME/less/history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export PASSWORD_STORE_DIR="`xdg-user-dir PROJECTS`/.password-store"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"

# Theme
# ------------------------------------------------------------------------------
export BG="#282828"
export FG="#ebdbb2"
export RED="#cc241d"
export GREEN="#98971a"
export YELLOW="#d79921"
export BLUE="#458588"
export PURPLE="#b16286"
export AQUA="#689d6a"
export GRAY="#a89984"
export FONT_TYPE="hack nerd font"
export FONT_SIZE="9"
export GTK_THEME="Adwaita:dark"

# NVIDIA
# ------------------------------------------------------------------------------
export WLR_NO_HARDWARE_CURSORS=1
export LIBVA_DRIVER_NAME=nvidia
export GBM_BACKEND=nvidia-drm
export __GLX_VENDOR_LIBRARY_NAME=nvidia

# Window manager
# ------------------------------------------------------------------------------
[ "$(tty)" = "/dev/tty1" ] && exec dbus-run-session sway --unsupported-gpu
