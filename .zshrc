# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=""

fpath+=$HOME/.zsh/pure

autoload -U promptinit; promptinit

zstyle :prompt:pure:git:branch color cyan
zstyle :prompt:pure:git:action color cyan
zstyle :prompt:pure:host color cyan
zstyle :prompt:pure:prompt:continuation color cyan
zstyle :prompt:pure:virtualenv color cyan
zstyle :prompt:pure:user color cyan


prompt pure
source ~/.zplug/init.zsh

zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "MichaelAquilina/zsh-you-should-use"

zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/colorize", from:oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "plugins/cp", from:oh-my-zsh
zplug "plugins/man", from:oh-my-zsh
zplug "plugins/pip", from:oh-my-zsh
zplug "plugins/archlinux", from:oh-my-zsh
zplug "plugins/copyfile", from:oh-my-zsh
zplug "plugins/extract", from:oh-my-zsh
zplug "plugins/safe-paste", from:oh-my-zsh


if ! zplug check --verbose; then
	printf "Install? [y/N]: "
	if read -q; then
		echo; zplug install
	fi
fi

zplug load

source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(fasd --init auto)"


alias ez='sudo nvim ~/.zshrc'
alias ezsh='sudo nvim ~/.zshrc'

alias mc='make clean'
alias po='poweroff'
alias reboot='systemctl reboot'
alias sus='betterlockscreen -s'
alias sudo='sudo '

alias gs='git status'
alias ga='git add -A'
alias gp='git push'
alias gpull='git pull'

gc () {
	git add .
	git commit -m "$1"
	git push
}

alias ds='yadm status'
alias dp='yadm push'

da () {
	if [ -n "$1" ]; then
		yadm add $1
		echo "Added $1"
	else
		yadm add -u
		echo "Added untracked files"
	fi
}

dc () {
	yadm add -u
	yadm commit -m "$1"
	yadm push
}

alias uu='sudo pacman -Syu'
alias ls='ls -Fsh1 --color=auto'
alias lsa='ls -AFsh1 --color=auto'
alias lsl='ls -AFosh1 --color=auto'
alias showip='hostname -I'

alias venv='source env/bin/activate'
alias q='exit'
alias c='clear'
alias h='history'
alias pd='pwd'

alias loadz='source ~/.zshrc'
alias loadzsh='source ~/.zshrc'
alias loadX='xrdb ~/.Xresources'

alias nf='neofetch'
alias fortune=cat='clear && fortune -s | python /home/michael/.local/bin/fortune-cat -p 1 -mtl 35'
alias bun='~/bin/bunnyfetch'

alias sshnc='ssh mkstrnrc@server276.web-hosting.com -p21098'

alias vim='nvim'
alias vi='nvim'

alias v='f -e nvim'
alias o='f -e zathura'


savepac () {
	pacman -Qet | awk {'print $1'} > Documents/pacman_list.txt
}


killport () {
	if [[ $(lsof -i tcp:$1) ]]; then
		lsof -i tcp:$1 | awk 'NR!=1 {print $2}' | xargs kill 
	fi
}

alias fm='font-manager'
