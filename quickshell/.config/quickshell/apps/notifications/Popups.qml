import QtQuick
import Quickshell

import "../../components/widgets" as Widgets
import "./" as NotificationParts

PanelWindow {
    id: win

    property var modelData
    property var stateObj
    property var themeObj
    property var notificationServiceObj

    readonly property var popupConfig: stateObj?.settings?.notificationsPopup ?? {}
    readonly property var visibleOn: popupConfig.visibleOn ?? []
    readonly property string monitorName: modelData?.name ?? ""
    readonly property bool isVisibleOnThisMonitor: visibleOn.length === 0 || visibleOn.includes(monitorName)

    visible: (popupConfig.enabled ?? true) && isVisibleOnThisMonitor && ((notificationServiceObj?.popups?.length ?? 0) > 0)

    color: "transparent"
    focusable: false
    screen: modelData

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    NotificationParts.Styles {
        id: styleObj
        themeObj: win.themeObj
    }

    Widgets.NotificationPopupStack {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: popupConfig.topMargin ?? 64
        anchors.rightMargin: popupConfig.rightMargin ?? 18

        themeObj: win.themeObj
        styleObj: styleObj
        notificationServiceObj: win.notificationServiceObj
        popupConfig: win.popupConfig
    }
}
