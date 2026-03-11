import QtQuick
import QtQuick.Layouts

import "./" as Primitive

Item {
    id: root

    property var themeObj
    property var styleObj

    property string icon: ""
    property string text: ""

    property color iconColor: styleObj ? styleObj.textPrimary : (themeObj ? themeObj.color("light", "#F2EDE3") : "#F2EDE3")
    property color textColor: styleObj ? styleObj.textPrimary : (themeObj ? themeObj.color("light", "#F2EDE3") : "#F2EDE3")

    property int iconSize: styleObj ? styleObj.fontSize : (themeObj ? themeObj.fontSize() : 13)
    property int textSize: styleObj ? styleObj.fontSize : (themeObj ? themeObj.fontSize() : 13)
    property int textWeight: 400
    property int itemSpacing: styleObj ? styleObj.itemGap : (themeObj ? themeObj.space("xs", 4) : 4)

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    RowLayout {
        id: row
        spacing: root.itemSpacing

        Primitive.Icon {
            visible: root.icon.length > 0
            themeObj: root.themeObj
            styleObj: root.styleObj
            icon: root.icon
            iconColor: root.iconColor
            iconSize: root.iconSize
        }

        Primitive.Label {
            visible: root.text.length > 0
            themeObj: root.themeObj
            styleObj: root.styleObj
            text: root.text
            textColor: root.textColor
            textSize: root.textSize
            textWeight: root.textWeight
        }
    }
}