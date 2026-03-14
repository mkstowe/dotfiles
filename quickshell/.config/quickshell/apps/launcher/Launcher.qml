import QtQuick
import Quickshell

import "../../services" as Services
import "../../components/widgets" as Widgets
import "./" as LauncherParts

PanelWindow {
    id: win

    property var modelData
    property var stateObj
    property var themeObj

    readonly property var launcherConfig: stateObj?.settings?.launcher ?? {}
    readonly property int launcherPadding: launcherConfig.padding ?? styleObj.spaceXl
    readonly property real panelWidthRatio: launcherConfig.panelWidthRatio ?? 0.5
    readonly property real maxPanelWidth: launcherConfig.maxPanelWidth ?? 960
    readonly property int panelMinWidth: launcherConfig.minPanelWidth ?? 520

    visible: (stateObj?.launcherEnabled ?? true)
        && (stateObj?.launcherVisible ?? false)
        && ((stateObj?.launcherScreen ?? "") === "" || (stateObj?.launcherScreen ?? "") === (modelData?.name ?? ""))

    color: "transparent"
    focusable: visible
    screen: modelData

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    LauncherParts.Styles {
        id: styleObj
        themeObj: win.themeObj
    }

    Services.Launcher {
        id: launcherService
        stateObj: win.stateObj
        configObj: win.launcherConfig
    }

    function closeLauncher() {
        if (stateObj)
            stateObj.closeLauncher()
    }

    onVisibleChanged: {
        if (!visible)
            return

        launcherService.reset()
        launcherService.refreshApps()
        Qt.callLater(function() {
            launcherPanel.focusSearch()
        })
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(styleObj.launcherBackdrop.r, styleObj.launcherBackdrop.g, styleObj.launcherBackdrop.b, launcherConfig.backdropOpacity ?? 0.5)

        MouseArea {
            anchors.fill: parent
            onClicked: win.closeLauncher()
        }

        Widgets.LauncherPanel {
            id: launcherPanel
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: win.launcherPadding

            width: Math.min(win.maxPanelWidth, Math.max(win.panelMinWidth, Math.round(parent.width * win.panelWidthRatio)))

            stateObj: win.stateObj
            themeObj: win.themeObj
            styleObj: styleObj
            launcherService: launcherService
            launcherConfig: win.launcherConfig

            onCloseRequested: win.closeLauncher()
        }
    }
}
