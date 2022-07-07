source /usr/share/defaults/etc/profile

alias config="git --git-dir=$HOME/repositories/dotfiles.git --work-tree=$HOME"
alias dconf-dump="dconf dump / > $XDG_CONFIG_HOME/dconf/user.dump"
alias dconf-load="dconf load / < $XDG_CONFIG_HOME/dconf/user.dump"
alias http-server="python3 -m http.server"
alias pass-pekao="pass pekao | head -n 1 | fold -w 1 | cat -n"
alias pip="pip3"
alias python="python3"
