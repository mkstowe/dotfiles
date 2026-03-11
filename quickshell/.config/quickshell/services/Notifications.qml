import QtQuick
import Quickshell.Io

Item {
    id: root

    property int intervalMs: 2000

    property int count: 0
    property string icon: "󰂚"

    function update(text) {
        const parsed = parseInt((text || "").trim())

        if (!isNaN(parsed))
            count = parsed
    }

    function refresh() {
        notificationsProc.running = false
        notificationsProc.running = true
    }

    Process {
        id: notificationsProc

        command: [
            "bash",
            "-lc",
            "dunstctl count waiting 2>/dev/null || echo 0"
        ]

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: function(data) {
                root.update(data)
            }
        }
    }

    Timer {
        interval: root.intervalMs
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }
}