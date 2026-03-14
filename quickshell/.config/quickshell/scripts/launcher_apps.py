#!/usr/bin/env python3

import configparser
import json
from pathlib import Path

APP_DIRS = [
    Path.home() / ".local/share/applications",
    Path("/usr/local/share/applications"),
    Path("/usr/share/applications"),
    Path("/var/lib/flatpak/exports/share/applications"),
    Path.home() / ".local/share/flatpak/exports/share/applications",
]


def _sanitize_exec(exec_line: str) -> str:
    value = (exec_line or "").strip()
    if not value:
        return ""

    for token in ["%f", "%F", "%u", "%U", "%i", "%c", "%k", "%d", "%D", "%n", "%N", "%v", "%m"]:
        value = value.replace(token, "")

    return " ".join(value.split()).strip()


def _iter_desktop_files():
    seen = set()
    for directory in APP_DIRS:
        if not directory.is_dir():
            continue

        for path in sorted(directory.glob("*.desktop")):
            try:
                resolved = str(path.resolve())
            except OSError:
                resolved = str(path)

            if resolved in seen:
                continue
            seen.add(resolved)
            yield path


def _read_entry(path: Path):
    parser = configparser.ConfigParser(interpolation=None, strict=False)
    parser.optionxform = str

    try:
        parser.read(path, encoding="utf-8")
    except Exception:
        return None

    if "Desktop Entry" not in parser:
        return None

    entry = parser["Desktop Entry"]
    app_type = entry.get("Type", "").strip()
    if app_type and app_type != "Application":
        return None

    if entry.get("NoDisplay", "false").lower() == "true":
        return None

    if entry.get("Hidden", "false").lower() == "true":
        return None

    name = entry.get("Name", "").strip()
    exec_line = _sanitize_exec(entry.get("Exec", ""))

    if not name or not exec_line:
        return None

    return {
        "name": name,
        "exec": exec_line,
        "icon": entry.get("Icon", "").strip(),
        "comment": entry.get("Comment", "").strip(),
        "desktopId": path.name,
    }


def main():
    by_id = {}

    for file_path in _iter_desktop_files():
        entry = _read_entry(file_path)
        if not entry:
            continue
        by_id[entry["desktopId"]] = entry

    entries = sorted(by_id.values(), key=lambda item: item["name"].lower())
    print(json.dumps(entries, ensure_ascii=False))


if __name__ == "__main__":
    main()
