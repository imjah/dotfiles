source /usr/share/defaults/etc/profile

export PS1="\[\e[38;5;108m\]\w\[\033[0m\] "
export EDITOR="nvim"
export VISUAL="nvim"

alias du="du -h"
alias feh="feh --scale-down --auto-zoom"
alias ls="eza -1a --git --group-directories-first --icons"
alias rm="trash"
alias vi="neovim"
alias wget="wget --no-hsts -P `xdg-user-dir DOWNLOAD`"

# Mount, unmount or create backup
# ------------------------------------------------------------------------------
budget() {
	FILE="`xdg-user-dir DOCUMENTS`/sheets/budget.ods"

	if [ -e $FILE ]; then
		libreoffice $FILE
	else
		notify-send "Budget not found"
	fi
}

# Mount, unmount or create backup
# ------------------------------------------------------------------------------
backup() {
	mountpoint='/mnt/backup'

	if [[ $1 == '-m' ]]; then
		sudo mount $mountpoint

		return
	fi

	if [[ $1 == '-u' ]]; then
		sudo umount $mountpoint

		return
	fi

	if [[ -z $(findmnt $mountpoint) ]]; then
		sudo mount $mountpoint

		if [[ -z $(findmnt $mountpoint) ]]; then
			echo "Unable to mount backup drive"

			return 1
		fi
	fi

	src=(
		"$(xdg-user-dir DOCUMENTS)"
		"$(xdg-user-dir DOWNLOAD)"
		"$(xdg-user-dir GAMES)"
		"$(xdg-user-dir MUSIC)"
		"$(xdg-user-dir PICTURES)"
		"$(xdg-user-dir PROJECTS)"
		"$(xdg-user-dir REPOSITORIES)"
		"$(xdg-user-dir VIDEOS)"
	)

	filter=(
		".steam"
	)

	rsync -ahv --delete --filter="- ${filter[@]}" "${src[@]}" "$mountpoint/$(uname -n)/"

	echo "Unmounting..."
	sudo umount $mountpoint
}

# Mount USB drive
# ------------------------------------------------------------------------------
mu() {
	test -z "$1" && echo "No device name given" && return 1

	for i in {1..3}; do
		slot="/mnt/usb-$i"

		if [ -z `findmnt $slot` ]; then
			sudo mount -m --target $slot $@ && cd $slot

			return
		fi
	done

	echo "No available slot"
}

# Unmount USB drive
# ------------------------------------------------------------------------------
uu() {
	test -z "$1" && echo "No slot number given" && return 1

	sudo umount "/mnt/usb-$1"
}

# Auto cd
# ------------------------------------------------------------------------------
cd() {
	builtin cd "$@" && ls
}

# Move file/directory without repeating it's path (aka rename)
# ------------------------------------------------------------------------------
rn() {
	mv $1 ${1/$(basename $1)/$2}
}

# Extract tar archives into directory
# ------------------------------------------------------------------------------
ut() {
	DIR="${1%.tar*}"

	mkdir "$DIR" && tar -xC "$DIR" -f "$1" && trash "$1"
}

# Extract zip archives into directory
# ------------------------------------------------------------------------------
uz() {
	DIR="${1%.zip*}"

	mkdir "$DIR" && unzip -d "$DIR" "$1" && trash "$1"
}

# Convert WebP memes to PNG and trash it
# ------------------------------------------------------------------------------
dwebp-memes() {
	dir="$(xdg-user-dir PICTURES)/memes"

	for meme in $dir/*.webp; do
		if [[ -e $meme ]]; then
			dwebp $meme -o ${meme/.webp/.png}
			trash $meme
		fi
	done
}

# Convert video/s to MKV (HEVC, AAC)
# ------------------------------------------------------------------------------
ffmpeg-mkv() {
	files=""

	for file in "$@"; do
		files="$files|$file"
	done

	ffmpeg -i "concat:${files:1}" -c:v libx265 -c:a aac ${O:-output}.mkv
}

# Convert FLAC files to OPUS
# ------------------------------------------------------------------------------
ffmpeg-flac-to-opus() {
	for file in ${1:-.}/*.flac; do
		ffmpeg -i "$file" -c:a libopus -b:a 192k "${2:-.}/$(basename ${file/.flac/.opus})"
	done
}

# Copy and format FLAC album into music archive
# make clone of it with OPUS compression into music storage
# ------------------------------------------------------------------------------
music-add-album() {
	test -z "$1" && echo "No artist name given" && return 1

	storage="$(xdg-user-dir MUSIC)/$1"
	archive="$(xdg-user-dir MUSIC)/.archive/$1"

	mkdir -p "$archive" "$storage"
	cp -t "$archive" cover.* *.flac
	cp -t "$storage" cover.*
	format $archive/*
	ffmpeg-flac-to-opus "$archive" "$storage"
}

# Sync music storage
# ------------------------------------------------------------------------------
music-sync-storage() {
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

# Pick a note
# ------------------------------------------------------------------------------
nt() {
	DIR="`xdg-user-dir DOCUMENTS`/notes"

	if [[ -n "$1" ]]; then
		nvim "$DIR/$1"

		return
	fi

	FILE=`find "$DIR" -type f | sed "s~$DIR/~~" | sort | fzf --preview "cat $DIR/{}"`

	[[ -n "$FILE" ]] && nvim "$DIR/$FILE"
}

# Pick a meme
# ------------------------------------------------------------------------------
pick-meme() {
	DIR="$(xdg-user-dir PICTURES)/memes"
	FILE="$(ls "$DIR" | fzf $@)"

	[ "$FILE" ] && xdg-open "$DIR/$FILE"
}

# Pick a project
# ------------------------------------------------------------------------------
pick-project() {
	DIR=$(xdg-user-dir PROJECTS)
	FILE=$(find "$DIR" -mindepth 1 -maxdepth 1 -type d \
	     | sed "/password-store/d;/dotfiles/d;s~$DIR/~~" \
	     | sort \
	     | cat - <(echo 'Clone existing project') \
	     | cat - <(echo 'Create new project') \
	     | fzf)

	if [[ $FILE == "Clone existing project" ]]; then
		r="$(xdg-user-dir REPOSITORIES)"
		p="$(xdg-user-dir PROJECTS)"
		n=$(find "$r" -mindepth 1 -maxdepth 1 -type d | sed "s~$r/~~" | sort | fzf)

		[[ -n "$n" ]] && git clone "$r/$n" "$p/${n//".git"/}" && cd "$p/${n//".git"/}" && nvim

		return
	fi

	if [[ $FILE == "Create a new project" ]]; then
		read -p 'Name: ' n

		r="$(xdg-user-dir REPOSITORIES)/$n.git"
		p="$(xdg-user-dir PROJECTS)"

		[[ -n "$n" ]] && git init --bare "$r" && git clone "$r" "$p/$n" && cd "$p/$n" && nvim

		return
	fi

	[[ -n "$FILE" ]] && cd "$DIR/$FILE" && nvim
}

# Pick a livestream
# ------------------------------------------------------------------------------
pick-livestream() {
	LINK="$(ttv $@ | sort | column -t -s";" | fzf | grep -oE "https://[^[:space:]]+")"

	i3-msg "move scratchpad"

	[[ "$LINK" ]] && mpv $LINK
}

# Run program in endless loop
# ------------------------------------------------------------------------------
loop() {
	while true; do
		$@
	done
}

# Format files/directories names with my style
# ------------------------------------------------------------------------------
format() {
	s="-"

	for file in "$@"; do
		e=${file##*.}
		f=$(basename "$file")
		f=${f%.*}
		f=${f,,}
		f=${f//" - "/$s}
		f=${f//" "/$s}
		f=${f//"_"/$s}
		f=${f//"("/}
		f=${f//")"/}
		f=${f//"'"/}
		f=${f//"’"/}
		f=${f//","/}
		f=${f//"!"/}
		f=${f//"?"/}
		f=${f//"."/}

		mv -n "$file" "$(dirname "$file")/$f.$e"
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
	python3 -m http.server
}

# Download weather forecast
# ------------------------------------------------------------------------------
weather() {
	curl -s https://wttr.in/Stargard | head -n -3
}
