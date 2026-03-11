import QtQuick

import "../primitives" as Primitive

Rectangle {
    id: root

    property var themeObj
    property var styleObj
    property var hyprService
    property int workspaceId: -1
    property int size: 18

    readonly property var workspace: hyprService ? hyprService.workspaceById(workspaceId) : null
    readonly property bool isActive: workspace ? (workspace.focused || workspace.active) : false
    readonly property bool isOccupied: workspace ? (workspace.toplevels && workspace.toplevels.values && workspace.toplevels.values.length > 0) : false

    readonly property color activeBgColor: styleObj && styleObj.workspaceActiveBg !== undefined
        ? styleObj.workspaceActiveBg
        : (themeObj ? themeObj.color("accent", "#8aa6c1") : "#8aa6c1")

    readonly property color activeBorderColor: styleObj && styleObj.workspaceActiveBorder !== undefined
        ? styleObj.workspaceActiveBorder
        : activeBgColor

    readonly property color occupiedBgColor: styleObj && styleObj.workspaceOccupiedBg !== undefined
        ? styleObj.workspaceOccupiedBg
        : (themeObj ? themeObj.color("light", "#ffffff") : "#ffffff")

    readonly property color occupiedBorderColor: styleObj && styleObj.workspaceOccupiedBorder !== undefined
        ? styleObj.workspaceOccupiedBorder
        : occupiedBgColor

    readonly property color emptyBgColor: styleObj && styleObj.workspaceEmptyBg !== undefined
        ? styleObj.workspaceEmptyBg
        : "transparent"

    readonly property color emptyBorderColor: styleObj && styleObj.workspaceEmptyBorder !== undefined
        ? styleObj.workspaceEmptyBorder
        : (styleObj ? styleObj.textPrimary : (themeObj ? themeObj.color("light", "#ffffff") : "#ffffff"))

    width: size
    height: size
    radius: size / 2

    color: isActive ? activeBgColor : (isOccupied ? occupiedBgColor : emptyBgColor)

    border.width: 1.5
    border.color: isActive ? activeBorderColor : (isOccupied ? occupiedBorderColor : emptyBorderColor)

    Primitive.Clickable {
        anchors.fill: parent
        onClicked: {
            if (hyprService)
                hyprService.activateWorkspaceId(root.workspaceId);
        }
    }
}