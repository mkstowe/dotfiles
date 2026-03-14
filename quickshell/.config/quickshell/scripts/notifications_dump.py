#!/usr/bin/env python3

import json
import subprocess
import time


def _run(cmd):
    try:
        completed = subprocess.run(cmd, capture_output=True, text=True, timeout=2)
        if completed.returncode != 0:
            return ""
        return completed.stdout.strip()
    except Exception:
        return ""


def _unwrap(value):
    if isinstance(value, dict):
        # dunstctl / dbus JSON often wraps values as {"data": ...}
        if "data" in value and len(value) <= 2:
            return _unwrap(value.get("data"))
        return {k: _unwrap(v) for k, v in value.items()}

    if isinstance(value, list):
        return [_unwrap(v) for v in value]

    return value


def _stable_fallback_id(item):
    app = str(item.get("appname") or item.get("app") or item.get("desktop_entry") or "")
    summary = str(item.get("summary") or item.get("title") or item.get("body") or "")
    body = str(item.get("body") or item.get("message") or "")
    ts = str(item.get("timestamp") or item.get("time") or "")
    return f"{app}|{summary}|{body}|{ts}"


def _is_notification_like(item):
    if not isinstance(item, dict):
        return False

    keys = set(item.keys())
    return bool(keys & {"id", "msg_id", "notification_id", "summary", "body", "appname", "app", "desktop_entry", "title"})


def _iter_notification_dicts(value):
    if isinstance(value, dict):
        if _is_notification_like(value):
            yield value

        for child in value.values():
            yield from _iter_notification_dicts(child)

    elif isinstance(value, list):
        for child in value:
            yield from _iter_notification_dicts(child)


def _normalize(item):
    if not isinstance(item, dict):
        return None

    notif_id = item.get("id") or item.get("msg_id") or item.get("notification_id")
    if notif_id is None:
        notif_id = _stable_fallback_id(item)

    summary = item.get("summary") or item.get("title") or item.get("body", "")
    body = item.get("body") or item.get("message") or ""
    app = item.get("appname") or item.get("app") or item.get("desktop_entry") or "Notification"
    ts = item.get("timestamp") or item.get("time") or int(time.time())

    return {
        "id": int(notif_id) if str(notif_id).isdigit() else str(notif_id),
        "app": str(app),
        "summary": str(summary),
        "body": str(body),
        "timestamp": int(ts) if str(ts).isdigit() else int(time.time()),
    }


def _try_parse_json(raw):
    if not raw:
        return None

    try:
        return json.loads(raw)
    except Exception:
        pass

    starts = [i for i in [raw.find("{"), raw.find("[")] if i >= 0]
    if not starts:
        return None

    start = min(starts)
    for end_char in ["]", "}"]:
        end = raw.rfind(end_char)
        if end <= start:
            continue

        candidate = raw[start:end + 1]
        try:
            return json.loads(candidate)
        except Exception:
            continue

    return None


def _from_json_output(raw):
    parsed = _try_parse_json(raw)
    if parsed is None:
        return []

    unwrapped = _unwrap(parsed)

    items = []
    seen = set()

    for item in _iter_notification_dicts(unwrapped):
        normalized = _normalize(item)
        if not normalized:
            continue

        key = str(normalized.get("id"))
        if key in seen:
            continue

        seen.add(key)
        items.append(normalized)

    return items


def main():
    for cmd in [
        ["dunstctl", "history", "--json"],
        ["dunstctl", "history", "json"],
        ["dunstctl", "history"],
    ]:
        out = _run(cmd)
        if not out:
            continue

        items = _from_json_output(out)
        if items:
            items.sort(key=lambda x: x.get("timestamp", 0), reverse=True)
            print(json.dumps(items, ensure_ascii=False))
            return

    print("[]")


if __name__ == "__main__":
    main()
