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

    readonly property var historyConfig: stateObj?.settings?.notificationsHistory ?? {}
    readonly property var visibleOn: historyConfig.visibleOn ?? []
    readonly property string monitorName: modelData?.name ?? ""
    readonly property bool isVisibleOnThisMonitor: visibleOn.length === 0 || visibleOn.includes(monitorName)

    visible: (historyConfig.enabled ?? true)
        && isVisibleOnThisMonitor
        && (stateObj?.notificationHistoryVisible ?? false)
        && ((stateObj?.notificationHistoryScreen ?? "") === "" || (stateObj?.notificationHistoryScreen ?? "") === (modelData?.name ?? ""))

    color: "transparent"
    focusable: visible
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

    function closeHistory() {
        stateObj?.closeNotificationHistory()
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, historyConfig.backdropOpacity ?? 0.25)

        MouseArea {
            anchors.fill: parent
            onClicked: win.closeHistory()
        }

        Widgets.NotificationHistoryPanel {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: historyConfig.topMargin ?? 64
            anchors.rightMargin: historyConfig.rightMargin ?? 18

            width: historyConfig.width ?? 420
            height: historyConfig.height ?? 540

            themeObj: win.themeObj
            styleObj: styleObj
            notificationServiceObj: win.notificationServiceObj
            historyConfig: win.historyConfig
            onCloseRequested: win.closeHistory()
        }
    }
}
