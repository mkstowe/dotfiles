import QtQuick

import "../primitives" as Primitive

Item {
    id: root

    property var themeObj
    property var styleObj
    property var notificationServiceObj
    property var popupConfig

    implicitWidth: column.implicitWidth
    implicitHeight: column.implicitHeight

    Column {
        id: column
        spacing: popupConfig?.gap ?? styleObj.spaceSm

        Repeater {
            model: notificationServiceObj?.popups ?? []

            delegate: Rectangle {
                required property var modelData

                width: popupConfig?.width ?? 360
                implicitHeight: Math.max(78, content.implicitHeight + (styleObj.spaceMd * 2))
                radius: styleObj.controlRadius
                color: styleObj.controlBg
                border.width: styleObj.borderWidth
                border.color: styleObj.borderSubtle

                Primitive.Clickable {
                    anchors.fill: parent
                    onClicked: notificationServiceObj?.dismissPopup(modelData.id)
                }

                Column {
                    id: content
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
                        textWeight: 700
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
