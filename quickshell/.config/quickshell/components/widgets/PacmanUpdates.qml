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

    readonly property var widgetConfig: stateObj?.settings?.widgets?.pacmanUpdates ?? {}

    readonly property bool showAur: widgetConfig.showAur ?? false
    readonly property string aurHelper: widgetConfig.aurHelper ?? "paru"
    readonly property string labelMode: widgetConfig.labelMode ?? "total"
    readonly property var visibleOn: widgetConfig.visibleOn ?? []
    readonly property string monitorName: screenObj?.name ?? ""
    readonly property bool isVisibleOnThisMonitor: visibleOn.length === 0 || visibleOn.includes(monitorName)

    visible: isVisibleOnThisMonitor && updatesService.hasUpdates

    implicitWidth: visible && loader.item ? loader.item.implicitWidth : 0
    implicitHeight: visible && loader.item ? loader.item.implicitHeight : 0

    Services.PacmanUpdates {
        id: updatesService
        pollInterval: root.widgetConfig.pollInterval ?? 1800000
        showAur: root.showAur
        aurHelper: root.aurHelper
    }

    readonly property string displayText: {
        if (!root.showAur || root.labelMode === "total")
            return String(updatesService.totalCount);

        if (root.labelMode === "split") {
            if (updatesService.aurCount > 0)
                return updatesService.pacmanCount + "+" + updatesService.aurCount;

            return String(updatesService.pacmanCount);
        }

        return String(updatesService.totalCount);
    }

    Loader {
        id: loader
        active: root.visible
        sourceComponent: root.showPill ? pillComponent : bareComponent
    }

    Component {
        id: contentComponent

        Primitive.IconText {
            styleObj: root.styleObj
            themeObj: root.themeObj
            icon: updatesService.icon
            text: root.displayText
            textWeight: 600
            itemSpacing: styleObj ? styleObj.itemGap : (root.themeObj ? root.themeObj.space("xs", 6) : 6)
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