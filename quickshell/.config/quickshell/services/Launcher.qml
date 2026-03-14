import QtQuick
import Quickshell.Io

Item {
    id: root

    property var stateObj
    property var configObj

    readonly property int maxResults: configObj?.maxResults ?? 14

    property string query: ""
    property var allApps: []
    property var filteredApps: []
    property int selectedIndex: 0

    function refreshApps() {
        appQuery.running = false
        appQuery.running = true
    }

    function setQuery(value) {
        query = value || ""
        applyFilter()
    }

    function applyFilter() {
        const needle = query.toLowerCase().trim()
        const matches = []

        for (let i = 0; i < allApps.length; i++) {
            const app = allApps[i]
            if (!needle) {
                matches.push(app)
                continue
            }

            const name = (app.name || "").toLowerCase()
            const comment = (app.comment || "").toLowerCase()
            const execValue = (app.exec || "").toLowerCase()

            if (name.includes(needle) || comment.includes(needle) || execValue.includes(needle))
                matches.push(app)
        }

        filteredApps = matches.slice(0, Math.max(1, maxResults))

        if (filteredApps.length === 0)
            selectedIndex = -1
        else if (selectedIndex < 0)
            selectedIndex = 0
        else if (selectedIndex >= filteredApps.length)
            selectedIndex = filteredApps.length - 1
    }

    function selectNext(step) {
        if (filteredApps.length === 0)
            return

        selectedIndex = (selectedIndex + step + filteredApps.length) % filteredApps.length
    }

    function launchApp(index) {
        if (index < 0 || index >= filteredApps.length)
            return false

        const app = filteredApps[index]
        const cmd = (app.exec || "").trim()
        if (!cmd)
            return false

        launchProc.command = ["bash", "-lc", cmd + " >/dev/null 2>&1 & disown"]
        launchProc.running = false
        launchProc.running = true
        return true
    }

    function reset() {
        selectedIndex = 0
        setQuery("")
    }

    Process {
        id: appQuery
        command: ["python3", stateObj?.paths?.fromRoot("scripts/launcher_apps.py") ?? "scripts/launcher_apps.py"]

        stdout: StdioCollector {
            onStreamFinished: {
                let parsed = []
                try {
                    parsed = JSON.parse(text || "[]")
                } catch (_) {
                    parsed = []
                }

                root.allApps = parsed
                root.applyFilter()
            }
        }
    }

    Process {
        id: launchProc
    }
}
