import QtQuick
import Quickshell.Io

Item {
    id: root

    property var configObj

    readonly property var commands: configObj?.commands ?? {}

    readonly property var actions: [
        {
            id: "poweroff",
            icon: "⏻",
            command: commands.poweroff ?? "systemctl poweroff"
        },
        {
            id: "restart",
            icon: "󰜉",
            command: commands.restart ?? "systemctl reboot"
        },
        {
            id: "lock",
            icon: "󰌾",
            command: commands.lock ?? "loginctl lock-session"
        },
        {
            id: "suspend",
            icon: "󰒲",
            command: commands.suspend ?? "systemctl suspend"
        },
        {
            id: "logout",
            icon: "󰍃",
            command: commands.logout ?? "hyprctl dispatch exit"
        }
    ]

    function actionById(actionId) {
        for (let i = 0; i < actions.length; i++) {
            if (actions[i].id === actionId)
                return actions[i]
        }
        return null
    }

    function runAction(actionId) {
        const action = actionById(actionId)
        if (!action)
            return false

        const cmd = (action.command || "").trim()
        if (!cmd)
            return false

        actionProc.command = ["bash", "-lc", cmd]
        actionProc.running = false
        actionProc.running = true
        return true
    }

    Process {
        id: actionProc
    }
}
