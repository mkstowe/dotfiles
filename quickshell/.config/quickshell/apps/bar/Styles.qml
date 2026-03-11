import QtQuick
import "../../theme" as Theme

Theme.GlobalStyle {
    id: root

    readonly property color globalBorderSubtle: colorMuted

    //
    // Bar shell
    //
    readonly property color barBg: colorDark
    readonly property color barBorder: globalBorderSubtle
    readonly property color barFg: colorLight
    readonly property color barMuted: colorMuted

    //
    // Widgets inside the bar
    //
    readonly property color widgetBg: colorDark
    readonly property color widgetBorder: colorMuted
    readonly property color widgetFg: colorLight
    readonly property color widgetMuted: colorMuted

    //
    // Bar sizing
    //
    readonly property int barRadius: radiusLg
    readonly property int widgetRadius: radiusMd
    readonly property int barGap: sectionGap
    readonly property int barPadX: spaceMd
    readonly property int barPadY: 4
    readonly property real barOpacity: 0.92

    //
    // Primitive remaps for bar children
    //
    readonly property color surfaceBg: widgetBg
    readonly property color surfaceBorder: widgetBorder
    readonly property color controlBg: widgetBg
    readonly property color borderSubtle: widgetBorder
    readonly property color textPrimary: widgetFg
    readonly property color textMuted: widgetMuted
    readonly property int surfaceRadius: widgetRadius
    readonly property int controlRadius: widgetRadius

    //
    // Workspace-specific semantic hooks
    //
    readonly property color workspaceActiveBg: colorAccent
    readonly property color workspaceActiveBorder: colorAccent
    readonly property color workspaceOccupiedBg: colorLight
    readonly property color workspaceOccupiedBorder: colorLight
    readonly property color workspaceEmptyBg: "transparent"
    readonly property color workspaceEmptyBorder: widgetFg

    //
    // Media
    //
    readonly property int sectionSpacing: spaceSm
    readonly property int controlSpacing: spaceLg
    readonly property int controlIconSize: 20
}