export PS1="\[\e[1;33m\]\@ \[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]$ "
export EDITOR="emacsclient -nw"
export ALTERNATE_EDITOR=""

alias ec='emacsclient -nw'

alias chef-mode='eval "$(chef shell-init $(basename $SHELL))"; export PS1="(CDK)$PS1"; export PATH="/opt/gimme-vagrant/bin:$PATH"'
alias ansible-mode='eval "$(ansible-dk shell-init bash)"; export PS1="(ADK)$PS1"'
alias docker-mode='eval "$(docker-machine env default)"; export PS1="(docker)$PS1"'
alias perl-mode='source ~/perl5/perlbrew/etc/bashrc; export PS1="(perlbrew)$PS1"'

#check for colordiff and alias it to diff
which colordiff &>/dev/null && alias diff=colordiff

#check for source-highlight lesspipe and set it up
lesspipe=$(which src-hilite-lesspipe.sh)
if [ -z "$lesspipe" ]
then
    lesspipe=/usr/share/source-highlight/src-hilite-lesspipe.sh
fi
if [ -x "$lesspipe" ]
then
    export LESSOPEN="| $lesspipe %s"
    export LESS=' -R '
fi

git-add-ignore-whitespace () {
    git diff -w --no-color $@ | git apply --cached --ignore-whitespace
#    git checkout -- $@
}

kitchen-local() {
    file=.kitchen.$1.yml
    if [ -e $file ]
    then
	echo "using $file for KITCHEN_LOCAL_YAML"
	export KITCHEN_LOCAL_YAML=$file
    else
	echo "$file does not exist - doing nothing"
    fi
}

vpn-start() {
    sudo /etc/init.d/openvpn start $1
}
vpn-stop() {
    sudo /etc/init.d/openvpn stop $1
}
vpn-status() {
    sudo /etc/init.d/openvpn status $1
}
_vpns() {
    local vpns
    vpns=$(ls /etc/openvpn/*.conf | sed -e 's|^/etc/openvpn/||' | sed -e 's/\.conf$//')
    COMPREPLY=( $(compgen -W "$vpns" -- ${COMP_WORDS[COMP_CWORD]}) )
}
complete -F _vpns vpn-start vpn-stop vpn-status

if [ -d ~/.rbenv/bin ]
then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
fi

if [ $(uname) == 'Darwin' ]
then
    if [ -f $(brew --prefix)/etc/bash_completion ]; then
	. $(brew --prefix)/etc/bash_completion
    fi
fi
