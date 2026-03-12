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
    property bool calendarOpen: false

    readonly property var widgetConfig: stateObj?.settings?.widgets?.dateTime ?? {}
    readonly property var visibleOn: widgetConfig.visibleOn ?? []
    readonly property string monitorName: screenObj?.name ?? ""
    readonly property bool isVisibleOnThisMonitor: visibleOn.length === 0 || visibleOn.includes(monitorName)
    readonly property bool enableCalendarPopover: widgetConfig.enableCalendarPopover ?? true

    readonly property var weekdayLabels: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
    readonly property int calendarGap: 8
    readonly property int calendarWidth: widgetConfig.calendarWidth ?? 292
    readonly property int cellSize: 32
    readonly property int weekGap: 6
    readonly property int calendarHeaderHeight: cellSize
    readonly property int calendarRows: 6
    readonly property int calendarPaddingY: styleObj ? styleObj.pillPadY : 6
    readonly property int contentGap: styleObj ? styleObj.itemGap : 8
    readonly property int calendarBodyHeight: calendarHeaderHeight + contentGap + cellSize + contentGap + (calendarRows * cellSize) + ((calendarRows - 1) * weekGap)
    readonly property int calendarPopupHeight: (calendarPaddingY * 2) + calendarBodyHeight
    readonly property int calendarMaxPanelHeight: enableCalendarPopover ? (calendarPopupHeight + calendarGap) : 0
    readonly property int calendarPanelHeight: (enableCalendarPopover && calendarOpen && visible) ? calendarMaxPanelHeight : 0

    readonly property date currentDate: dateTimeService.now
    readonly property string monthTitle: monthName(currentDate.getMonth()) + " " + currentDate.getFullYear()
    readonly property var calendarCells: buildCalendarCells(currentDate)

    visible: isVisibleOnThisMonitor
    z: calendarOpen ? 10 : 0

    implicitWidth: visible && loader.item ? loader.item.implicitWidth : 0
    implicitHeight: visible && loader.item ? loader.item.implicitHeight : 0

    function closeCalendar() {
        calendarOpen = false
    }

    onEnableCalendarPopoverChanged: {
        if (!enableCalendarPopover)
            closeCalendar()
    }

    onVisibleChanged: {
        if (!visible)
            closeCalendar()
    }

    function monthName(idx) {
        const months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        return months[idx] ?? ""
    }

    function buildCalendarCells(d) {
        const year = d.getFullYear()
        const month = d.getMonth()

        const firstOfMonth = new Date(year, month, 1)
        const firstWeekday = firstOfMonth.getDay()

        const daysInMonth = new Date(year, month + 1, 0).getDate()
        const daysInPrevMonth = new Date(year, month, 0).getDate()

        const today = new Date()

        const cells = []
        for (let i = 0; i < 42; i++) {
            const dayOffset = i - firstWeekday + 1

            let dayValue = 0
            let inCurrentMonth = true
            let cellMonth = month
            let cellYear = year

            if (dayOffset < 1) {
                dayValue = daysInPrevMonth + dayOffset
                inCurrentMonth = false
                cellMonth = month - 1
                if (cellMonth < 0) {
                    cellMonth = 11
                    cellYear = year - 1
                }
            } else if (dayOffset > daysInMonth) {
                dayValue = dayOffset - daysInMonth
                inCurrentMonth = false
                cellMonth = month + 1
                if (cellMonth > 11) {
                    cellMonth = 0
                    cellYear = year + 1
                }
            } else {
                dayValue = dayOffset
            }

            const isToday = cellYear === today.getFullYear() && cellMonth === today.getMonth() && dayValue === today.getDate()

            cells.push({
                day: dayValue,
                inCurrentMonth: inCurrentMonth,
                isToday: isToday
            })
        }

        return cells
    }

    Services.DateTime {
        id: dateTimeService
        stateObj: root.stateObj
    }

    Loader {
        id: loader
        active: root.visible
        sourceComponent: root.showPill ? pillComponent : bareComponent
    }

    Item {
        id: dismissZone
        visible: root.enableCalendarPopover && root.calendarOpen && root.visible
        z: 40
        x: -root.x
        y: root.implicitHeight + root.calendarGap
        width: screenObj?.width ?? (root.parent ? root.parent.width : 1200)
        height: root.calendarPopupHeight

        MouseArea {
            anchors.fill: parent
            onClicked: root.closeCalendar()
        }
    }

    Rectangle {
        id: calendarCard
        visible: root.enableCalendarPopover && root.calendarOpen && root.visible
        z: 50
        y: root.implicitHeight + root.calendarGap
        x: root.implicitWidth - width

        width: root.calendarWidth
        implicitHeight: root.calendarPopupHeight
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
            id: calendarColumn
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: styleObj ? styleObj.controlPadX : 12
            anchors.rightMargin: styleObj ? styleObj.controlPadX : 12
            anchors.top: parent.top
            anchors.topMargin: styleObj ? styleObj.pillPadY : 6
            spacing: styleObj ? styleObj.itemGap : 8

            Primitive.Label {
                styleObj: root.styleObj
                themeObj: root.themeObj
                text: root.monthTitle
                textWeight: 600
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
            }

            Row {
                spacing: root.weekGap
                Repeater {
                    model: root.weekdayLabels
                    delegate: Rectangle {
                        required property string modelData

                        width: root.cellSize
                        height: root.cellSize
                        color: "transparent"

                        Primitive.Label {
                            anchors.centerIn: parent
                            styleObj: root.styleObj
                            themeObj: root.themeObj
                            text: modelData
                            textWeight: 600
                            textColor: root.themeObj ? root.themeObj.color("muted", "#94a0bd") : "#94a0bd"
                        }
                    }
                }
            }

            Grid {
                rows: 6
                columns: 7
                rowSpacing: root.weekGap
                columnSpacing: root.weekGap

                Repeater {
                    model: root.calendarCells

                    delegate: Rectangle {
                        required property var modelData

                        width: root.cellSize
                        height: root.cellSize
                        radius: Math.round(width / 2)
                        color: modelData.isToday
                            ? (root.themeObj ? root.themeObj.color("accent", "#6ea4ff") : "#6ea4ff")
                            : "transparent"
                        border.width: modelData.isToday ? 0 : 1
                        border.color: modelData.inCurrentMonth
                            ? (root.styleObj ? root.styleObj.borderSubtle : (root.themeObj ? root.themeObj.color("muted", "#2a3147") : "#2a3147"))
                            : Qt.rgba(1, 1, 1, 0.08)

                        Primitive.Label {
                            anchors.centerIn: parent
                            styleObj: root.styleObj
                            themeObj: root.themeObj
                            text: modelData.day
                            textWeight: modelData.isToday ? 700 : 500
                            textColor: modelData.isToday
                                ? (root.themeObj ? root.themeObj.color("dark", "#0f111a") : "#0f111a")
                                : (modelData.inCurrentMonth
                                    ? (root.styleObj ? root.styleObj.textPrimary : (root.themeObj ? root.themeObj.color("light", "#e6e1cf") : "#e6e1cf"))
                                    : (root.themeObj ? root.themeObj.color("muted", "#94a0bd") : "#94a0bd"))
                        }
                    }
                }
            }
        }
    }

    Component {
        id: pillComponent

        Primitive.Clickable {
            onClicked: {
                if (root.enableCalendarPopover)
                    root.calendarOpen = !root.calendarOpen
            }

            Primitive.Pill {
                styleObj: root.styleObj
                themeObj: root.themeObj
                horizontalPadding: styleObj ? styleObj.pillPadX * 2 : 24
                verticalPadding: styleObj ? styleObj.pillPadY : 6
                borderColor: root.calendarOpen
                    ? (root.themeObj ? root.themeObj.color("accent", "#6ea4ff") : "#6ea4ff")
                    : (styleObj ? styleObj.borderSubtle : (root.themeObj ? root.themeObj.color("muted", "#2a3147") : "#2a3147"))

                Primitive.Label {
                    styleObj: root.styleObj
                    themeObj: root.themeObj
                    text: dateTimeService.text
                    textWeight: 500
                }
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
