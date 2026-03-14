import QtQuick

import "../../services" as Services
import "../primitives" as Primitive

Item {
    id: root

    property var stateObj
    property var themeObj
    property var styleObj
    property var screenObj
    property var notificationServiceObj

    readonly property bool showPill: widgetConfig.showPill ?? true

    readonly property var widgetConfig: stateObj?.settings?.widgets?.notifications ?? {}
    readonly property bool showCount: widgetConfig.showCount ?? true
    readonly property bool hideWhenZero: widgetConfig.hideWhenZero ?? true
    readonly property var visibleOn: widgetConfig.visibleOn ?? []
    readonly property string monitorName: screenObj?.name ?? ""
    readonly property bool isVisibleOnThisMonitor: visibleOn.length === 0 || visibleOn.includes(monitorName)

    readonly property var serviceRef: notificationServiceObj ? notificationServiceObj : localNotificationsService

    Services.Notifications {
        id: localNotificationsService
        stateObj: root.stateObj
        configObj: root.stateObj?.settings?.notificationsCenter ?? {}
        visible: !root.notificationServiceObj
    }

    readonly property bool hasNotifications: (serviceRef?.count ?? 0) > 0
    readonly property bool shouldShow: isVisibleOnThisMonitor && (!hideWhenZero || hasNotifications)
    readonly property string displayText: root.showCount ? String(serviceRef?.count ?? 0) : ""

    visible: shouldShow

    implicitWidth: visible && loader.item ? loader.item.implicitWidth : 0
    implicitHeight: visible && loader.item ? loader.item.implicitHeight : 0

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
            icon: serviceRef?.icon ?? "󰂚"
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
