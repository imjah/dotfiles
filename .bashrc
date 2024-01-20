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


ffmpeg-flac-to-opus() {
	dir=${1:-.}

	for file in $dir/*.flac; do
		ffmpeg -i "$file" -c:a libopus -b:a 192k "${file/.flac/.opus}"
	done
}


save-music-as() {
	music_dir="$(xdg-user-dir MUSIC)"
	album_dir="${1:-other}"

	# Music storage
	storage_dir="$music_dir/$album_dir"

	mkdir -p "$storage_dir"
	mv -t "$storage_dir" *.opus
	cp -t "$storage_dir" cover.*

	# Music archive
	archive_dir="$music_dir/.archive/$album_dir"

	mkdir -p "$archive_dir"
	mv -t "$archive_dir" *.flac cover.*
}

sync-music-with() {
	rsync -av --exclude=".archive" "$(xdg-user-dir MUSIC)/" ${1:-.}
}
