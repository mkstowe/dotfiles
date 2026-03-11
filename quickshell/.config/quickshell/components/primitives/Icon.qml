import QtQuick

import "./" as Primitive

Primitive.Label {
    id: root

    property var themeObj
    property var styleObj

    property string icon: ""
    property int iconSize: styleObj ? styleObj.fontSize : (themeObj ? themeObj.fontSize() : 13)
    property color iconColor: styleObj ? styleObj.textPrimary : (themeObj ? themeObj.color("light", "#F2EDE3") : "#F2EDE3")
    property string iconFamily: "Caskaydia Cove Nerd Font"

    text: icon
    textColor: iconColor
    textSize: iconSize
    textFamily: iconFamily
}