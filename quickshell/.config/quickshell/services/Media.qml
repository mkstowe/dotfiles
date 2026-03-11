import QtQuick
import Quickshell
import Quickshell.Io

import "../core" as Core

Item {
    id: root

    property string selectedPlayer: ""

    property bool hasPlayer: false
    property bool isPlaying: false
    property string playerName: ""
    property string artist: ""
    property string title: ""
    property string displayText: "-"

    readonly property bool canControl: hasPlayer

    Core.Log {
        id: log
    }

    function resetState() {
        hasPlayer = false;
        isPlaying = false;
        playerName = "";
        artist = "";
        title = "";
        displayText = "-";
    }

    function applyJsonText(text) {
        const trimmed = (text || "").trim();

        if (!trimmed.length)
            return;
        try {
            const data = JSON.parse(trimmed);
            hasPlayer = !!data.hasPlayer;
            isPlaying = !!data.isPlaying;
            playerName = data.playerName || "";
            artist = data.artist || "";
            title = data.title || "";
            displayText = data.text && data.text.length ? data.text : "-";
        } catch (err) {
            log.warn("Media JSON parse failed:", trimmed);
        }
    }

    function refreshStatusOnly() {
        statusProc.running = false;
        statusProc.running = true;
    }

    Process {
        id: listener

        command: {
            const base = ["python3", Quickshell.shellDir + "/scripts/media_listener.py"];

            if (root.selectedPlayer && root.selectedPlayer.length > 0) {
                base.push("--player");
                base.push(root.selectedPlayer);
            }

            return base;
        }

        running: true

        onRunningChanged: {
            if (!running)
                running = true;
        }

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: function (data) {
                root.applyJsonText(data);
            }
        }

        stderr: SplitParser {
            splitMarker: "\n"
            onRead: function (data) {
                log.warn("media_listener stderr:", data);
            }
        }
    }

    Process {
        id: statusProc
        command: ["bash", "-lc", "playerctl status 2>/dev/null | tr -d '\\n'"]

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: function (data) {
                const status = (data || "").trim();

                if (status === "Playing")
                    root.isPlaying = true;
                else if (status === "Paused" || status === "Stopped")
                    root.isPlaying = false;
            }
        }

        stderr: SplitParser {
            splitMarker: "\n"
            onRead: function (data) {
                log.warn("media status stderr:", data);
            }
        }
    }

    Process {
        id: previousProc
        command: ["playerctl", "previous"]
    }

    Process {
        id: toggleProc
        command: ["playerctl", "play-pause"]
    }

    Process {
        id: nextProc
        command: ["playerctl", "next"]
    }

    Timer {
        id: refreshTimer
        interval: 150
        repeat: false
        onTriggered: root.refreshStatusOnly()
    }

    function previous() {
        previousProc.running = false;
        previousProc.running = true;
        refreshTimer.restart();
    }

    function toggle() {
        if (hasPlayer)
            isPlaying = !isPlaying;

        toggleProc.running = false;
        toggleProc.running = true;
        refreshTimer.restart();
    }

    function next() {
        nextProc.running = false;
        nextProc.running = true;
        refreshTimer.restart();
    }
}
