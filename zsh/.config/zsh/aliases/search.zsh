alias g='rg --smart-case'
alias rg='rg --smart-case'
alias rgn='rg -n --smart-case'
alias rgw='rg -w --smart-case'
alias rgi='rg -i'
alias rgl='rg --files-with-matches --smart-case'
alias rgv='rg --invert-match --smart-case'
alias rgc='rg -C 3 --smart-case'
alias rgt='rg -g --smart-case'

alias fd='fd -H --follow'
alias fdf='fd --color always -H --follow -t f'
alias fdd='fd --color always -H --follow -t d'
alias fde='fd --color always -H --follow -e'
alias fdi='fd --color always -uu'

alias fzf='fzf --height 40% --layout=reverse --border'

fif() {
  local q="$1"
  [[ -z "$q" ]] && { echo "usage: fif <pattern> [path]"; return 2; }
  shift || true

  local preview_cmd
  if command -v bat >/dev/null 2>&1; then
    preview_cmd='bat --style=numbers --color=always --highlight-line {2} {1}'
  else
    preview_cmd='sed -n "$(( {2}-10 )),$(( {2}+30 ))p" {1}'
  fi

  rg --smart-case --hidden --follow \
     --color=always --line-number --no-heading \
     "$q" "${@:-.}" |
    fzf --ansi --delimiter : \
        --preview "$preview_cmd"
}

fo() {
  local file

  file=$(fd --hidden --follow . | fzf \
    --height 40% \
    --layout=reverse \
    --border \
    --prompt='Open > ') || return

  ${EDITOR:-vim} "$file"
}

cdf() {
  local dir
  dir=$(fd -H --follow -t d | fzf) && cd "$dir"
}



