import QtQuick

import "../primitives" as Primitive

Item {
    id: root

    property var stateObj
    property var themeObj
    property var styleObj
    property var screenObj
    property var notificationServiceObj

    readonly property var menuConfig: stateObj?.settings?.notificationsHistory ?? {}
    readonly property bool isVisibleOnThisMonitor: {
        const visibleOn = menuConfig.visibleOn ?? []
        const monitorName = screenObj?.name ?? ""
        return visibleOn.length === 0 || visibleOn.includes(monitorName)
    }

    readonly property bool historyOpen: (stateObj?.notificationHistoryVisible ?? false)
        && ((stateObj?.notificationHistoryScreen ?? "") === (screenObj?.name ?? ""))

    visible: (menuConfig.enabled ?? true) && (menuConfig.showBarButton ?? true) && isVisibleOnThisMonitor
    implicitWidth: visible && loader.item ? loader.item.implicitWidth : 0
    implicitHeight: visible && loader.item ? loader.item.implicitHeight : 0

    Loader {
        id: loader
        active: root.visible
        sourceComponent: component
    }

    Component {
        id: component

        Primitive.Clickable {
            onClicked: stateObj?.toggleNotificationHistory(screenObj?.name ?? "")

            Primitive.Pill {
                styleObj: root.styleObj
                themeObj: root.themeObj
                borderColor: root.historyOpen
                    ? (root.themeObj ? root.themeObj.color("accent", "#6ea4ff") : "#6ea4ff")
                    : (root.styleObj ? root.styleObj.borderSubtle : (root.themeObj ? root.themeObj.color("muted", "#2a3147") : "#2a3147"))

                Primitive.IconText {
                    themeObj: root.themeObj
                    styleObj: root.styleObj
                    icon: menuConfig.barButtonIcon ?? "󰂚"
                    text: (menuConfig.showCount ?? true) ? String(notificationServiceObj?.count ?? 0) : ""
                    textWeight: 600
                }
            }
        }
    }
}
