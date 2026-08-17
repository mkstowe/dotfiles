import QtQuick
import Quickshell.Io

Item {
    id: root

    property int pollInterval: 5000
    property string upCommand: "tailscale up"
    property string downCommand: "tailscale down"

    readonly property bool available: _available
    readonly property bool connected: _connected
    readonly property bool busy: statusProcess.running || toggleProcess.running
    readonly property string backendState: _backendState
    readonly property string status: {
        if (!root.available)
            return "UNAVAILABLE";
        if (root.connected)
            return "CONNECTED";
        if (root.backendState.length > 0)
            return root.backendState.toUpperCase();
        return "DISCONNECTED";
    }
    readonly property string icon: root.connected ? "󰖂" : "󰖪"

    property bool _available: false
    property bool _connected: false
    property string _backendState: ""

    function refresh() {
        statusProcess.running = false;
        statusProcess.running = true;
    }

    function toggle() {
        toggleProcess.running = false;
        toggleProcess.command = ["bash", "-lc", root.connected ? root.downCommand : root.upCommand];
        toggleProcess.running = true;
    }

    function _applyStatus(text) {
        const raw = (text || "").trim();

        if (raw === "UNAVAILABLE" || raw.length === 0) {
            root._available = false;
            root._connected = false;
            root._backendState = "";
            return;
        }

        try {
            const parsed = JSON.parse(raw);
            const state = parsed?.BackendState ?? "";

            root._available = true;
            root._backendState = state;
            root._connected = state === "Running";
        } catch (e) {
            root._available = false;
            root._connected = false;
            root._backendState = "";
        }
    }

    Component.onCompleted: refresh()

    Timer {
        interval: root.pollInterval
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    Process {
        id: statusProcess
        command: ["bash", "-lc", "command -v tailscale >/dev/null 2>&1 || { printf UNAVAILABLE; exit 0; }; tailscale status --json 2>/dev/null"]

        stdout: StdioCollector {
            onStreamFinished: root._applyStatus(text)
        }
    }

    Process {
        id: toggleProcess

        stdout: StdioCollector {
            onStreamFinished: root.refresh()
        }

        stderr: StdioCollector {
            onStreamFinished: root.refresh()
        }
    }
}
