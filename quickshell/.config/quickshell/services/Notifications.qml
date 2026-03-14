import QtQuick
import Quickshell.Io

Item {
    id: root

    property var stateObj
    property var configObj

    readonly property int intervalMs: configObj?.pollIntervalMs ?? 400
    readonly property int historyLimit: configObj?.historyLimit ?? 100
    readonly property int popupDurationMs: configObj?.popupDurationMs ?? 4500
    readonly property int popupLimit: configObj?.popupLimit ?? 3
    readonly property bool realtimeEnabled: configObj?.realtime ?? true

    property int count: 0
    property string icon: "󰂚"
    property var history: []
    property var popups: []

    property var _knownIds: ({})
    property var _dismissedIds: ({})
    property var _recentPopupKeys: ({})
    property bool _hasPrimedHistory: false

    property bool _captureNotify: false
    property var _notifyStrings: []

    function refresh() {
        historyProc.running = false
        historyProc.running = true
    }

    function _contentKey(appName, summary, body) {
        const s = String(summary || "").trim().toLowerCase()
        const b = String(body || "").trim().toLowerCase()
        return s + "|" + b
    }

    function _markRecentPopup(key) {
        _recentPopupKeys[key] = Date.now() + 30000
    }

    function _isRecentPopup(key) {
        const expiry = Number(_recentPopupKeys[key] || 0)
        return expiry > Date.now()
    }

    function _pruneRecentPopups() {
        const now = Date.now()
        const next = {}
        const keys = Object.keys(_recentPopupKeys)
        for (let i = 0; i < keys.length; i++) {
            const key = keys[i]
            const expiry = Number(_recentPopupKeys[key] || 0)
            if (expiry > now)
                next[key] = expiry
        }
        _recentPopupKeys = next
    }

    function _pushPopup(item) {
        const key = _contentKey(item.app, item.summary, item.body)
        if (_isRecentPopup(key))
            return

        _markRecentPopup(key)

        const popup = {
            id: item.id,
            app: item.app || "Notification",
            summary: item.summary || "",
            body: item.body || "",
            timestamp: item.timestamp || 0,
            expiresAt: Date.now() + popupDurationMs
        }

        const merged = [popup].concat(popups)
        popups = merged.slice(0, Math.max(1, popupLimit))
    }

    function _handleRealtimeLine(line) {
        if (!realtimeEnabled)
            return

        const t = (line || "").trim()
        if (!t)
            return

        if (t.includes("member=Notify")) {
            _captureNotify = true
            _notifyStrings = []
            return
        }

        if (!_captureNotify)
            return

        const match = t.match(/^string\s+"(.*)"$/)
        if (!match)
            return

        _notifyStrings.push(match[1])

        // org.freedesktop.Notifications.Notify args include strings at:
        // [0]=app_name, [1]=icon, [2]=summary, [3]=body
        if (_notifyStrings.length >= 4) {
            _captureNotify = false

            const appName = _notifyStrings[0] || "Notification"
            const summary = _notifyStrings[2] || ""
            const body = _notifyStrings[3] || ""
            const now = Date.now()
            const fallbackId = "rt|" + _contentKey(appName, summary, body) + "|" + now

            _pushPopup({
                id: fallbackId,
                app: appName,
                summary: summary,
                body: body,
                timestamp: Math.floor(now / 1000)
            })
        }
    }

    function _markDismissed(notifId) {
        const key = String(notifId)
        _dismissedIds[key] = true
    }

    function _backendRemoveOne(notifId) {
        const key = String(notifId)
        removeOneProc.command = [
            "bash",
            "-lc",
            "dunstctl history-rm '" + key + "' 2>/dev/null || dunstctl history rm '" + key + "' 2>/dev/null || true"
        ]
        removeOneProc.running = false
        removeOneProc.running = true
    }

    function _backendClearAll() {
        clearProc.command = [
            "bash",
            "-lc",
            "dunstctl history-clear 2>/dev/null || dunstctl history clear 2>/dev/null || dunstctl history-rm all 2>/dev/null || true"
        ]
        clearProc.running = false
        clearProc.running = true
    }

    function dismissPopup(notifId) {
        const remaining = []
        for (let i = 0; i < popups.length; i++) {
            if (popups[i].id !== notifId)
                remaining.push(popups[i])
        }
        popups = remaining
    }

    function dismissHistory(notifId) {
        _markDismissed(notifId)
        _backendRemoveOne(notifId)

        const remaining = []
        for (let i = 0; i < history.length; i++) {
            if (history[i].id !== notifId)
                remaining.push(history[i])
        }
        history = remaining
        count = history.length
        dismissPopup(notifId)
    }

    function clearHistory() {
        for (let i = 0; i < history.length; i++)
            _markDismissed(history[i].id)

        _backendClearAll()

        history = []
        popups = []
        count = 0
        _knownIds = {}
        _hasPrimedHistory = true
    }

    function _applyHistory(notifications) {
        const normalized = Array.isArray(notifications) ? notifications : []
        const filtered = []

        for (let i = 0; i < normalized.length; i++) {
            const item = normalized[i]
            const key = String(item.id)
            if (!_dismissedIds[key])
                filtered.push(item)
        }

        const trimmed = filtered.slice(0, Math.max(1, historyLimit))

        const known = {}

        for (let i = 0; i < trimmed.length; i++) {
            const item = trimmed[i]
            const key = String(item.id)
            known[key] = true

            if (_knownIds[key])
                continue

            if (!realtimeEnabled) {
                _pushPopup({
                    id: item.id,
                    app: item.app || "Notification",
                    summary: item.summary || "",
                    body: item.body || "",
                    timestamp: item.timestamp || 0
                })
            }
        }

        history = trimmed
        count = history.length

        if (!_hasPrimedHistory) {
            _knownIds = known
            _hasPrimedHistory = true
            return
        }

        _knownIds = known
    }

    Process {
        id: historyProc
        command: ["python3", stateObj?.paths?.fromRoot("scripts/notifications_dump.py") ?? "scripts/notifications_dump.py"]

        stdout: StdioCollector {
            onStreamFinished: {
                let parsed = []
                try {
                    parsed = JSON.parse(text || "[]")
                } catch (_) {
                    parsed = []
                }

                root._applyHistory(parsed)
            }
        }
    }

    Process {
        id: streamProc
        running: root.realtimeEnabled
        command: ["bash", "-lc", "dbus-monitor \"interface='org.freedesktop.Notifications',member='Notify'\" 2>/dev/null"]

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: function(data) {
                root._handleRealtimeLine(data)
            }
        }
    }

    Process {
        id: removeOneProc
    }

    Process {
        id: clearProc
    }

    Timer {
        interval: root.intervalMs
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }

    Timer {
        interval: 300
        running: true
        repeat: true
        onTriggered: {
            if (!Array.isArray(root.popups) || root.popups.length === 0)
                return

            const now = Date.now()
            const active = []
            for (let i = 0; i < root.popups.length; i++) {
                if ((root.popups[i].expiresAt || 0) > now)
                    active.push(root.popups[i])
            }

            if (active.length !== root.popups.length)
                root.popups = active

            root._pruneRecentPopups()
        }
    }
}
