#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

# PS1='[\u@\h \W]\$ '
PS1="\e[0;31m\w > \e[0m"


# 
# Aliases
#
alias eb='sudo vim ~/.bashrc'
alias mc='make clean'
alias po='poweroff'
alias sus='betterlockscreen -s'
alias sudo='sudo '

alias ..='cd ..'
alias ....='cd ../../'
alias ......='cd ../../../'

alias gs='git status'
alias ga='git add .'
alias gp='git push'
gc() {
	git add .
	git commit -m "$@"
	git push
}

alias uu='sudo pacman -Syu'
alias ls='ls -FSsh1 --color=auto'
alias lsa='ls -a -FSsh1 --color=auto'
alias showip='hostname -I'
alias restartapache='sudo systemctl restart apache2'

alias venv='source env/bin/activate'

alias q='exit'
alias c='clear'
alias h='history'
alias pd='pwd'

alias loadbash='source ~/.bashrc'
alias loadX='xrdb ~/.Xresources'

alias nf='neofetch'
alias fortune-cat='clear && fortune -s | python /home/michael/.local/bin/fortune-cat -p 1 -mtl 35'
alias bun='~/dotfiles/bunnyfetch'

alias sshnc='ssh mkstrnrc@server276.web-hosting.com -p21098'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
