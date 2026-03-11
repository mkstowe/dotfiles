import QtQuick

import "../primitives" as Primitive

Item {
    id: root

    property var stateObj
    property var themeObj
    property var styleObj
    property var screenObj

    property string title: "Desktop"
    property bool showPill: true
    property int maxWidth: 320

    readonly property var widgetConfig: stateObj?.settings?.widgets?.windowTitle ?? {}
    readonly property var visibleOn: widgetConfig.visibleOn ?? []
    readonly property string monitorName: screenObj?.name ?? ""
    readonly property bool isVisibleOnThisMonitor: visibleOn.length === 0 || visibleOn.includes(monitorName)

    visible: isVisibleOnThisMonitor

    implicitWidth: visible && loader.item ? loader.item.implicitWidth : 0
    implicitHeight: visible && loader.item ? loader.item.implicitHeight : 0

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
            horizontalPadding: styleObj ? styleObj.controlPadX : 12
            verticalPadding: styleObj ? styleObj.pillPadY : 6

            Primitive.Label {
                width: root.maxWidth - ((styleObj ? styleObj.controlPadX : 12) * 2)
                styleObj: root.styleObj
                themeObj: root.themeObj
                text: root.title
                textColor: styleObj ? styleObj.textMuted : (themeObj ? themeObj.color("muted", "#8b8795") : "#8b8795")
            }
        }
    }

    Component {
        id: bareComponent

        Primitive.Label {
            width: root.maxWidth
            styleObj: root.styleObj
            themeObj: root.themeObj
            text: root.title
            textColor: styleObj ? styleObj.textMuted : (themeObj ? themeObj.color("muted", "#8b8795") : "#8b8795")
        }
    }
}