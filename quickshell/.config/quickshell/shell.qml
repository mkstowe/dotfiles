import "./apps/bar" as BarApp
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

    Variants {
        model: Quickshell.screens

        delegate: Component {
            BarApp.Bar {
                screen: modelData
                stateObj: state
                themeObj: theme
            }
        }
    }
}
