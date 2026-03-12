import QtQuick
import QtQuick.Layouts
import Quickshell

import "./" as BarParts

PanelWindow {
    id: win

    property var modelData
    property var stateObj
    property var themeObj

    readonly property int baseBarHeight: stateObj?.settings?.bar?.height ?? styles.barHeight
    readonly property int expandedHeight: Math.max(leftSection?.forecastMaxPanelHeight ?? 0, rightSection?.calendarMaxPanelHeight ?? 0)

    screen: modelData

    BarParts.Styles {
        id: styles
        themeObj: win.themeObj
    }

    visible: stateObj ? stateObj.barEnabled : true
    color: "transparent"
    focusable: false

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: baseBarHeight + expandedHeight
    exclusiveZone: baseBarHeight

    margins {
        top: stateObj?.settings?.bar?.margins?.top ?? 10
        left: stateObj?.settings?.bar?.margins?.left ?? 12
        right: stateObj?.settings?.bar?.margins?.right ?? 12
    }

    Rectangle {
        id: bg
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: win.baseBarHeight
        radius: styles.barRadius
        color: styles.barBg
        border.color: styles.barBorder
        border.width: styles.borderWidth
        opacity: styles.barOpacity

        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            radius: Math.max(0, parent.radius - 1)
            color: "transparent"
            border.width: 1
            border.color: Qt.rgba(1, 1, 1, 0.03)
        }

        Item {
            anchors.fill: parent
            anchors.leftMargin: styles.barPadX
            anchors.rightMargin: styles.barPadX
            anchors.topMargin: styles.barPadY
            anchors.bottomMargin: styles.barPadY

            BarParts.BarLeft {
                id: leftSection
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                stateObj: win.stateObj
                themeObj: win.themeObj
                styleObj: styles
                screenObj: win.screen
            }

            BarParts.BarCenter {
                id: centerSection
                anchors.centerIn: parent

                stateObj: win.stateObj
                themeObj: win.themeObj
                styleObj: styles
                screenObj: win.screen
            }

            BarParts.BarRight {
                id: rightSection
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                stateObj: win.stateObj
                themeObj: win.themeObj
                styleObj: styles
                screenObj: win.screen
            }
        }
    }
}
