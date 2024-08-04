alias ls="eza -a1 --icons --group-directories-first"
alias rm="trash"
alias hx="helix"

# Prompt
# ------------------------------------------------------------------------------
export PS1="\[\e[38;2;104;157;106m\]\w\[\033[0m\] "

# TTV launcher
# ------------------------------------------------------------------------------
ttvmenu() {
	ttv | sort | column -t -s";" | fzf -m | grep -oE "https://[^[:space:]]+" | \

	while read -r url; do
		footclient -T "TTV Log" -- streamlink --twitch-disable-ads --player mpv $url best &
	done
}

# Dotfiles manager
# ------------------------------------------------------------------------------
config() {
	test -z "$1" && git=lazygit || git=git

	$git --git-dir="$(xdg-user-dir PROJECTS)/.dotfiles" --work-tree=$HOME $@
}

# Sync $HOME/* with /mnt/backup/<host>
# ------------------------------------------------------------------------------
backup() {
	mountpoint="/mnt/backup"

	test -z "$(findmnt $mountpoint)" && sudo mount $mountpoint
	test -z "$(findmnt $mountpoint)" && echo Mount failed >&2 && return 1
	rsync -ahv --delete $HOME/* "$mountpoint/$(uname -n)"
	sudo umount $mountpoint
}

# Convert video/s into MKV (HEVC, AAC)
# ------------------------------------------------------------------------------
ffmpeg-mkv() {
	for file in "$@"; do
		ffmpeg -i "$file" -c:v libx265 -c:a aac "${file%.*}.mkv"
	done
}

# Convert song/s into OPUS
# ------------------------------------------------------------------------------
ffmpeg-opus() {
	for file in "$@"; do
		ffmpeg -i "$file" -c:a libopus -b:a 192k "${file%.*}.opus"
	done
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

# Enumerate characters of the first line
# ------------------------------------------------------------------------------
enum() {
	head -n 1 | fold -w 1 | cat -n
}

# HTTP server
# ------------------------------------------------------------------------------
serve() {
	python -m http.server
}

# Auto ls on cd
# ------------------------------------------------------------------------------
cd() {
	builtin cd "$@" && ls
}
