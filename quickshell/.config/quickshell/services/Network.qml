import QtQuick
import Quickshell.Io

Item {
    id: root

    readonly property string transport: _transport
    readonly property bool connected: _connected
    readonly property bool hasInternet: _hasInternet

    readonly property string status: {
        if (!root.connected || !root.hasInternet)
            return "OFFLINE";

        if (root.transport === "ethernet")
            return "ETHERNET";

        if (root.transport === "wifi")
            return "WIFI";

        return "ONLINE";
    }

    readonly property string icon: {
        if (!root.connected || !root.hasInternet)
            return "󰖪"; // nf-md-wifi_strength_off_outline

        if (root.transport === "ethernet")
            return "󰈀"; // nf-md-ethernet

        if (root.transport === "wifi")
            return "󰖩"; // nf-md-wifi

        return "󰌘"; // nf-md-lan_connect
    }

    property string _transport: "offline"
    property bool _connected: false
    property bool _hasInternet: false

    function refresh() {
        statusProcess.running = false;
        statusProcess.running = true;
    }

    function _parseOutput(text) {
        const raw = (text || "").trim();
        const lines = raw.length > 0 ? raw.split("\n") : [];

        let connectivity = "none";
        let transport = "offline";
        let connected = false;

        for (let i = 0; i < lines.length; i++) {
            const line = lines[i].trim();

            if (line.startsWith("CONNECTIVITY:")) {
                connectivity = line.slice("CONNECTIVITY:".length).trim();
                continue;
            }

            if (line.startsWith("DEVICE:")) {
                const parts = line.split(":");
                if (parts.length >= 4) {
                    const type = parts[2].trim();
                    const state = parts[3].trim();

                    if (state === "connected") {
                        connected = true;

                        if (type === "ethernet") {
                            transport = "ethernet";
                            break;
                        }

                        if (type === "wifi") {
                            transport = "wifi";
                        }
                    }
                }
            }
        }

        root._connected = connected;
        root._transport = transport;
        root._hasInternet = connected && connectivity === "full";
    }

    Component.onCompleted: refresh()

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    Process {
        id: statusProcess
        command: [
            "bash",
            "-lc",
            "printf 'CONNECTIVITY:'; nmcli -t -f CONNECTIVITY general | head -n1; " +
            "printf 'DEVICE:'; nmcli -t -f DEVICE,TYPE,STATE device status | sed -n '1p'; " +
            "nmcli -t -f DEVICE,TYPE,STATE device status | sed 's/^/DEVICE:/g'"
        ]

        stdout: StdioCollector {
            onStreamFinished: root._parseOutput(text)
        }
    }
}