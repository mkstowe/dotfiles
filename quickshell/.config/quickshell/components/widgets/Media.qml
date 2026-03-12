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

    readonly property var widgetConfig: stateObj?.settings?.widgets?.media ?? {}
    readonly property string placeholder: widgetConfig.placeholder ?? "-"
    readonly property int maxTextWidth: widgetConfig.maxTextWidth ?? 320
    readonly property var visibleOn: widgetConfig.visibleOn ?? []
    readonly property string monitorName: screenObj?.name ?? ""
    readonly property bool isVisibleOnThisMonitor: visibleOn.length === 0 || visibleOn.includes(monitorName)

    visible: isVisibleOnThisMonitor
    implicitWidth: visible && loader.item ? loader.item.implicitWidth : 0
    implicitHeight: visible && loader.item ? loader.item.implicitHeight : 0

    Services.Media {
        id: mediaService
        selectedPlayer: widgetConfig.player ?? ""
    }

    readonly property string textToShow: mediaService.hasPlayer ? mediaService.displayText : placeholder

    Loader {
        id: loader
        active: root.visible
        sourceComponent: root.showPill ? pillComponent : bareComponent
    }

    Component {
        id: contentComponent

        RowLayout {
            spacing: styleObj ? styleObj.itemGap : 8

            RowLayout {
                spacing: styleObj ? styleObj.controlSpacing : 16

                Primitive.Clickable {
                    enabled: mediaService.canControl
                    opacity: enabled ? 1 : 0.45
                    onClicked: mediaService.previous()

                    Primitive.Icon {
                        themeObj: root.themeObj
                        styleObj: root.styleObj
                        icon: "󰒮"
                        iconSize: styleObj.controlIconSize
                    }
                }

                Primitive.Clickable {
                    enabled: mediaService.canControl
                    opacity: enabled ? 1 : 0.45
                    onClicked: mediaService.toggle()

                    Primitive.Icon {
                        themeObj: root.themeObj
                        styleObj: root.styleObj
                        icon: mediaService.isPlaying ? "󰏤" : "󰐊"
                        iconSize: styleObj.controlIconSize
                    }
                }

                Primitive.Clickable {
                    enabled: mediaService.canControl
                    opacity: enabled ? 1 : 0.45
                    onClicked: mediaService.next()

                    Primitive.Icon {
                        themeObj: root.themeObj
                        styleObj: root.styleObj
                        icon: "󰒭"
                        iconSize: styleObj.controlIconSize
                    }
                }
            }

            Primitive.Spacer {
                width: styleObj ? styleObj.controlSpacing : 8
            }

            Primitive.Label {
                themeObj: root.themeObj
                styleObj: root.styleObj
                text: root.textToShow
                width: root.maxTextWidth
                textWeight: 500
                elide: Text.ElideRight

                Layout.fillWidth: false
                Layout.preferredWidth: Math.min(implicitWidth, root.maxTextWidth)
                Layout.maximumWidth: root.maxTextWidth
            }
        }
    }

    Component {
        id: pillComponent

        Primitive.Pill {
            themeObj: root.themeObj
            styleObj: root.styleObj
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
