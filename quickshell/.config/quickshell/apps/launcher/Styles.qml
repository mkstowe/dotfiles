import QtQuick
import "../../theme" as Theme

Theme.GlobalStyle {
    id: root

    readonly property color launcherBackdrop: Qt.rgba(0, 0, 0, 0.5)
    readonly property color launcherCardBg: panelBg
    readonly property color launcherCardBorder: borderSubtle

    readonly property color resultBg: controlBg
    readonly property color resultBorder: borderSubtle
    readonly property color resultActiveBg: Qt.rgba(colorAccent.r, colorAccent.g, colorAccent.b, 0.16)
    readonly property color resultActiveBorder: colorAccent
}
