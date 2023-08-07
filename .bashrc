source /usr/share/defaults/etc/profile

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

repo-ls() {
	ls $REPOSITORIES_REMOTE
}

repo-init() {
	name=$1

	[[ ${name:(-4):4} == ".git" ]] || name="$name.git"

	git init --bare "$REPOSITORIES_REMOTE/$name"
}

repo-clone() {
	name=$1

	[[ ${name:(-4):4} == ".git" ]] || name="$name.git"

	git clone "$REPOSITORIES_REMOTE/$name" $2
}

repo-init-clone() {
	repo-init $1 && repo-clone $1
}

