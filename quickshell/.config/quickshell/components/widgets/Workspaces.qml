import QtQuick
import QtQuick.Layouts

import "../primitives" as Primitive
import "../../services" as Services
import "./" as Widgets

Item {
    id: root

    property var stateObj
    property var themeObj
    property var styleObj
    property var screenObj

    property bool showPill: true
    property int pillHeight: styleObj ? styleObj.controlMinHeight + 4 : 32
    property int horizontalPadding: styleObj ? styleObj.pillPadX * 2 : 24
    property int workspaceSpacing: styleObj ? styleObj.sectionGap + 4 : 12
    property int workspaceSize: 14

    readonly property var widgetConfig: stateObj?.settings?.widgets?.workspaces ?? {}
    readonly property var visibleOn: widgetConfig.visibleOn ?? []
    readonly property string configuredMonitorName: screenObj?.name ?? ""
    readonly property bool isVisibleOnThisMonitor: visibleOn.length === 0 || visibleOn.includes(configuredMonitorName)

    visible: isVisibleOnThisMonitor

    implicitWidth: visible && loader.item ? loader.item.implicitWidth : 0
    implicitHeight: visible && loader.item ? loader.item.implicitHeight : 0

    Services.Hyprland {
        id: hypr
        shellScreen: root.screenObj
    }

    readonly property string monitorName: hypr.monitor ? hypr.monitor.name : ""

    readonly property var workspaceIds: {
        const byMonitor = stateObj?.settings?.workspaces?.byMonitor ?? null;

        if (monitorName && byMonitor && byMonitor[monitorName])
            return byMonitor[monitorName];

        return [];
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
            minHeight: root.pillHeight
            horizontalPadding: root.horizontalPadding
            verticalPadding: styleObj ? styleObj.pillPadY : 6

            RowLayout {
                id: workspaceRow
                spacing: root.workspaceSpacing

                Repeater {
                    model: root.workspaceIds

                    delegate: Widgets.WorkspaceDot {
                        required property var modelData
                        styleObj: root.styleObj
                        themeObj: root.themeObj
                        hyprService: hypr
                        workspaceId: Number(modelData)
                        size: root.workspaceSize
                    }
                }
            }
        }
    }

    Component {
        id: bareComponent

        RowLayout {
            id: workspaceRowBare
            spacing: root.workspaceSpacing

            Repeater {
                model: root.workspaceIds

                delegate: Widgets.WorkspaceDot {
                    required property var modelData
                    styleObj: root.styleObj
                    themeObj: root.themeObj
                    hyprService: hypr
                    workspaceId: Number(modelData)
                    size: root.workspaceSize
                }
            }
        }
    }
}