export PS1="\[\e[38;2;104;157;106m\]\w\[\033[0m\] "

alias ls="eza -a1 --icons --group-directories-first"
alias rm="trash"
alias hx="helix"
alias rm-desktop-entries="sudo rm /usr/share/applications/*.desktop"

meme() {
	dir="${1:-$(xdg-user-dir PICTURES)}/memes"
	FD="fd -t f . --base-directory $dir"
	size="80"
	view=`python -c "print(f'{int($(tput cols)*$size/100)-4}x{$(tput lines)-1}')"`

	$FD | fzf \
		--header="enter:copy  alt-t:trash" \
		--bind "alt-c:execute-silent(wl-copy < $dir/{})" \
		--bind "alt-t:execute-silent(trash $dir/{})+reload($FD)" \
		--preview "chafa $dir/{}" \
		--preview-window=$size% | \

	while read -r file; do
		wl-copy < "$dir/$file"
	done
}

# nt
# ------------------------------------------------------------------------------
nt() {
	dir="${1:-$(xdg-user-dir DOCUMENTS)}/notes"
	FD="fd -t f . --base-directory $dir"

	$FD | fzf \
		--bind "alt-t:execute-silent(trash $dir/{})+reload($FD)" \
		--header="enter:open  alt-t:trash" \
		--preview "${VIEWER:-bat --color=always --style=changes} $dir/{}" \
		--preview-window=up,70% | \

	while read -r file; do
		${EDITOR:-helix} "$dir/$file"
	done
}

# wttr
# ------------------------------------------------------------------------------
wttr() {
	curl -s https://wttr.in/$1?FQ
}

wttr-desktop() {
	# Hide cursor
	tput civis

	# Print without current weather and trailing line break
	wttr "$1" | tail -n +6 | head -c -1
}

# Trash
# ------------------------------------------------------------------------------
trash() {
	dir="${XDG_DATA_HOME:-$HOME/.local/share}/trash"

	if [[ -e "$dir" ]]; then
		test ! -d "$dir" && echo "Cannot make $dir: file exist." >&2 && return
	else
		mkdir -p "$dir" || return
	fi

	if [[ "$1" ]]; then
		for file in "$@"; do
			mv "$file" "$dir/$(date +"%Y-%m-%d-%T---")$(basename "$file")" || return
		done
	else
		LS="ls -1 $dir"

		$LS | fzf -m \
		--header="enter:restore  alt-d:delete  alt-p:purge  alt-u:usage" \
		--bind "alt-d:execute-silent(rm -r $dir/{})+reload($LS)" \
		--bind "alt-p:execute-silent(rm -r $dir && mkdir $dir)+reload($LS)" \
		--bind "alt-u:execute(du -hs $dir; read)" | \

		while read -r file; do
			mv "$dir/$file" "${file#*---}" || return
		done
	fi
}

# TTV launcher
# ------------------------------------------------------------------------------
ttvmenu() {
	ttv | sort | column -tm -s";" -T2 -c186 | fzf -m | grep -oE "https://[^[:space:]]+" | \

	while read -r url; do
		footclient -a "hidden" -- streamlink --twitch-disable-ads --player mpv $url best &
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

# Convert WEBP meme/s into PNG
# ------------------------------------------------------------------------------
dwebp-memes() {
	for file in $(xdg-user-dir PICTURES)/memes/*.webp; do
		dwebp $file -o "${file%.*}.png" && trash $file
	done
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
		f=${f//"."/-}
		f=${f//"--"/-}
		f=${f//"("/}
		f=${f//")"/}
		f=${f//"'"/}
		f=${f//"’"/}
		f=${f//","/}
		f=${f//"!"/}
		f=${f//"?"/}

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
