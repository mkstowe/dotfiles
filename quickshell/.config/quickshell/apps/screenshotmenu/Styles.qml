import QtQuick
import "../../theme" as Theme

Theme.GlobalStyle {
    id: root

    readonly property color menuBackdrop: Qt.rgba(0, 0, 0, 0.35)
    readonly property color menuCardBg: panelBg
    readonly property color menuCardBorder: borderSubtle

    readonly property color iconButtonBg: controlBg
    readonly property color iconButtonBorder: borderSubtle
    readonly property color iconButtonHoverBorder: colorAccent
}
