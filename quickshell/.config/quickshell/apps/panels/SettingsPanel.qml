import QtQuick
import QtQuick.Layouts

import "../../components/primitives" as Primitive
import "../../services" as Services

Primitive.Surface {
    id: root

    property var stateObj
    readonly property var tailscaleConfig: stateObj?.settings?.widgets?.tailscale ?? {}

    minWidth: 360

    Services.Tailscale {
        id: tailscaleService
        pollInterval: root.tailscaleConfig.pollInterval ?? 5000
        upCommand: root.tailscaleConfig.commands?.up ?? "tailscale up"
        downCommand: root.tailscaleConfig.commands?.down ?? "tailscale down"
    }

    ColumnLayout {
        spacing: root.themeObj ? root.themeObj.space("md", 12) : 12

        RowLayout {
            spacing: root.themeObj ? root.themeObj.space("sm", 8) : 8

            Primitive.Label {
                themeObj: root.themeObj
                styleObj: root.styleObj
                text: "Network"
                textWeight: 700
            }
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 1
            color: root.styleObj ? root.styleObj.borderSubtle : (root.themeObj ? root.themeObj.color("muted", "#2a3147") : "#2a3147")
        }

        RowLayout {
            spacing: root.themeObj ? root.themeObj.space("md", 12) : 12

            Primitive.IconText {
                themeObj: root.themeObj
                styleObj: root.styleObj
                icon: tailscaleService.icon
                text: "Tailscale"
                iconColor: tailscaleService.connected
                    ? (root.styleObj ? root.styleObj.textPrimary : (root.themeObj ? root.themeObj.color("light", "#F2EDE3") : "#F2EDE3"))
                    : (root.styleObj ? root.styleObj.textMuted : (root.themeObj ? root.themeObj.color("muted", "#9ca3af") : "#9ca3af"))
                textWeight: 600
            }

            Primitive.Label {
                themeObj: root.themeObj
                styleObj: root.styleObj
                text: tailscaleService.status
                textColor: root.styleObj ? root.styleObj.textMuted : (root.themeObj ? root.themeObj.color("muted", "#9ca3af") : "#9ca3af")
            }

            Item {
                Layout.fillWidth: true
            }

            Primitive.Clickable {
                enabled: tailscaleService.available && !tailscaleService.busy
                onClicked: tailscaleService.toggle()

                Rectangle {
                    width: 44
                    height: 24
                    radius: 12
                    color: tailscaleService.connected
                        ? (root.styleObj ? root.styleObj.colorAccent : (root.themeObj ? root.themeObj.color("accent", "#89b4fa") : "#89b4fa"))
                        : (root.styleObj ? root.styleObj.controlBg : (root.themeObj ? root.themeObj.color("dark", "#1b2134") : "#1b2134"))
                    border.width: root.styleObj ? root.styleObj.borderWidth : 1
                    border.color: root.styleObj ? root.styleObj.borderSubtle : (root.themeObj ? root.themeObj.color("muted", "#2a3147") : "#2a3147")
                    opacity: tailscaleService.available ? 1 : 0.55

                    Rectangle {
                        width: 18
                        height: 18
                        radius: 9
                        x: tailscaleService.connected ? 23 : 3
                        anchors.verticalCenter: parent.verticalCenter
                        color: root.styleObj ? root.styleObj.textPrimary : (root.themeObj ? root.themeObj.color("light", "#F2EDE3") : "#F2EDE3")
                    }
                }
            }
        }
    }
}
