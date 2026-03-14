import QtQuick

import "../primitives" as Primitive

Item {
    id: root

    property var themeObj
    property var styleObj
    property var powerService
    property var powerConfig

    property bool confirmOpen: false
    property string pendingActionId: ""

    readonly property var pendingAction: powerService?.actionById(pendingActionId)

    signal closeRequested

    function requestAction(actionId) {
        if (!(powerConfig?.requireConfirmation ?? true)) {
            if (powerService?.runAction(actionId))
                root.closeRequested()
            return
        }

        pendingActionId = actionId
        confirmOpen = true
    }

    function clearConfirmation() {
        confirmOpen = false
        pendingActionId = ""
    }

    function confirmAction() {
        if (powerService?.runAction(pendingActionId))
            root.closeRequested()
        clearConfirmation()
    }

    onVisibleChanged: {
        if (!visible)
            clearConfirmation()
    }

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
            visible: !root.confirmOpen
            anchors.centerIn: parent
            spacing: powerConfig?.buttonGap ?? styleObj.spaceLg

            Repeater {
                model: powerService?.actions ?? []

                delegate: Rectangle {
                    required property var modelData

                    readonly property bool danger: modelData.id === "poweroff"
                    width: powerConfig?.buttonSize ?? 64
                    height: width
                    radius: Math.round(width / 2)
                    color: styleObj.iconButtonBg
                    border.width: styleObj.borderWidth
                    border.color: click.hovered
                        ? (danger
                            ? (themeObj ? themeObj.color("danger", "#B25A4A") : "#B25A4A")
                            : styleObj.iconButtonHoverBorder)
                        : styleObj.iconButtonBorder

                    Primitive.Clickable {
                        id: click
                        anchors.fill: parent
                        onClicked: root.requestAction(modelData.id)
                    }

                    Primitive.Icon {
                        anchors.centerIn: parent
                        themeObj: root.themeObj
                        styleObj: root.styleObj
                        icon: modelData.icon
                        iconSize: powerConfig?.iconSize ?? 26
                        iconColor: danger
                            ? (themeObj ? themeObj.color("danger", "#B25A4A") : "#B25A4A")
                            : styleObj.textPrimary
                    }
                }
            }
        }

        Row {
            visible: root.confirmOpen
            anchors.centerIn: parent
            spacing: powerConfig?.buttonGap ?? styleObj.spaceLg

            Rectangle {
                width: powerConfig?.buttonSize ?? 64
                height: width
                radius: Math.round(width / 2)
                color: styleObj.iconButtonBg
                border.width: styleObj.borderWidth
                border.color: styleObj.iconButtonBorder

                Primitive.Icon {
                    anchors.centerIn: parent
                    themeObj: root.themeObj
                    styleObj: root.styleObj
                    icon: root.pendingAction?.icon ?? "?"
                    iconSize: powerConfig?.iconSize ?? 26
                    iconColor: root.pendingActionId === "poweroff"
                        ? (themeObj ? themeObj.color("danger", "#B25A4A") : "#B25A4A")
                        : styleObj.textPrimary
                }
            }

            Rectangle {
                width: powerConfig?.buttonSize ?? 64
                height: width
                radius: Math.round(width / 2)
                color: styleObj.iconButtonBg
                border.width: styleObj.borderWidth
                border.color: cancelClick.hovered
                    ? styleObj.iconButtonHoverBorder
                    : styleObj.iconButtonBorder

                Primitive.Clickable {
                    id: cancelClick
                    anchors.fill: parent
                    onClicked: root.clearConfirmation()
                }

                Primitive.Icon {
                    anchors.centerIn: parent
                    themeObj: root.themeObj
                    styleObj: root.styleObj
                    icon: "󰜺"
                    iconSize: powerConfig?.iconSize ?? 26
                    iconColor: styleObj.textPrimary
                }
            }

            Rectangle {
                width: powerConfig?.buttonSize ?? 64
                height: width
                radius: Math.round(width / 2)
                color: styleObj.iconButtonBg
                border.width: styleObj.borderWidth
                border.color: confirmClick.hovered
                    ? (themeObj ? themeObj.color("success", "#6F8F6B") : "#6F8F6B")
                    : styleObj.iconButtonBorder

                Primitive.Clickable {
                    id: confirmClick
                    anchors.fill: parent
                    onClicked: root.confirmAction()
                }

                Primitive.Icon {
                    anchors.centerIn: parent
                    themeObj: root.themeObj
                    styleObj: root.styleObj
                    icon: "󰄬"
                    iconSize: powerConfig?.iconSize ?? 26
                    iconColor: themeObj ? themeObj.color("success", "#6F8F6B") : "#6F8F6B"
                }
            }
        }
    }
}
