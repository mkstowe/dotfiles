import QtQuick
import QtQuick.Layouts

import "../../components/widgets" as Widgets
import "../../components/primitives" as Primitive

Item {
    id: root

    property var stateObj
    property var themeObj
    property var styleObj
    property var screenObj

    implicitHeight: row.implicitHeight
    implicitWidth: row.implicitWidth

    Primitive.SectionRow {
        id: row
        anchors.centerIn: parent

        themeObj: root.themeObj
        styleObj: root.styleObj

        Widgets.Workspaces {
            stateObj: root.stateObj
            themeObj: root.themeObj
            styleObj: root.styleObj
            screenObj: root.screenObj
        }
    }
}