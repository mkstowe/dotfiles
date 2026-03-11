import QtQuick
import QtQuick.Layouts

import "../../components/primitives" as Primitive
import "../../components/widgets" as Widgets

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
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        themeObj: root.themeObj
        styleObj: root.styleObj

        Widgets.Media {
            stateObj: root.stateObj
            themeObj: root.themeObj
            styleObj: root.styleObj
            screenObj: root.screenObj
        }

        Widgets.Weather {
            stateObj: root.stateObj
            themeObj: root.themeObj
            styleObj: root.styleObj
            screenObj: root.screenObj
        }
    }
}
