import QtQuick

QtObject {
    id: root

    property var themeObj

    //
    // Raw theme scales
    //
    readonly property int spaceXs: themeObj ? themeObj.space("xs", 4) : 4
    readonly property int spaceSm: themeObj ? themeObj.space("sm", 8) : 8
    readonly property int spaceMd: themeObj ? themeObj.space("md", 12) : 12
    readonly property int spaceLg: themeObj ? themeObj.space("lg", 16) : 16
    readonly property int spaceXl: themeObj ? themeObj.space("xl", 24) : 24

    readonly property int radiusSm: themeObj ? themeObj.radius("sm", 8) : 8
    readonly property int radiusMd: themeObj ? themeObj.radius("md", 12) : 12
    readonly property int radiusLg: themeObj ? themeObj.radius("lg", 16) : 16
    readonly property int radiusXl: themeObj ? themeObj.radius("xl", 20) : 20

    readonly property string fontFamily: themeObj ? themeObj.fontFamily() : "Sans Serif"
    readonly property int fontSize: themeObj ? themeObj.fontSize() : 15
    readonly property string monoFamily: "JetBrains Mono"

    //
    // Raw theme colors
    //
    readonly property color colorDark: themeObj ? themeObj.color("dark", "#2B2A27") : "#2B2A27"
    readonly property color colorLight: themeObj ? themeObj.color("light", "#F2EDE3") : "#F2EDE3"
    readonly property color colorMuted: themeObj ? themeObj.color("muted", "#A89F91") : "#A89F91"
    readonly property color colorPrimary: themeObj ? themeObj.color("primary", "#7A8C5A") : "#7A8C5A"
    readonly property color colorSecondary: themeObj ? themeObj.color("secondary", "#8A6F5A") : "#8A6F5A"
    readonly property color colorAccent: themeObj ? themeObj.color("accent", "#C47A5A") : "#C47A5A"
    readonly property color colorSuccess: themeObj ? themeObj.color("success", "#6F8F6B") : "#6F8F6B"
    readonly property color colorDanger: themeObj ? themeObj.color("danger", "#B25A4A") : "#B25A4A"
    readonly property color colorWarning: themeObj ? themeObj.color("warning", "#C9A24A") : "#C9A24A"
    readonly property color colorInfo: themeObj ? themeObj.color("info", "#6A8F8B") : "#6A8F8B"

    //
    // Global semantic colors
    // These are the defaults the rest of the shell should use.
    //
    readonly property color textPrimary: colorLight
    readonly property color textMuted: colorMuted
    readonly property color textOnAccent: colorLight

    readonly property color borderSubtle: colorMuted
    readonly property color borderStrong: colorLight

    // Main default backgrounds across the shell
    readonly property color appBg: colorDark
    readonly property color panelBg: colorDark
    readonly property color surfaceBg: colorDark
    readonly property color controlBg: colorDark

    // Accent / status
    readonly property color accentBg: colorPrimary
    readonly property color successBg: colorSuccess
    readonly property color warningBg: colorWarning
    readonly property color dangerBg: colorDanger
    readonly property color infoBg: colorInfo

    //
    // Global semantic sizing
    //
    readonly property int borderWidth: 1

    readonly property int panelRadius: radiusLg
    readonly property int surfaceRadius: radiusLg
    readonly property int controlRadius: radiusMd
    readonly property int badgeRadius: radiusSm

    readonly property int panelPadX: spaceLg
    readonly property int panelPadY: spaceMd

    readonly property int surfacePadX: spaceLg
    readonly property int surfacePadY: spaceMd

    readonly property int controlPadX: spaceMd
    readonly property int controlPadY: spaceSm

    readonly property int pillPadX: spaceMd
    readonly property int pillPadY: 6

    readonly property int sectionGap: spaceSm
    readonly property int itemGap: spaceXs

    readonly property int controlMinHeight: 28
    readonly property int barHeight: 40
}