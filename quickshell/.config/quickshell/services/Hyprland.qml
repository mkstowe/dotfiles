import QtQuick
import Quickshell.Hyprland

Item {
    id: root

    property var shellScreen

    readonly property var monitor: shellScreen ? Hyprland.monitorFor(shellScreen) : null
    readonly property var workspaces: Hyprland.workspaces
    readonly property var focusedWorkspace: Hyprland.focusedWorkspace
    readonly property var activeToplevel: Hyprland.activeToplevel

    readonly property string activeTitle: {
        if (activeToplevel && activeToplevel.title && activeToplevel.title.length > 0)
            return activeToplevel.title;
        return "Desktop";
    }

    Component.onCompleted: {
        Hyprland.refreshMonitors();
        Hyprland.refreshWorkspaces();
        Hyprland.refreshToplevels();
    }

    function workspaceById(id) {
        const vals = workspaces && workspaces.values ? workspaces.values : [];
        const targetId = Number(id);

        for (let i = 0; i < vals.length; i++) {
            const ws = vals[i];
            if (ws && Number(ws.id) === targetId)
                return ws;
        }

        return null;
    }

    function activateWorkspaceId(id) {
        const targetId = Number(id);
        const ws = workspaceById(targetId);

        if (ws) {
            ws.activate();
            return;
        }

        Hyprland.dispatch("workspace " + targetId);
    }
}