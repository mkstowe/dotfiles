import QtQuick
import Quickshell.Io

Item {
    id: root

    property int step: 5

    readonly property real value: _value
    readonly property int percent: Math.round(_value * 100)
    readonly property bool muted: _muted
    readonly property string icon: {
        if (root.muted)
            return "󰝟";
        if (root.percent <= 0)
            return "󰕿";
        if (root.percent < 35)
            return "󰖀";
        if (root.percent < 70)
            return "󰕾";
        return "󰕾";
    }

    property real _value: 0
    property bool _muted: false

    function refresh() {
        queryProcess.running = false;
        queryProcess.running = true;
    }

    function toggleMute() {
        muteProcess.running = false;
        muteProcess.running = true;
    }

    function increase() {
        volUpProcess.running = false;
        volUpProcess.running = true;
    }

    function decrease() {
        volDownProcess.running = false;
        volDownProcess.running = true;
    }

    function _applyVolumeOutput(text) {
        const raw = (text || "").trim();

        // Expected wpctl output example:
        // Volume: 0.42
        // Volume: 0.42 [MUTED]
        const match = raw.match(/Volume:\s*([0-9.]+)/i);
        if (match)
            root._value = Math.max(0, Math.min(1.5, Number(match[1])));

        root._muted = /\[MUTED\]/i.test(raw);
    }

    Component.onCompleted: refresh()

    Timer {
        id: pollTimer
        interval: 2000
        repeat: true
        running: true
        triggeredOnStart: false
        onTriggered: root.refresh()
    }

    Process {
        id: queryProcess
        command: ["bash", "-lc", "wpctl get-volume @DEFAULT_AUDIO_SINK@"]

        stdout: StdioCollector {
            onStreamFinished: function() {
                root._applyVolumeOutput(text);
            }
        }
    }

    Process {
        id: muteProcess
        command: ["bash", "-lc", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && wpctl get-volume @DEFAULT_AUDIO_SINK@"]

        stdout: StdioCollector {
            onStreamFinished: function() {
                root._applyVolumeOutput(text);
            }
        }
    }

    Process {
        id: volUpProcess
        command: ["bash", "-lc", "wpctl set-volume @DEFAULT_AUDIO_SINK@ " + root.step + "%+ && wpctl get-volume @DEFAULT_AUDIO_SINK@"]

        stdout: StdioCollector {
            onStreamFinished: function() {
                root._applyVolumeOutput(text);
            }
        }
    }

    Process {
        id: volDownProcess
        command: ["bash", "-lc", "wpctl set-volume @DEFAULT_AUDIO_SINK@ " + root.step + "%- && wpctl get-volume @DEFAULT_AUDIO_SINK@"]

        stdout: StdioCollector {
            onStreamFinished: function() {
                root._applyVolumeOutput(text);
            }
        }
    }
}