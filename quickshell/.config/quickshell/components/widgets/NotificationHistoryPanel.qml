import QtQuick
import QtQuick.Layouts

import "../primitives" as Primitive

Item {
    id: root

    property var themeObj
    property var styleObj
    property var notificationServiceObj
    property var historyConfig

    signal closeRequested

    Rectangle {
        anchors.fill: parent
        color: styleObj.panelBg
        radius: styleObj.panelRadius
        border.width: styleObj.borderWidth
        border.color: styleObj.borderSubtle

        MouseArea {
            anchors.fill: parent
            onClicked: {}
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: styleObj.spaceLg
            spacing: styleObj.spaceSm

            RowLayout {
                Layout.fillWidth: true

                Primitive.Label {
                    themeObj: root.themeObj
                    styleObj: root.styleObj
                    text: historyConfig?.title ?? "Notifications"
                    textWeight: 700
                }

                Item { Layout.fillWidth: true }

                Primitive.Clickable {
                    onClicked: notificationServiceObj?.clearHistory()

                    Primitive.Icon {
                        themeObj: root.themeObj
                        styleObj: root.styleObj
                        icon: "󰆴"
                    }
                }

                Primitive.Clickable {
                    onClicked: root.closeRequested()

                    Primitive.Icon {
                        themeObj: root.themeObj
                        styleObj: root.styleObj
                        icon: "󰅖"
                    }
                }
            }

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: styleObj.spaceSm
                model: notificationServiceObj?.history ?? []

                delegate: Rectangle {
                    required property var modelData

                    width: ListView.view.width
                    implicitHeight: Math.max(64, itemColumn.implicitHeight + (styleObj.spaceSm * 2))
                    radius: styleObj.controlRadius
                    color: styleObj.controlBg
                    border.width: styleObj.borderWidth
                    border.color: styleObj.borderSubtle

                    Primitive.Clickable {
                        anchors.fill: parent
                        onClicked: notificationServiceObj?.dismissHistory(modelData.id)
                    }

                    Column {
                        id: itemColumn
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: styleObj.spaceMd
                        anchors.rightMargin: styleObj.spaceMd
                        spacing: 4

                        Primitive.Label {
                            themeObj: root.themeObj
                            styleObj: root.styleObj
                            text: (modelData.app || "Notification") + "  •  " + (modelData.summary || "")
                            textWeight: 600
                        }

                        Primitive.Label {
                            visible: (modelData.body || "").length > 0
                            themeObj: root.themeObj
                            styleObj: root.styleObj
                            text: modelData.body || ""
                            textColor: styleObj.textMuted
                        }
                    }
                }
            }
        }
    }
}
