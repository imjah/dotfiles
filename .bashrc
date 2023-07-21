source /usr/share/defaults/etc/profile

alias dotfiles="git --git-dir=$REPOSITORIES/dotfiles --work-tree=$HOME"
alias dconf-dump="dconf dump / > $XDG_CONFIG_HOME/dconf/user.dump"
alias dconf-load="dconf load / < $XDG_CONFIG_HOME/dconf/user.dump"
alias pip="pip3"
alias python="python3"

enum() {
	read line; echo $line | fold -w 1 | cat -n
}

http-server() {
	IPs=`ip addr | grep 192.168 | cut -d " " -f 6 | cut -d "/" -f 1`

	for IP in $IPs; do
		echo Local network address: http://$IP:8000
	done

	python -m http.server
}
