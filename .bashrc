source /usr/share/fzf/key-bindings.bash

export PS1="\[\e[38;2;104;157;106m\]\w\[\033[0m\] "

alias cat="bat"
alias f=fff
alias hx="helix"
alias ls="eza -a1 --icons --group-directories-first"
alias lz="lazygit"
alias rm-desktop-entries="sudo rm /usr/share/applications/*.desktop"
alias rm="trash"
alias t="footclient &"

# sleep timer
# ------------------------------------------------------------------------------
sleep-timer() {
	sleep "$1" && systemctl suspend
}

# config manager
# ------------------------------------------------------------------------------
config() {
	test -z "$1" && git=lazygit || git=git

	$git --work-tree="$HOME" --git-dir="$(xdg-user-dir PROJECTS)"/.dotfiles "$@"
}

# memes manager
# ------------------------------------------------------------------------------
meme() {
	dir="$(xdg-user-dir PICTURES)/memes"
	LS="ls -1 $dir"
	window_size=80
	image_size=$(python -c "print(f'{int($(tput cols)*$window_size/100)-4}x{$(tput lines)-1}')")

	$LS | fzf -m \
		--bind="alt-t:execute-silent(bash -ic 'trash $dir/{}')+reload($LS)" \
		--bind="alt-c:execute-silent(bash -ic dwebp-memes)+reload($LS)" \
		--header="enter:copy  alt-t:trash  alt-c:convert" \
		--preview="chafa --view-size $image_size '$dir/{}'" \
		--preview-window=$window_size% | \

	while read -r file; do
		wl-copy < "$dir/$file" || (echo "Failed to copy $file" >&2 && return 1)
	done
}

# images manager
# ------------------------------------------------------------------------------
gallery() {
	dir="${1:-$(xdg-user-dir PICTURES)}"
	LS="ls -1 $dir"
	window_size=80
	image_size=$(python -c "print(f'{int($(tput cols)*$window_size/100)-4}x{$(tput lines)-1}')")

	$LS | fzf -m \
		--bind="alt-t:execute-silent(bash -ic 'trash $dir/{}')+reload($LS)" \
		--bind="alt-r:execute-silent(convert $dir/{} -rotate  90 $dir/{})+reload($LS)" \
		--bind="alt-l:execute-silent(convert $dir/{} -rotate -90 $dir/{})+reload($LS)" \
		--header="alt-t:trash  alt-r:rotate-right  alt-l:rotate-left" \
		--preview="chafa --view-size $image_size '$dir/{}'" \
		--preview-window=$window_size%
}

# notes manager
# ------------------------------------------------------------------------------
nt() {
	dir="$(xdg-user-dir DOCUMENTS)/notes"
	LS="ls -1 $dir"

	$LS | fzf -m \
		--bind="alt-t:execute-silent(bash -ic 'trash $dir/{}')+reload($LS)" \
		--header="enter:edit  alt-t:trash" \
		--preview="bat --color=always --style=changes '$dir/{}'" \
		--preview-window=up,80% \
		--query="$1" \
		--select-1 | \

	while read -r file; do
		$EDITOR "$dir/$file" || return
	done
}

# trash manager
# ------------------------------------------------------------------------------
trash() {
	dir="$XDG_DATA_HOME/trash"

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
		local LS="ls -1 $dir"

		$LS | fzf -m --tac \
		--bind "alt-d:execute-silent(rm -r $dir/{})+reload($LS)" \
		--bind "alt-p:execute-silent(rm -r $dir && mkdir $dir)+reload($LS)" \
		--bind "alt-u:execute(du -hs $dir; read)" \
		--header="enter:restore  alt-d:delete  alt-p:purge  alt-u:usage" \
		--preview="cd $dir && eza -l {}" \
		--preview-window=up,1% | \

		while read -r file; do
			mv "$dir/$file" "${file#*---}" || return
		done
	fi
}

# ttv launcher
# ------------------------------------------------------------------------------
ttvmenu() {
	ttv | sort | column -ts";" -T2 -c180 | fzf -m | grep -oE "https://[^[:space:]]+" | \

	while read -r url; do
		footclient -a hidden -- streamlink --player mpv "$url" best &
	done
}

# sync $HOME/* with /mnt/backup/<host>
# ------------------------------------------------------------------------------
backup() {
	local mountpoint="/mnt/backup"

	test -z "$(findmnt $mountpoint)" && sudo mount $mountpoint
	test -z "$(findmnt $mountpoint)" && echo "Mount failed" >&2 && return 1
	rsync -ahv --delete --exclude=dotfiles/ "$HOME"/* "$mountpoint/$(uname -n)"
	sudo umount $mountpoint
}

# weather
# ------------------------------------------------------------------------------
wttr() {
	curl -s "https://wttr.in/$1?FQ"
}

wttr-desktop() {
	# hide cursor
	tput civis

	# remove current weather and last line break
	wttr "$1" | tail -n +6 | head -c -1
}

# convert WEBP meme/s into PNG
# ------------------------------------------------------------------------------
dwebp-memes() {
	for file in "$(xdg-user-dir PICTURES)"/memes/*.webp; do
		dwebp "$file" -o "${file%.*}.png" && trash "$file"
	done
}

# convert video/s into MKV (HEVC, AAC)
# ------------------------------------------------------------------------------
ffmpeg-mkv() {
	for file in "$@"; do
		ffmpeg -i "$file" -c:v libx265 -c:a aac "${file%.*}.mkv"
	done
}

# convert song/s into OPUS
# ------------------------------------------------------------------------------
ffmpeg-opus() {
	for file in "$@"; do
		ffmpeg -i "$file" -c:a libopus -b:a 192k "${file%.*}.opus"
	done
}

# fix-filenames-style.sh
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

# enumerate characters of the first line
# ------------------------------------------------------------------------------
enum() {
	head -n 1 | fold -w 1 | cat -n
}

# HTTP server
# ------------------------------------------------------------------------------
serve() {
	python -m http.server
}

# ls on cd
# ------------------------------------------------------------------------------
cd() {
	builtin cd "$@" && ls
}
