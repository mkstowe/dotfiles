import QtQuick

Text {
    id: root

    property var themeObj
    property var styleObj

    property color textColor: styleObj ? styleObj.textPrimary : (themeObj ? themeObj.color("light", "#e6e1cf") : "#e6e1cf")
    property int textSize: styleObj ? styleObj.fontSize : (themeObj ? themeObj.fontSize() : 13)
    property string textFamily: styleObj ? styleObj.fontFamily : (themeObj ? themeObj.fontFamily() : "Sans Serif")
    property string monospaceFamily: styleObj && styleObj.monoFamily ? styleObj.monoFamily : "JetBrains Mono"
    property int textWeight: 400
    property bool monospace: false

    color: textColor
    font.pixelSize: textSize
    font.family: monospace ? monospaceFamily : textFamily
    font.weight: textWeight

    elide: Text.ElideRight
    verticalAlignment: Text.AlignVCenter
}