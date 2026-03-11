import QtQuick

Rectangle {
    id: root

    property var themeObj
    property var styleObj

    property int horizontalPadding: styleObj ? styleObj.surfacePadX : 16
    property int verticalPadding: styleObj ? styleObj.surfacePadY : 12
    property int minWidth: 0
    property int minHeight: 0

    property color bgColor: styleObj ? styleObj.surfaceBg : (themeObj ? themeObj.color("dark", "#141826") : "#141826")
    property color borderColor: styleObj ? styleObj.borderSubtle : (themeObj ? themeObj.color("muted", "#2a3147") : "#2a3147")
    property int borderWidth: styleObj ? styleObj.borderWidth : 1
    property int radiusValue: styleObj ? styleObj.surfaceRadius : (themeObj ? themeObj.radius("lg", 16) : 16)

    default property alias contentData: content.data

    implicitWidth: Math.max(minWidth, content.childrenRect.width + (horizontalPadding * 2))
    implicitHeight: Math.max(minHeight, content.childrenRect.height + (verticalPadding * 2))

    color: bgColor
    border.width: borderWidth
    border.color: borderColor
    radius: radiusValue

    Item {
        id: content
        x: root.horizontalPadding
        y: root.verticalPadding
    }
}