import QtQuick
import QtQuick.Layouts

import "../../components/primitives" as Primitive
import "../../components/widgets/" as Widgets

Item {
    id: root

    property var stateObj
    property var themeObj
    property var styleObj
    property var screenObj
    readonly property int calendarPanelHeight: dateWidget?.calendarPanelHeight ?? 0
    readonly property int calendarMaxPanelHeight: dateWidget?.calendarMaxPanelHeight ?? 0

    implicitHeight: row.implicitHeight
    implicitWidth: row.implicitWidth

    Primitive.SectionRow {
        id: row
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        themeObj: root.themeObj
        styleObj: root.styleObj

        Widgets.PacmanUpdates {
            stateObj: root.stateObj
            themeObj: root.themeObj
            styleObj: root.styleObj
            screenObj: root.screenObj
        }

        Widgets.Notifications {
            stateObj: root.stateObj
            themeObj: root.themeObj
            styleObj: root.styleObj
            screenObj: root.screenObj
        }

        Widgets.NetStatus {
            stateObj: root.stateObj
            themeObj: root.themeObj
            styleObj: root.styleObj
            screenObj: root.screenObj
        }

        Widgets.Volume {
            stateObj: root.stateObj
            themeObj: root.themeObj
            styleObj: root.styleObj
            screenObj: root.screenObj
        }

        Widgets.DateTime {
            id: dateWidget
            stateObj: root.stateObj
            themeObj: root.themeObj
            styleObj: root.styleObj
            screenObj: root.screenObj
        }
    }
}
