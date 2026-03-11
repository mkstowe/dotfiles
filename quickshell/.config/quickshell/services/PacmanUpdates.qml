import QtQuick
import Quickshell.Io

Item {
    id: root

    property int pollInterval: 1800000 // 30 min
    property bool showAur: false
    property string aurHelper: "paru"

    readonly property int pacmanCount: _pacmanCount
    readonly property int aurCount: _aurCount
    readonly property int totalCount: _pacmanCount + (root.showAur ? _aurCount : 0)
    readonly property bool hasUpdates: totalCount > 0
    readonly property string icon: "󰏔"

    property int _pacmanCount: 0
    property int _aurCount: 0

    function refresh() {
        queryProcess.running = false;
        queryProcess.running = true;
    }

    function _safeParseCount(value) {
        const parsed = Number((value || "").trim());
        if (isNaN(parsed) || parsed < 0)
            return 0;
        return parsed;
    }

    function _aurCommand() {
        switch (root.aurHelper) {
        case "paru":
            return "paru -Qua 2>/dev/null | wc -l";
        case "yay":
            return "yay -Qua 2>/dev/null | wc -l";
        default:
            return "echo 0";
        }
    }

    function _applyOutput(text) {
        const raw = (text || "").trim();
        const lines = raw.length > 0 ? raw.split("\n") : [];

        let pacman = 0;
        let aur = 0;

        for (let i = 0; i < lines.length; i++) {
            const line = lines[i].trim();

            if (line.startsWith("PACMAN:"))
                pacman = root._safeParseCount(line.slice("PACMAN:".length));
            else if (line.startsWith("AUR:"))
                aur = root._safeParseCount(line.slice("AUR:".length));
        }

        root._pacmanCount = pacman;
        root._aurCount = aur;
    }

    Component.onCompleted: refresh()

    Timer {
        interval: root.pollInterval
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    Process {
        id: queryProcess

        command: ["bash", "-lc", "printf 'PACMAN:'; (checkupdates 2>/dev/null | wc -l); " + (root.showAur ? ("printf 'AUR:'; (" + root._aurCommand() + "); ") : "printf 'AUR:0\n'; ")]

        stdout: StdioCollector {
            onStreamFinished: root._applyOutput(text)
        }
    }
}
