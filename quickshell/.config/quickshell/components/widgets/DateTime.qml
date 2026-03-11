import QtQuick

import "../../services" as Services
import "../primitives" as Primitive

Item {
    id: root

    property var stateObj
    property var themeObj
    property var styleObj
    property var screenObj

    property bool showPill: true

    readonly property var widgetConfig: stateObj?.settings?.widgets?.dateTime ?? {}
    readonly property var visibleOn: widgetConfig.visibleOn ?? []
    readonly property string monitorName: screenObj?.name ?? ""
    readonly property bool isVisibleOnThisMonitor: visibleOn.length === 0 || visibleOn.includes(monitorName)

    visible: isVisibleOnThisMonitor

    implicitWidth: visible && loader.item ? loader.item.implicitWidth : 0
    implicitHeight: visible && loader.item ? loader.item.implicitHeight : 0

    Services.DateTime {
        id: dateTimeService
        stateObj: root.stateObj
    }

    Loader {
        id: loader
        active: root.visible
        sourceComponent: root.showPill ? pillComponent : bareComponent
    }

    Component {
        id: pillComponent

        Primitive.Pill {
            styleObj: root.styleObj
            themeObj: root.themeObj
            horizontalPadding: styleObj ? styleObj.pillPadX * 2 : 24
            verticalPadding: styleObj ? styleObj.pillPadY : 6

            Primitive.Label {
                styleObj: root.styleObj
                themeObj: root.themeObj
                text: dateTimeService.text
                textWeight: 500
            }
        }
    }

    Component {
        id: bareComponent

        Primitive.Label {
            styleObj: root.styleObj
            themeObj: root.themeObj
            text: dateTimeService.text
            textWeight: 500
        }
    }
}