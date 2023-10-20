source /usr/share/defaults/etc/profile

alias config="git --git-dir=`xdg-user-dir PROJECTS`/dotfiles --work-tree=$HOME"
alias ls="eza -1a --git --group-directories-first --icons"
alias open="xdg-open"
alias pip="pip3"
alias python="python3"
alias serve="python3 -m http.server"
alias vi="nvim"

cd() {
	builtin cd "$@" && ls
}
