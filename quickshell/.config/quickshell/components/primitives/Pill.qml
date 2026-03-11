import QtQuick

Rectangle {
    id: root

    property var themeObj
    property var styleObj

    property int horizontalPadding: styleObj ? styleObj.pillPadX : 12
    property int verticalPadding: styleObj ? styleObj.pillPadY : 6
    property int minHeight: styleObj ? styleObj.controlMinHeight : 28

    property color bgColor: styleObj ? styleObj.controlBg : (themeObj ? themeObj.color("dark", "#1b2134") : "#1b2134")
    property color borderColor: styleObj ? styleObj.borderSubtle : (themeObj ? themeObj.color("muted", "#2a3147") : "#2a3147")
    property int borderWidth: styleObj ? styleObj.borderWidth : 1
    property int radiusValue: styleObj ? styleObj.controlRadius : (themeObj ? themeObj.radius("md", 12) : 12)

    default property alias contentData: content.data

    implicitWidth: content.childrenRect.width + (horizontalPadding * 2)
    implicitHeight: Math.max(minHeight, content.childrenRect.height + (verticalPadding * 2))

    color: bgColor
    border.width: borderWidth
    border.color: borderColor
    radius: radiusValue

    Item {
        id: content

        x: Math.round((root.implicitWidth - content.childrenRect.width) / 2)
        y: Math.round((root.implicitHeight - content.childrenRect.height) / 2)
    }
}