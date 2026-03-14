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
    readonly property int forecastPanelHeight: weatherWidget?.forecastPanelHeight ?? 0
    readonly property int forecastMaxPanelHeight: weatherWidget?.forecastMaxPanelHeight ?? 0

    implicitHeight: row.implicitHeight
    implicitWidth: row.implicitWidth

    Primitive.SectionRow {
        id: row
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        themeObj: root.themeObj
        styleObj: root.styleObj

        Widgets.PowerMenuButton {
            stateObj: root.stateObj
            themeObj: root.themeObj
            styleObj: root.styleObj
            screenObj: root.screenObj
        }

        Widgets.LauncherButton {
            stateObj: root.stateObj
            themeObj: root.themeObj
            styleObj: root.styleObj
            screenObj: root.screenObj
        }

        Widgets.Media {
            stateObj: root.stateObj
            themeObj: root.themeObj
            styleObj: root.styleObj
            screenObj: root.screenObj
        }

        Widgets.Weather {
            id: weatherWidget
            stateObj: root.stateObj
            themeObj: root.themeObj
            styleObj: root.styleObj
            screenObj: root.screenObj
        }
    }
}
