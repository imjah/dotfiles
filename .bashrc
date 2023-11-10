source /usr/share/defaults/etc/profile

export PS1="\[\e[38;5;108m\]\w\[\033[0m\] "
export EDITOR="nvim"
export VISUAL="nvim"

alias ls="eza -1a --git --group-directories-first --icons"
alias vi="neovim"

cd() {
	builtin cd "$@" && ls
}
