source /usr/share/defaults/etc/profile

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
export FONT_TYPE="hack"
export FONT_SIZE="9"

# Prompt
# ------------------------------------------------------------------------------
export PS1="\[\e[38;2;$(printf "%d;%d;%d" 0x${AQUA:1:2} 0x${AQUA:3:2} 0x${AQUA:5:2})m\]\w\[\033[0m\] "

# Programs
# ------------------------------------------------------------------------------
export SHELL="/bin/bash"
export PAGER="/bin/less"
export EDITOR="/bin/nvim"
export VISUAL="/bin/nvim"
export BROWSER="/bin/firefox"

alias ls="eza -a1 --icons --group-directories-first"
alias rm="trash"
alias vi="nvim"
alias feh="feh -B \"$BG\""
alias qrencode="qrencode --background=${BG:1} --foreground=${FG:1} -s 6"
alias dmenu="dmenu -i -l 5 -fn '$FONT_TYPE-$FONT_SIZE' -nb '$BG' -nf '$FG' -sb '$AQUA' -sf '$FG'"
alias i3-dmenu-desktop="i3-dmenu-desktop --dmenu='dmenu -i -l 5 -fn "$FONT_TYPE-$FONT_SIZE" -nb "$BG" -nf "$FG" -sb "$AQUA" -sf "$FG"'"

# Move file without repeating it's path
# ------------------------------------------------------------------------------
rn() {
	mv $1 ${1/$(basename $1)/$2}
}

# Extract tar archives into directory
# ------------------------------------------------------------------------------
ut() {
	DIR="${1%.tar*}"

	mkdir "$DIR" && tar -xC "$DIR" -f "$1" && cd "$DIR"
}

# Extract zip archives into directory
# ------------------------------------------------------------------------------
uz() {
	DIR="${1%.zip*}"

	mkdir "$DIR" && unzip -d "$DIR" "$1" && cd "$DIR"
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

# Mount, unmount backup drive or make a backup
# ------------------------------------------------------------------------------
backup() {
	mountpoint='/mnt/backup'

	if [[ $1 == '-m' ]]; then
		sudo mount $mountpoint && cd $mountpoint
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

	rsync -ah --info=progress2 --delete $HOME/ "$mountpoint/$(uname -n)"

	sudo umount $mountpoint
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

# Note launcher
# ------------------------------------------------------------------------------
nt() {
	d="$(xdg-user-dir DOCUMENTS)/notes"

	if [[ -n "$1" ]]; then
		$EDITOR "$d/$1"
		return
	fi

	f=$(find "$d" -type f | sed "s~$d/~~" | sort | fzf --preview "cat $d/{}")

	test -n "$f" && nvim "$d/$f"
}

# TTV launcher
# ------------------------------------------------------------------------------
ttvmenu() {
	ttv | sort | column -t -s";" | fzf -m | grep -oE "https://[^[:space:]]+" | \

	while read -r url; do
		gnome-terminal -t "TTV Log" -- streamlink --twitch-disable-ads --player mpv $url best
	done
}

# Pass launcher
# ------------------------------------------------------------------------------
passmenu() {
	f="$(find "$PASSWORD_STORE_DIR" -type f | grep -oE "[^/]+.gpg$" | sed "s/.gpg//" | sort | dmenu)"

	if [[ -z "$f" ]]; then
		return
	fi

	if [[ "$1" == "-q" ]]; then
		pass "$f" | head -n 1 | qrencode -o /tmp/pass.png && feh /tmp/pass.png
	else
		pass -c "$f"
	fi
}

# Filenames fixer
# ------------------------------------------------------------------------------
fix() {
	for file in "$@"; do
		e=${file##*.}
		f=$(basename "$file")
		f=${f%.*}
		f=${f,,}
		f=${f//" - "/-}
		f=${f//" "/-}
		f=${f//"_"/-}
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

# Dotfiles manager
# ------------------------------------------------------------------------------
config() {
	test -z "$1" && git=lazygit || git=git

	$git --git-dir="$(xdg-user-dir PROJECTS)/.dotfiles" --work-tree=$HOME $@
}

# Enumerate first line characters
# ------------------------------------------------------------------------------
enum() {
	head -n 1 | fold -w 1 | cat -n
}

# Run a simple HTTP server
# ------------------------------------------------------------------------------
serve() {
	python3 -m http.server
}

# Auto ls
# ------------------------------------------------------------------------------
cd() {
	builtin cd "$@" && ls
}
