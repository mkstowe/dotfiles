import QtQuick
import QtQuick.Layouts

import "../primitives" as Primitive

Item {
    id: root

    property var stateObj
    property var themeObj
    property var styleObj
    property var launcherService
    property var launcherConfig

    signal closeRequested

    function launchAndClose(index) {
        if (launcherService && launcherService.launchApp(index))
            root.closeRequested()
    }

    Rectangle {
        anchors.fill: parent
        color: styleObj.launcherCardBg
        radius: styleObj.panelRadius
        border.width: styleObj.borderWidth
        border.color: styleObj.launcherCardBorder

        MouseArea {
            anchors.fill: parent
            onClicked: {}
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: styleObj.spaceLg
            spacing: styleObj.spaceMd

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                radius: styleObj.controlRadius
                color: styleObj.controlBg
                border.width: styleObj.borderWidth
                border.color: styleObj.borderSubtle

                Primitive.Icon {
                    anchors.left: parent.left
                    anchors.leftMargin: styleObj.spaceMd
                    anchors.verticalCenter: parent.verticalCenter
                    themeObj: root.themeObj
                    styleObj: root.styleObj
                    icon: "󰍉"
                    iconColor: styleObj.textMuted
                }

                TextInput {
                    id: searchInput
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: styleObj.spaceLg + 18
                    anchors.rightMargin: styleObj.spaceMd
                    color: styleObj.textPrimary
                    selectionColor: styleObj.colorAccent
                    selectedTextColor: styleObj.colorLight
                    font.family: styleObj.fontFamily
                    font.pixelSize: styleObj.fontSize
                    clip: true

                    onTextChanged: launcherService?.setQuery(text)

                    Keys.onEscapePressed: root.closeRequested()
                    Keys.onDownPressed: {
                        launcherService?.selectNext(1)
                        listView.positionViewAtIndex(launcherService.selectedIndex, ListView.Contain)
                    }
                    Keys.onUpPressed: {
                        launcherService?.selectNext(-1)
                        listView.positionViewAtIndex(launcherService.selectedIndex, ListView.Contain)
                    }
                    Keys.onReturnPressed: root.launchAndClose(launcherService?.selectedIndex ?? -1)
                    Keys.onEnterPressed: root.launchAndClose(launcherService?.selectedIndex ?? -1)
                }

                Primitive.Label {
                    visible: searchInput.length === 0
                    anchors.left: searchInput.left
                    anchors.verticalCenter: searchInput.verticalCenter
                    text: launcherConfig?.placeholderText ?? "Search applications..."
                    themeObj: root.themeObj
                    styleObj: root.styleObj
                    textColor: styleObj.textMuted
                }
            }

            Primitive.Label {
                Layout.fillWidth: true
                themeObj: root.themeObj
                styleObj: root.styleObj
                text: (launcherService?.filteredApps?.length ?? 0) > 0
                    ? ((launcherService?.filteredApps?.length ?? 0) + " app" + ((launcherService?.filteredApps?.length ?? 0) === 1 ? "" : "s"))
                    : "No matching apps"
                textColor: styleObj.textMuted
            }

            ListView {
                id: listView
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: launcherService?.filteredApps ?? []
                spacing: styleObj.spaceSm
                clip: true
                currentIndex: launcherService?.selectedIndex ?? -1

                delegate: Rectangle {
                    required property var modelData
                    required property int index

                    width: listView.width
                    implicitHeight: (launcherConfig?.showComments ?? true) && (modelData.comment || "").length > 0 ? 64 : 48
                    radius: styleObj.controlRadius
                    color: ListView.isCurrentItem ? styleObj.resultActiveBg : styleObj.resultBg
                    border.width: styleObj.borderWidth
                    border.color: ListView.isCurrentItem ? styleObj.resultActiveBorder : styleObj.resultBorder

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: launcherService.selectedIndex = index
                        onClicked: root.launchAndClose(index)
                    }

                    Column {
                        anchors.fill: parent
                        anchors.leftMargin: styleObj.spaceMd
                        anchors.rightMargin: styleObj.spaceMd
                        anchors.topMargin: styleObj.spaceSm
                        anchors.bottomMargin: styleObj.spaceSm
                        spacing: 2

                        Primitive.Label {
                            themeObj: root.themeObj
                            styleObj: root.styleObj
                            text: modelData.name || "Unknown"
                            textWeight: ListView.isCurrentItem ? 600 : 500
                        }

                        Primitive.Label {
                            visible: (launcherConfig?.showComments ?? true) && (modelData.comment || "").length > 0
                            themeObj: root.themeObj
                            styleObj: root.styleObj
                            text: modelData.comment || ""
                            textColor: styleObj.textMuted
                            textSize: Math.max(11, styleObj.fontSize - 2)
                            elide: Text.ElideRight
                        }
                    }
                }
            }
        }
    }

    function focusSearch() {
        searchInput.forceActiveFocus()
    }
}
