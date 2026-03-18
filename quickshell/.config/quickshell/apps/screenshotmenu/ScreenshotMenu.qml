import QtQuick
import Quickshell

import "../../components/widgets" as Widgets
import "../../services" as Services
import "./" as ScreenshotMenuParts

PanelWindow {
    id: win

    property var modelData
    property var stateObj
    property var themeObj

    readonly property var screenshotConfig: stateObj?.settings?.screenshotMenu ?? {}
    readonly property int panelWidth: screenshotConfig.panelWidth ?? 364
    readonly property int panelHeight: screenshotConfig.panelHeight ?? 96
    readonly property int bottomOffset: screenshotConfig.bottomOffset ?? 24

    visible: (stateObj?.screenshotMenuEnabled ?? true)
        && (stateObj?.screenshotMenuVisible ?? false)
        && ((stateObj?.screenshotMenuScreen ?? "") === "" || (stateObj?.screenshotMenuScreen ?? "") === (modelData?.name ?? ""))

    color: "transparent"
    focusable: visible
    screen: modelData

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    ScreenshotMenuParts.Styles {
        id: styleObj
        themeObj: win.themeObj
    }

    Services.ScreenshotMenu {
        id: screenshotService
        configObj: win.screenshotConfig
    }

    function closeMenu() {
        if (stateObj)
            stateObj.closeScreenshotMenu()
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(styleObj.menuBackdrop.r, styleObj.menuBackdrop.g, styleObj.menuBackdrop.b, screenshotConfig.backdropOpacity ?? 0.35)

        MouseArea {
            anchors.fill: parent
            onClicked: win.closeMenu()
        }

        Widgets.ScreenshotMenuPanel {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: win.bottomOffset

            width: win.panelWidth
            height: win.panelHeight

            themeObj: win.themeObj
            styleObj: styleObj
            screenshotService: screenshotService
            screenshotConfig: win.screenshotConfig

            onCloseRequested: win.closeMenu()
        }
    }
}
