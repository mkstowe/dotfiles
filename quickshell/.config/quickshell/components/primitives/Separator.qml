import QtQuick

Rectangle {
    id: root

    property var themeObj
    property var styleObj
    property bool vertical: true
    property int thickness: 1
    property int length: 16
    property real lineOpacity: 0.8

    width: vertical ? thickness : length
    height: vertical ? length : thickness
    radius: thickness / 2

    color: styleObj ? styleObj.borderSubtle : (themeObj ? themeObj.color("muted", "#2a3147") : "#2a3147")
    opacity: lineOpacity
}