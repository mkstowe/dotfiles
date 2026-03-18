import QtQuick

import "../primitives" as Primitive

Item {
    id: root

    property var stateObj
    property var themeObj
    property var styleObj
    property var screenObj

    readonly property var menuConfig: stateObj?.settings?.screenshotMenu ?? {}
    readonly property bool isVisibleOnThisMonitor: {
        const visibleOn = menuConfig.visibleOn ?? []
        const monitorName = screenObj?.name ?? ""
        return visibleOn.length === 0 || visibleOn.includes(monitorName)
    }

    readonly property bool menuOpen: (stateObj?.screenshotMenuVisible ?? false)
        && ((stateObj?.screenshotMenuScreen ?? "") === (screenObj?.name ?? ""))

    visible: (stateObj?.screenshotMenuEnabled ?? true) && (menuConfig.showBarButton ?? true) && isVisibleOnThisMonitor
    implicitWidth: visible && buttonLoader.item ? buttonLoader.item.implicitWidth : 0
    implicitHeight: visible && buttonLoader.item ? buttonLoader.item.implicitHeight : 0

    Loader {
        id: buttonLoader
        active: root.visible
        sourceComponent: buttonComponent
    }

    Component {
        id: buttonComponent

        Primitive.Clickable {
            onClicked: {
                if (stateObj)
                    stateObj.toggleScreenshotMenu(screenObj?.name ?? "")
            }

            Primitive.Pill {
                styleObj: root.styleObj
                themeObj: root.themeObj
                borderColor: root.menuOpen
                    ? (root.themeObj ? root.themeObj.color("accent", "#6ea4ff") : "#6ea4ff")
                    : (root.styleObj ? root.styleObj.borderSubtle : (root.themeObj ? root.themeObj.color("muted", "#2a3147") : "#2a3147"))

                Primitive.Icon {
                    themeObj: root.themeObj
                    styleObj: root.styleObj
                    icon: menuConfig.barButtonIcon ?? "󰹑"
                    iconSize: styleObj ? Math.max(16, styleObj.fontSize + 2) : 16
                }
            }
        }
    }
}
