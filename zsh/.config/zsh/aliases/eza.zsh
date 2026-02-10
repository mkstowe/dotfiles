if ! (( $+commands[eza] )); then
  print "eza-plugin: eza not found on path. Please install eza before using this plugin." >&2
  return 1
fi

alias ls='eza -h --group-directories-first --icons --color-scale-mode=gradient'
alias l='ls --all'
alias la='ls -la --git'
alias lsa='la'
alias ll='la'
alias lt='ls --tree'
alias l.='ls -a -d .*'
alias ltree='lt --level=2 --long --all'
alias dirs='ls --only-dirs'
alias lsize='ls -l --sort=size'
alias lbig='ls -l --sort=size --reverse'
alias lnew='ls -l --sort=newest'
alias lold='ls -l --sort=oldest'
alias lg='ls -l --git --git-ignore'
alias lga='la'
alias lx="ls -lbhHigUmuSa --git --time-style=long-iso"
alias l1='ls -1'
alias llink='ls -l --links'

