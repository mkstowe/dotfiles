import QtQuick

import "../primitives" as Primitive

Item {
    id: root

    property var themeObj
    property var styleObj
    property var screenshotService
    property var screenshotConfig

    signal closeRequested

    Rectangle {
        anchors.fill: parent
        color: styleObj.menuCardBg
        radius: styleObj.panelRadius
        border.width: styleObj.borderWidth
        border.color: styleObj.menuCardBorder

        MouseArea {
            anchors.fill: parent
            onClicked: {}
        }

        Row {
            anchors.centerIn: parent
            spacing: screenshotConfig?.buttonGap ?? styleObj.spaceLg

            Repeater {
                model: screenshotService?.actions ?? []

                delegate: Rectangle {
                    required property var modelData

                    width: screenshotConfig?.buttonSize ?? 64
                    height: width
                    radius: Math.round(width / 2)
                    color: styleObj.iconButtonBg
                    border.width: styleObj.borderWidth
                    border.color: click.hovered
                        ? styleObj.iconButtonHoverBorder
                        : styleObj.iconButtonBorder

                    Primitive.Clickable {
                        id: click
                        anchors.fill: parent
                        onClicked: {
                            if (root.screenshotService?.runAction(modelData.id))
                                root.closeRequested()
                        }
                    }

                    Primitive.Icon {
                        anchors.centerIn: parent
                        themeObj: root.themeObj
                        styleObj: root.styleObj
                        icon: modelData.icon
                        iconSize: screenshotConfig?.iconSize ?? 26
                        iconColor: styleObj.textPrimary
                    }
                }
            }
        }
    }
}
