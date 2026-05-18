import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    property var configObj

    readonly property var commands: configObj?.commands ?? {}
    readonly property string saveDirectory: (configObj?.saveDirectory ?? "~/Pictures/screenshots").trim()
    readonly property string filePrefix: (configObj?.filePrefix ?? "screenshot").trim()
    readonly property string helperScript: Quickshell.shellDir + "/scripts/screenshot_capture.sh"

    readonly property var actions: [
        {
            id: "area",
            icon: "󰹑",
            target: "area",
            command: commands.area ?? ""
        },
        {
            id: "window",
            icon: "󱂬",
            target: "active",
            command: commands.window ?? ""
        },
        {
            id: "screen",
            icon: "󰍹",
            target: "output",
            command: commands.screen ?? ""
        },
        {
            id: "allScreens",
            icon: "󰍺",
            target: "screen",
            command: commands.allScreens ?? ""
        }
    ]

    function runAction(actionId) {
        for (let i = 0; i < actions.length; i++) {
            const action = actions[i]
            if (action.id !== actionId)
                continue

            const cmd = (action.command || "").trim()
            if (cmd) {
                actionProc.command = ["bash", "-lc", cmd]
            } else {
                actionProc.command = [helperScript, action.target, saveDirectory || "~/Pictures/screenshots", filePrefix || "screenshot"]
            }

            actionProc.running = false
            actionProc.running = true
            return true
        }

        return false
    }

    Process {
        id: actionProc
    }
}
