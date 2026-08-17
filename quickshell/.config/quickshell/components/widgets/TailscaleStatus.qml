import QtQuick

import "../../services" as Services
import "../primitives" as Primitive

Item {
    id: root

    property var stateObj
    property var themeObj
    property var styleObj
    property var screenObj

    readonly property var widgetConfig: stateObj?.settings?.widgets?.tailscale ?? {}
    readonly property bool widgetEnabled: widgetConfig.enabled ?? true
    readonly property bool showPill: widgetConfig.showPill ?? true
    readonly property bool showStatus: widgetConfig.showStatus ?? false
    readonly property var visibleOn: widgetConfig.visibleOn ?? []
    readonly property string monitorName: screenObj?.name ?? ""
    readonly property bool isVisibleOnThisMonitor: visibleOn.length === 0 || visibleOn.includes(monitorName)
    readonly property string displayText: root.showStatus ? tailscaleService.status : ""

    visible: root.widgetEnabled && root.isVisibleOnThisMonitor

    implicitWidth: visible && loader.item ? loader.item.implicitWidth : 0
    implicitHeight: visible && loader.item ? loader.item.implicitHeight : 0

    Services.Tailscale {
        id: tailscaleService
        pollInterval: root.widgetConfig.pollInterval ?? 5000
        upCommand: root.widgetConfig.commands?.up ?? "tailscale up"
        downCommand: root.widgetConfig.commands?.down ?? "tailscale down"
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
            icon: tailscaleService.icon
            text: root.displayText
            iconColor: tailscaleService.connected
                ? (root.styleObj ? root.styleObj.textPrimary : (root.themeObj ? root.themeObj.color("light", "#F2EDE3") : "#F2EDE3"))
                : (root.styleObj ? root.styleObj.textMuted : (root.themeObj ? root.themeObj.color("muted", "#9ca3af") : "#9ca3af"))
            textWeight: 600
            itemSpacing: root.styleObj ? root.styleObj.itemGap : (root.themeObj ? root.themeObj.space("xs", 6) : 6)
        }
    }

    Component {
        id: pillComponent

        Primitive.Pill {
            styleObj: root.styleObj
            themeObj: root.themeObj
            horizontalPadding: root.styleObj ? root.styleObj.controlPadX : 12
            verticalPadding: root.styleObj ? root.styleObj.pillPadY : 6
            borderColor: tailscaleService.connected
                ? (root.styleObj ? root.styleObj.colorAccent : (root.themeObj ? root.themeObj.color("accent", "#89b4fa") : "#89b4fa"))
                : (root.styleObj ? root.styleObj.borderSubtle : (root.themeObj ? root.themeObj.color("muted", "#2a3147") : "#2a3147"))

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
