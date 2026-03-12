import QtQuick

import "../../services" as Services
import "../primitives" as Primitive

Item {
    id: root

    property var stateObj
    property var themeObj
    property var styleObj
    property var screenObj

    readonly property bool showPill: widgetConfig.showPill ?? true
    property bool forecastOpen: false

    readonly property var widgetConfig: stateObj?.settings?.widgets?.weather ?? {}
    readonly property bool showText: widgetConfig.showText ?? true
    readonly property bool enableForecastPopover: widgetConfig.enableForecastPopover ?? true
    readonly property int configuredForecastDays: Math.max(1, Math.min(7, widgetConfig.forecastDays ?? 3))
    readonly property var visibleOn: widgetConfig.visibleOn ?? []
    readonly property string monitorName: screenObj?.name ?? ""
    readonly property bool isVisibleOnThisMonitor: visibleOn.length === 0 || visibleOn.includes(monitorName)

    readonly property int forecastGap: 8
    readonly property int forecastPaddingX: styleObj ? styleObj.controlPadX : 12
    readonly property int forecastPaddingY: styleObj ? styleObj.pillPadY : 6
    readonly property int rowHeight: styleObj ? styleObj.controlMinHeight : 28
    readonly property int forecastRows: configuredForecastDays
    readonly property int popoverHeight: (forecastPaddingY * 2) + rowHeight + ((rowHeight + (styleObj ? styleObj.itemGap : 8)) * forecastRows)
    readonly property int forecastMaxPanelHeight: enableForecastPopover ? (popoverHeight + forecastGap) : 0
    readonly property int forecastPanelHeight: (enableForecastPopover && forecastOpen && visible) ? forecastMaxPanelHeight : 0

    visible: isVisibleOnThisMonitor
    z: forecastOpen ? 10 : 0

    implicitWidth: visible && loader.item ? loader.item.implicitWidth : 0
    implicitHeight: visible && loader.item ? loader.item.implicitHeight : 0

    function closeForecast() {
        forecastOpen = false
    }

    onEnableForecastPopoverChanged: {
        if (!enableForecastPopover)
            closeForecast()
    }

    onVisibleChanged: {
        if (!visible)
            closeForecast()
    }

    Services.Weather {
        id: weatherService
        location: widgetConfig.location ?? ""
        intervalMs: widgetConfig.intervalMs ?? 600000
        forecastDaysCount: root.configuredForecastDays
    }

    readonly property string displayText: root.showText ? weatherService.displayText : ""

    Loader {
        id: loader
        active: root.visible
        sourceComponent: root.showPill ? pillComponent : bareComponent
    }

    Item {
        id: dismissZone
        visible: root.enableForecastPopover && root.forecastOpen && root.visible
        z: 40
        x: -root.x
        y: root.implicitHeight + root.forecastGap
        width: screenObj?.width ?? (root.parent ? root.parent.width : 1200)
        height: root.popoverHeight

        MouseArea {
            anchors.fill: parent
            onClicked: root.closeForecast()
        }
    }

    Rectangle {
        id: forecastCard
        visible: root.enableForecastPopover && root.forecastOpen && root.visible
        x: 0
        y: root.implicitHeight + root.forecastGap
        z: 50

        implicitWidth: Math.max(root.implicitWidth, cardColumn.implicitWidth + (forecastPaddingX * 2))
        implicitHeight: root.popoverHeight
        width: implicitWidth
        height: implicitHeight

        color: styleObj ? styleObj.controlBg : (themeObj ? themeObj.color("dark", "#1b2134") : "#1b2134")
        border.width: styleObj ? styleObj.borderWidth : 1
        border.color: styleObj ? styleObj.borderSubtle : (themeObj ? themeObj.color("muted", "#2a3147") : "#2a3147")
        radius: styleObj ? styleObj.controlRadius : (themeObj ? themeObj.radius("md", 12) : 12)

        MouseArea {
            anchors.fill: parent
            onClicked: {}
        }

        Column {
            id: cardColumn
            x: forecastPaddingX
            y: forecastPaddingY
            spacing: styleObj ? styleObj.itemGap : 8

            Primitive.IconText {
                styleObj: root.styleObj
                themeObj: root.themeObj
                icon: weatherService.icon
                text: weatherService.condition + " • " + weatherService.temperature
                textWeight: 600
            }

            Repeater {
                model: weatherService.forecastDays

                delegate: Primitive.Pill {
                    required property var modelData

                    styleObj: root.styleObj
                    themeObj: root.themeObj
                    horizontalPadding: styleObj ? styleObj.controlPadX : 10
                    verticalPadding: styleObj ? styleObj.pillPadY : 6

                    Primitive.Label {
                        styleObj: root.styleObj
                        themeObj: root.themeObj
                        text: modelData.date + "  "
                            + modelData.summary + "  "
                            + modelData.minTempF + "°F / " + modelData.maxTempF + "°F"
                            + "  ☔ " + modelData.rainChance + "%"
                    }
                }
            }
        }
    }

    Component {
        id: contentComponent

        Primitive.IconText {
            styleObj: root.styleObj
            themeObj: root.themeObj
            icon: weatherService.icon
            text: root.displayText
            textWeight: 600
            itemSpacing: styleObj ? styleObj.itemGap : (root.themeObj ? root.themeObj.space("xs", 6) : 6)
        }
    }

    Component {
        id: pillComponent

        Primitive.Clickable {
            onClicked: {
                if (root.enableForecastPopover)
                    root.forecastOpen = !root.forecastOpen
            }

            Primitive.Pill {
                styleObj: root.styleObj
                themeObj: root.themeObj
                horizontalPadding: styleObj ? styleObj.controlPadX : 12
                verticalPadding: styleObj ? styleObj.pillPadY : 6
                borderColor: root.forecastOpen
                    ? (root.themeObj ? root.themeObj.color("accent", "#6ea4ff") : "#6ea4ff")
                    : (styleObj ? styleObj.borderSubtle : (root.themeObj ? root.themeObj.color("muted", "#2a3147") : "#2a3147"))

                Loader {
                    sourceComponent: contentComponent
                }
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
