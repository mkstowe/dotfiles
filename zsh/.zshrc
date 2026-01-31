# -------------------------
# Interactive shell settings
# -------------------------

# History: remove older command if a duplicate is added
setopt HIST_IGNORE_ALL_DUPS

# Remove path separator from WORDCHARS (better word motions)
WORDCHARS=${WORDCHARS//[\/]}

# ---------------------------
# Zim + module configuration
# ---------------------------

# zsh-autosuggestions: don't rebind widgets every precmd (faster)
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# zsh-syntax-highlighting: choose highlighters
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# -------------------------
# Initialize Zim Framework
# -------------------------

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi

# Install missing modules and (re)generate init.zsh if needed.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init
fi

# Load modules.
source ${ZIM_HOME}/init.zsh

# ----------------
# User environment
# ----------------

# Keep personal customizations in zshrc (zimrc is for modules)
for dir in aliases functions; do
  d="$HOME/.config/zsh/$dir"
  [[ -d $d ]] || continue
  for file in "$d"/*.zsh(N-.); do
    source "$file"
  done
done
unset dir file d

[[ -r ~/.p10k.zsh ]] && source ~/.p10k.zsh

# export GPG_TTY="$TTY"
export PROJECT_HOME="$HOME/projects"
export EDITOR="nvim"

# -------------------------
# Shell options / behavior
# -------------------------

bindkey -v
setopt glob_dots
setopt no_auto_menu

# -------------------------
# Functions & completions
# -------------------------

md() {
  [[ $# == 1 ]] || return 1
  mkdir -p -- "$1" && cd -- "$1"
}
# Needs completion initialized (provided by Zim completion module)
(( $+functions[compdef] )) && compdef _directories md

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

# -------------------------
# External tool integrations
# -------------------------

# fasd (only if installed)
(( $+commands[fasd] )) && eval "$(fasd --init auto)"

# thefuck (only if installed)
(( $+commands[thefuck] )) && eval "$(thefuck --alias)"

