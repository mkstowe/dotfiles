#!/usr/bin/env bash
set -u

CONFIG_PATHS=(
  "$HOME/.config"
  "$HOME/.local/bin"
  "$HOME/.local/share/applications"
  "$HOME/.zshrc"
  "$HOME/.bashrc"
  "$HOME/.profile"
  "$HOME/.xinitrc"
  "$HOME/.xprofile"
)

need() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required command: $1"
    exit 1
  }
}

need pacman
need rg
need awk
need sort
need timeout

existing_paths=()
for path in "${CONFIG_PATHS[@]}"; do
  [[ -e "$path" ]] && existing_paths+=("$path")
done

mapfile -t packages < <(
  {
    pacman -Qqe
    pacman -Qqm
  } | sort -u
)

unused_candidates=()
orphan_candidates=()

echo "Auditing ${#packages[@]} explicitly installed packages..."
echo

for pkg in "${packages[@]}"; do
  pacman -Q "$pkg" >/dev/null 2>&1 || continue

  echo "================================================================"
  echo "PACKAGE: $pkg"
  echo "================================================================"

  used=0

  mapfile -t bins < <(
    pacman -Ql "$pkg" 2>/dev/null |
      awk '/\/usr\/bin\// {
        sub(".*/", "", $2)
        print $2
      }' |
      sort -u
  )

  echo
  echo "[Executables]"
  if ((${#bins[@]} == 0)); then
    echo "No executables."
  else
    printf '%s\n' "${bins[@]}"
  fi

  echo
  echo "[Config references]"

  found_refs=0

  for bin in "${bins[@]}"; do
    matches="$(
      timeout 5s rg -n -w \
        --hidden \
        --glob '!.git/**' \
        --glob '!node_modules/**' \
        --glob '!cache/**' \
        --glob '!Cache/**' \
        --glob '!Trash/**' \
        "$bin" \
        "${existing_paths[@]}" \
        2>/dev/null || true
    )"

    if [[ -n "$matches" ]]; then
      found_refs=1
      used=1
      echo
      echo "--- binary: $bin ---"
      echo "$matches"
    fi
  done

  pkg_matches="$(
    timeout 5s rg -n -w \
      --hidden \
      --glob '!.git/**' \
      --glob '!node_modules/**' \
      --glob '!cache/**' \
      --glob '!Cache/**' \
      --glob '!Trash/**' \
      "$pkg" \
      "${existing_paths[@]}" \
      2>/dev/null || true
  )"

  if [[ -n "$pkg_matches" ]]; then
    found_refs=1
    used=1
    echo
    echo "--- package: $pkg ---"
    echo "$pkg_matches"
  fi

  if ((found_refs == 0)); then
    echo "No obvious references found."
  fi

  echo
  echo "[Systemd user services]"

  service_found=0
  for term in "$pkg" "${bins[@]}"; do
    [[ -z "$term" ]] && continue

    svc_matches="$(
      systemctl --user list-unit-files --no-pager 2>/dev/null |
        rg -i -w "$term" || true
    )"

    if [[ -n "$svc_matches" ]]; then
      service_found=1
      used=1
      echo
      echo "--- $term ---"
      echo "$svc_matches"
    fi
  done

  if ((service_found == 0)); then
    echo "No matching user services."
  fi

  echo
  echo "[System services]"

  sys_service_found=0
  for term in "$pkg" "${bins[@]}"; do
    [[ -z "$term" ]] && continue

    sys_svc_matches="$(
      systemctl list-unit-files --no-pager 2>/dev/null |
        rg -i -w "$term" || true
    )"

    if [[ -n "$sys_svc_matches" ]]; then
      sys_service_found=1
      used=1
      echo
      echo "--- $term ---"
      echo "$sys_svc_matches"
    fi
  done

  if ((sys_service_found == 0)); then
    echo "No matching system services."
  fi

  echo
  echo "[Reverse dependencies]"

  has_revdeps=0
  if command -v pactree >/dev/null 2>&1; then
    revdeps="$(pactree -r "$pkg" 2>/dev/null | sed '1d' || true)"

    if [[ -n "$revdeps" ]]; then
      has_revdeps=1
      used=1
      echo "$revdeps"
    else
      echo "None."
    fi
  else
    echo "Skipped; install pacman-contrib for pactree."
  fi

  if ((used == 0)); then
    unused_candidates+=("$pkg")
  fi

  echo
done

mapfile -t orphan_candidates < <(pacman -Qdtq 2>/dev/null | sort -u || true)

echo
echo "================================================================"
echo "FINAL SUMMARY"
echo "================================================================"

echo
echo "[Packages with no obvious evidence of use]"
if ((${#unused_candidates[@]} == 0)); then
  echo "None found."
else
  printf '%s\n' "${unused_candidates[@]}"
fi

echo
echo "[Orphaned dependencies]"
if ((${#orphan_candidates[@]} == 0)); then
  echo "None found."
else
  printf '%s\n' "${orphan_candidates[@]}"
fi

echo
echo "[Suggested manual review command]"
echo "For each candidate, dry-run with:"
echo "  sudo pacman -Rns package-name"
