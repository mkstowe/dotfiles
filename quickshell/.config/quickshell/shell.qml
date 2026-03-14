import "./apps/bar" as BarApp
import "./apps/launcher" as LauncherApp
import "./apps/powermenu" as PowerMenuApp
import "./apps/notifications" as NotificationsApp
import "./core" as Core
import "./services" as Services
import "./theme" as Theme
import QtQuick
import Quickshell

ShellRoot {
    id: root

    Core.Paths {
        id: paths
    }

    Services.State {
        id: state

        paths: paths
    }

    Theme.Theme {
        id: theme

        paths: paths
        state: state
    }

    Services.Notifications {
        id: notificationsCenter
        stateObj: state
        configObj: state?.settings?.notificationsCenter ?? {}
    }

    Variants {
        model: Quickshell.screens

        delegate: Component {
            BarApp.Bar {
                screen: modelData
                stateObj: state
                themeObj: theme
                notificationsObj: notificationsCenter
            }
        }
    }

    Variants {
        model: Quickshell.screens

        delegate: Component {
            LauncherApp.Launcher {
                modelData: modelData
                stateObj: state
                themeObj: theme
            }
        }
    }

    Variants {
        model: Quickshell.screens

        delegate: Component {
            PowerMenuApp.PowerMenu {
                modelData: modelData
                stateObj: state
                themeObj: theme
            }
        }
    }
    Variants {
        model: Quickshell.screens

        delegate: Component {
            NotificationsApp.Popups {
                modelData: modelData
                stateObj: state
                themeObj: theme
                notificationServiceObj: notificationsCenter
            }
        }
    }

    Variants {
        model: Quickshell.screens

        delegate: Component {
            NotificationsApp.History {
                modelData: modelData
                stateObj: state
                themeObj: theme
                notificationServiceObj: notificationsCenter
            }
        }
    }

}
