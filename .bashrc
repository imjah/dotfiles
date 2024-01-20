source /usr/share/defaults/etc/profile

export PS1="\[\e[38;5;108m\]\w\[\033[0m\] "
export EDITOR="nvim"
export VISUAL="nvim"

alias feh="feh --scale-down --auto-zoom"
alias ls="eza -1a --git --group-directories-first --icons"
alias rm="trash"
alias vi="neovim"
alias wget="wget --no-hsts -P `xdg-user-dir DOWNLOAD`"
alias untar="tar -xf"

cd() {
	builtin cd "$@" && ls
}


# Convert WebP memes to PNG and trash it

ee() {
	dir="$(xdg-user-dir PICTURES)/memes"

	for meme in $dir/*.webp; do
		dwebp $meme -o ${meme/.webp/.png}
		trash $meme
	done
}
