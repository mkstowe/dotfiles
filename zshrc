# Persona Zsh configuration file. It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files sourced from it.
#
# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
# You can manually run `z4h update` to update everything.
zstyle ':z4h:' auto-update      'ask'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:' auto-update-days '28'

# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey' keyboard  'pc'

# Don't start tmux.
zstyle ':z4h:' start-tmux       no

# Mark up shell's output with semantic information.
zstyle ':z4h:' term-shell-integration 'yes'

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char 'accept'

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs 'no'

# Enable direnv to automatically source .envrc files.
zstyle ':z4h:direnv'         enable 'no'
# Show "loading" and "unloading" notifications from direnv.
zstyle ':z4h:direnv:success' notify 'yes'

# Enable ('yes') or disable ('no') automatic teleportation of z4h over
# SSH when connecting to these hosts.
zstyle ':z4h:ssh:example-hostname1'   enable 'yes'
zstyle ':z4h:ssh:*.example-hostname2' enable 'no'
# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*'                   enable 'no'

# Send these files over to the remote host when connecting over SSH to the
# enabled hosts.
zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' '~/.env.zsh'

# Clone additional Git repositories from GitHub.
#
# This doesn't do anything apart from cloning the repository and keeping it
# up-to-date. Cloned files can be used after `z4h init`. This is just an
# example. If you don't plan to use Oh My Zsh, delete this line.
z4h install ohmyzsh/ohmyzsh || return

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

# Extend PATH.
path=(~/bin $path)
path=(~/.local/bin $path)

# Export environment variables.
export GPG_TTY=$TTY
export PROJECT_HOME=$HOME/projects
export EDITOR=lvim

# Source additional local files if they exist.
z4h source ~/.env.zsh
z4h source ~/shell-aliases

# Use additional Git repositories pulled in with `z4h install`.
#
z4h load MikeDacre/careful_rm
z4h load Bhupesh-V/ugit
z4h load peterhurford/up.zsh
z4h load MichaelAquilina/zsh-auto-notify
z4h load hlissner/zsh-autopair
z4h load ianthehenry/zsh-autoquoter
z4h load MichaelAquilina/zsh-you-should-use
z4h load ohmyzsh/ohmyzsh/plugins/aliases
z4h load ohmyzsh/ohmyzsh/plugins/archlinux
z4h load ohmyzsh/ohmyzsh/plugins/colorize
z4h load ohmyzsh/ohmyzsh/plugins/command-not-found
z4h load ohmyzsh/ohmyzsh/plugins/cp
z4h load ohmyzsh/ohmyzsh/plugins/dirhistory
z4h load ohmyzsh/ohmyzsh/plugins/docker
z4h load ohmyzsh/ohmyzsh/plugins/docker-compose
z4h load ohmyzsh/ohmyzsh/plugins/encode64
z4h load ohmyzsh/ohmyzsh/plugins/extract
z4h load ohmyzsh/ohmyzsh/plugins/fd
z4h load ohmyzsh/ohmyzsh/plugins/ng
z4h load ohmyzsh/ohmyzsh/plugins/nvm
z4h load ohmyzsh/ohmyzsh/plugins/pip
z4h load ohmyzsh/ohmyzsh/plugins/rg
z4h load ohmyzsh/ohmyzsh/plugins/safe-paste
z4h load ohmyzsh/ohmyzsh/plugins/systemd

# Define key bindings.
z4h bindkey z4h-backward-kill-word  Ctrl+Backspace     Ctrl+H
z4h bindkey z4h-backward-kill-zword Ctrl+Alt+Backspace

z4h bindkey undo Ctrl+/ Shift+Tab  # undo the last command line change
z4h bindkey redo Alt+/             # redo the last undone command line change

z4h bindkey z4h-cd-back    Alt+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward Alt+Right  # cd into the next directory
z4h bindkey z4h-cd-up      Alt+Up     # cd into the parent directory
z4h bindkey z4h-cd-down    Alt+Down   # cd into a child directory

# Autoload functions.
autoload -Uz zmv

# Define functions and completions.
function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories md

function keep_delete() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: keep_delete item1 item2 ..."
    return 1
  fi

  local keep_set=("$@")
  local item
  local to_delete=()

  for item in *; do
    if [[ ! " ${keep_set[@]} " =~ " ${item} " ]]; then
      to_delete+=("$item")
    fi
  done

  if [[ ${#to_delete[@]} -eq 0 ]]; then
    echo "Nothing to delete."
    return 0
  fi

  echo "This will delete:"
  for item in "${to_delete[@]}"; do
    echo "  $item"
  done

  echo "Are you sure? (y/N)"
  read -r ans
  if [[ "$ans" =~ ^[Yy]$ ]]; then
    rm -rf -- "${to_delete[@]}"
    echo "Deleted."
  else
    echo "Aborted."
  fi
}

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu

eval "$(fasd --init auto)"
eval $(thefuck --alias)
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh
source <(ng completion script)
#source ~/git/careful_rm/careful_rm.alias.sh


# Following line was automatically added by arttime installer
export MANPATH=/home/mkstowe/.local/share/man:$MANPATH

PATH=~/.console-ninja/.bin:$PATH


