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
export ZVM_SYSTEM_CLIPBOARD_ENABLED=true
export PATH="/usr/lib/qt6/bin:$PATH"

[ -f ~/.config/secrets.env ] && source ~/.config/secrets.env

# -------------------------
# Shell options / behavior
# -------------------------

bindkey -v
# Fix Delete key in vi insert mode
bindkey -M viins '^[[3~' delete-char

setopt glob_dots

# -------------------------
# External tool integrations
# -------------------------

# fasd (only if installed)
(( $+commands[fasd] )) && eval "$(fasd --init auto)"

# thefuck (only if installed)
(( $+commands[thefuck] )) && eval "$(thefuck --alias)"


# fnm
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
fi

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

eval "$(fnm env --use-on-cd --shell zsh --version-file-strategy recursive)"

# Created by `pipx` on 2026-06-18 21:06:47
export PATH="$PATH:/home/mkstowe/.local/bin"


# Load Angular CLI autocompletion.
source <(ng completion script)
