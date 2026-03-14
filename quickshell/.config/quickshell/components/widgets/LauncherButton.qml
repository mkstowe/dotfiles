import QtQuick

import "../primitives" as Primitive

Item {
    id: root

    property var stateObj
    property var themeObj
    property var styleObj
    property var screenObj

    readonly property var launcherConfig: stateObj?.settings?.launcher ?? {}
    readonly property bool isVisibleOnThisMonitor: {
        const visibleOn = launcherConfig.visibleOn ?? []
        const monitorName = screenObj?.name ?? ""
        return visibleOn.length === 0 || visibleOn.includes(monitorName)
    }

    readonly property string icon: launcherConfig.barButtonIcon ?? "󰣆"
    readonly property string label: launcherConfig.barButtonLabel ?? "Apps"
    readonly property bool showLabel: launcherConfig.showBarButtonLabel ?? false
    readonly property bool launcherOpen: (stateObj?.launcherVisible ?? false)
        && ((stateObj?.launcherScreen ?? "") === (screenObj?.name ?? ""))

    visible: (stateObj?.launcherEnabled ?? true) && (launcherConfig.showBarButton ?? true) && isVisibleOnThisMonitor
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
                    stateObj.toggleLauncher(screenObj?.name ?? "")
            }

            Primitive.Pill {
                styleObj: root.styleObj
                themeObj: root.themeObj
                borderColor: root.launcherOpen
                    ? (root.themeObj ? root.themeObj.color("accent", "#6ea4ff") : "#6ea4ff")
                    : (root.styleObj ? root.styleObj.borderSubtle : (root.themeObj ? root.themeObj.color("muted", "#2a3147") : "#2a3147"))

                Primitive.IconText {
                    themeObj: root.themeObj
                    styleObj: root.styleObj
                    icon: root.icon
                    text: root.showLabel ? root.label : ""
                    textWeight: 500
                }
            }
        }
    }
}
