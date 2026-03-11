import QtQuick.Layouts

RowLayout {
    id: root

    property var themeObj
    property var styleObj
    property int sectionSpacing: styleObj ? styleObj.sectionGap : (themeObj ? themeObj.space("sm", 8) : 8)

    spacing: sectionSpacing
}