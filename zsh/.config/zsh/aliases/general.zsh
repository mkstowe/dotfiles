
alias ez='nvim ~/.zshrc'
alias po='poweroff'
alias sudo='sudo '
alias ag='acs -g'

# NPM
alias npmi='npm i'
alias ni='npm i'
alias npmg='npm i -g'
alias npmr='npm run'
alias npmd='npm i -D'

alias showip='hostname -i'

alias mv='mv -vi'
alias cp='cp -vir'

alias q='exit'
alias :q='exit'
alias c='clear'
alias pd='pwd'

alias h='history'
alias hg='fc -El 0 | rg'
alias dud='du -d 1 -h'
alias duf='du -sh'
alias t='tail -f'
alias help='man'
alias p='ps -f'
alias grep="rg"
alias g='rg'
alias clip='wl-copy 2>/dev/null'

alias update-system='sudo pacman -Syu && paru -Sua && flatpak update'

alias mkdir='mkdir -p'

mdc() {
  mkdir -p $1 && cd $1
}

alias loadz='exec zsh'

alias vim='nvim'
alias vi='nvim'
alias v='fasd -f -e nvim'

angular() {
  googler $1 -w angular.io
}

google() {
  googler $1
}

reddit() {
  googler $1 -w reddit.com
}

alias timer='arttime -k timer.custom'

alias stowe='stow'
alias calc='qalc'

alias rm='echo "use del instead"'
alias roll='/home/mkstowe/bin/rolldice.sh'
alias rolldice='/home/mkstowe/bin/rolldice.sh'

alias cd..='cd ..'
alias S='sudo !!'
