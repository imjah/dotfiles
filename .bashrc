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

# Auto cd
# ------------------------------------------------------------------------------
cd() {
	builtin cd "$@" && ls
}

# Convert WebP memes to PNG and trash it
# ------------------------------------------------------------------------------
dwebp-memes() {
	dir="$(xdg-user-dir PICTURES)/memes"

	for meme in $dir/*.webp; do
		dwebp $meme -o ${meme/.webp/.png}
		trash $meme
	done
}

# Concat DV tapes and convert them to MP4
# ------------------------------------------------------------------------------
ffmpeg-concat-dv-convert-mp4() {
	DIR="${1:-'.'}"

	for file in $DIR/*.dv; do
		FILES="$FILES$file|"
	done

	ffmpeg -i "concat:${FILES:0:-1}" -vf yadif "$DIR/tape.mp4"
}

# Convert FLAC files to OPUS files
# ------------------------------------------------------------------------------
ffmpeg-flac-to-opus() {
	dir=${1:-.}

	for file in $dir/*.flac; do
		ffmpeg -i "$file" -c:a libopus -b:a 192k "${file/.flac/.opus}"
	done
}

# Move FLAC and OPUS album files to music directory
# ------------------------------------------------------------------------------
mv-music() {
	music_dir="$(xdg-user-dir MUSIC)"
	album_dir="${1:-other}"

	storage_dir="$music_dir/$album_dir"

	mkdir -p "$storage_dir"
	mv -t "$storage_dir" *.opus
	cp -t "$storage_dir" cover.*

	archive_dir="$music_dir/.archive/$album_dir"

	mkdir -p "$archive_dir"
	mv -t "$archive_dir" *.flac cover.*
}

# Sync music storage
# ------------------------------------------------------------------------------
rsync-music() {
	rsync -av --exclude=".archive" "$(xdg-user-dir MUSIC)/" ${1:-.}
}

# Manage config
# ------------------------------------------------------------------------------
config() {
	GIT=lazygit

	if [ $1 ]; then
		GIT=git
	fi

	$GIT --git-dir=`xdg-user-dir PROJECTS`/dotfiles --work-tree=$HOME $@
}

# Pick note
# ------------------------------------------------------------------------------
nt() {
	DIR="`xdg-user-dir DOCUMENTS`/notes"
	FILE=`find "$DIR" -type f | sed "s~$DIR/~~" | fzf --preview "cat $DIR/{}"`

	[ "$FILE" ] && ${EDITOR:-nvim} "$DIR/$FILE"
}

# Pick meme
# ------------------------------------------------------------------------------
me() {
	DIR="`xdg-user-dir PICTURES`/memes"
	FILE=`find "$DIR" -type f | sed "s~$DIR/~~" | fzf`

	[ "$FILE" ] && xdg-open "$DIR/$FILE"
}

# Format files and directories names with my style
# ------------------------------------------------------------------------------
format() {
	s="-"

	for file in "$@"; do
		f=${file,,}
		f=${f//" - "/$s}
		f=${f//" "/$s}
		f=${f//"_"/$s}
		f=${f//"("/}
		f=${f//")"/}

		mv -n "$file" "$f"
	done
}

# Enumerate characters
# ------------------------------------------------------------------------------
enum() {
	read line; echo $line | fold -w 1 | cat -n
}

# Create simple HTTP server
# ------------------------------------------------------------------------------
serve() {
	python -m http.server
}

# Download weather forecast
# ------------------------------------------------------------------------------
weather() {
	curl -s https://wttr.in/Stargard | head -n -3
}
