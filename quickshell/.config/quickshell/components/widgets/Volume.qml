import QtQuick
import QtQuick.Layouts

import "../../services" as Services
import "../primitives" as Primitive

Item {
    id: root

    property var stateObj
    property var themeObj
    property var styleObj
    property var screenObj

    readonly property bool showPill: widgetConfig.showPill ?? true

    readonly property var widgetConfig: stateObj?.settings?.widgets?.volume ?? {}
    readonly property int step: widgetConfig.step ?? 5
    readonly property bool showPercent: widgetConfig.showPercent ?? true
    readonly property var visibleOn: widgetConfig.visibleOn ?? []
    readonly property string monitorName: screenObj?.name ?? ""
    readonly property bool isVisibleOnThisMonitor: visibleOn.length === 0 || visibleOn.includes(monitorName)

    visible: isVisibleOnThisMonitor

    implicitWidth: visible && loader.item ? loader.item.implicitWidth : 0
    implicitHeight: visible && loader.item ? loader.item.implicitHeight : 0

    Services.Volume {
        id: volumeService
        step: root.step
    }

    readonly property string displayText: volumeService.muted ? "MUTE" : (root.showPercent ? (volumeService.percent + "%") : "")

    Loader {
        id: loader
        active: root.visible
        sourceComponent: root.showPill ? pillComponent : bareComponent
    }

    Component {
        id: contentComponent

        Primitive.Clickable {
            onClicked: volumeService.toggleMute()
            onWheelUp: volumeService.increase()
            onWheelDown: volumeService.decrease()

            Primitive.IconText {
                styleObj: root.styleObj
                themeObj: root.themeObj
                icon: volumeService.icon
                text: root.displayText
                textWeight: 600
                itemSpacing: styleObj ? styleObj.sectionGap : (root.themeObj ? root.themeObj.space("sm", 8) : 8)
            }
        }
    }

    Component {
        id: pillComponent

        Primitive.Pill {
            styleObj: root.styleObj
            themeObj: root.themeObj
            horizontalPadding: styleObj ? styleObj.controlPadX : 12
            verticalPadding: styleObj ? styleObj.pillPadY : 6

            Loader {
                sourceComponent: contentComponent
            }
        }
    }

    Component {
        id: bareComponent

        Loader {
            sourceComponent: contentComponent
        }
    }
}
