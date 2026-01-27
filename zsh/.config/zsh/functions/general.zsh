function up() {
  local n=${1:-1}

  # validate args
  if (( $# > 1 )) || ! [[ $n =~ ^[0-9]+$ ]] || (( n < 1 )); then
    print -r -- "Usage: up [N]   (N must be a positive integer)"
    return 1
  fi

  local target=".."
  local i
  for (( i=2; i<=n; i++ )); do
    target+="/.."
  done

  builtin cd -- "$target"
}

[[ -e /etc/zsh_command_not_found ]] && source /etc/zsh_command_not_found
[[ -e /usr/share/doc/pkgfile/command-not-found.zsh ]] && source /usr/share/doc/pkgfile/command-not-found.zsh
