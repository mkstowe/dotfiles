import QtQuick
import Quickshell

import "../../components/widgets" as Widgets
import "../../services" as Services
import "./" as PowerMenuParts

PanelWindow {
    id: win

    property var modelData
    property var stateObj
    property var themeObj

    readonly property var powerConfig: stateObj?.settings?.powerMenu ?? {}
    readonly property int panelWidth: powerConfig.panelWidth ?? 440
    readonly property int panelHeight: powerConfig.panelHeight ?? 96
    readonly property int bottomOffset: powerConfig.bottomOffset ?? 24

    visible: (stateObj?.powerMenuEnabled ?? true)
        && (stateObj?.powerMenuVisible ?? false)
        && ((stateObj?.powerMenuScreen ?? "") === "" || (stateObj?.powerMenuScreen ?? "") === (modelData?.name ?? ""))

    color: "transparent"
    focusable: visible
    screen: modelData

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    PowerMenuParts.Styles {
        id: styleObj
        themeObj: win.themeObj
    }

    Services.PowerMenu {
        id: powerService
        configObj: win.powerConfig
    }

    function closeMenu() {
        if (stateObj)
            stateObj.closePowerMenu()
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(styleObj.menuBackdrop.r, styleObj.menuBackdrop.g, styleObj.menuBackdrop.b, powerConfig.backdropOpacity ?? 0.35)

        MouseArea {
            anchors.fill: parent
            onClicked: win.closeMenu()
        }

        Widgets.PowerMenuPanel {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: win.bottomOffset

            width: win.panelWidth
            height: win.panelHeight

            themeObj: win.themeObj
            styleObj: styleObj
            powerService: powerService
            powerConfig: win.powerConfig

            onCloseRequested: win.closeMenu()
        }
    }
}
