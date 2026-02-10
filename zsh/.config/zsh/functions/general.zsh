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

keep_delete() {
  setopt local_options null_glob

  if [[ $# -eq 0 ]]; then
    echo "Usage: keep_delete item1 item2 ..."
    return 1
  fi

  local -a keep_set to_delete
  keep_set=("$@")

  local item
  for item in *; do
    # robust exact-match check
    if (( ${keep_set[(I)$item]} == 0 )); then
      to_delete+=("$item")
    fi
  done

  if (( ${#to_delete[@]} == 0 )); then
    echo "Nothing to delete."
    return 0
  fi

  print -r -- "This will delete:"
  print -r -- "  ${to_delete[@]}"
  printf "Are you sure? (y/N) "
  read -r ans

  if [[ $ans == [Yy] ]]; then
    rm -rf -- "${to_delete[@]}"
    echo "Deleted."
  else
    echo "Aborted."
  fi
}

md() {
  [[ $# == 1 ]] || return 1
  mkdir -p -- "$1" && cd -- "$1"
}
# Needs completion initialized (provided by Zim completion module)
(( $+functions[compdef] )) && compdef _directories md

touch() {
  # Loop through all arguments
  for arg in "$@"; do
    # Extract the directory part of the path
    local dir_path=$(dirname "$arg")

    # Create the directory if it doesn't exist
    if [ ! -d "$dir_path" ]; then
      mkdir -p "$dir_path"
    fi

    # Use the original 'touch' command to create the file
    command touch "$arg"
  done
}
