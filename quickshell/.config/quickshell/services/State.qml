import QtQuick
import QtQml
import Quickshell.Io

import "../core" as Core

Item {
    id: state

    // Inject this from shell.qml
    property var paths

    Core.Log {
        id: log
    }

    FileView {
        id: defaultsFile
        path: paths ? paths.fromConfig("defaults.jsonc") : ""
        blockLoading: true
        watchChanges: true
        onFileChanged: reload()
    }

    FileView {
        id: featuresFile
        path: paths ? paths.fromConfig("features.jsonc") : ""
        blockLoading: true
        watchChanges: true
        onFileChanged: reload()
    }

    FileView {
        id: keybindsFile
        path: paths ? paths.fromConfig("keybinds.jsonc") : ""
        blockLoading: true
        watchChanges: true
        onFileChanged: reload()
    }

    readonly property var settings: _safeParse(_readText(defaultsFile), {})
    readonly property var features: _safeParse(_readText(featuresFile), {})
    readonly property var keybinds: _safeParse(_readText(keybindsFile), {})

    readonly property string paletteName: (settings?.theme?.palette ?? "mountain")
    readonly property bool barEnabled: (features?.bar ?? true) && (settings?.bar?.enabled ?? true)
    readonly property bool launcherEnabled: (features?.launcher ?? true) && (settings?.launcher?.enabled ?? true)
    readonly property bool powerMenuEnabled: (features?.powerMenu ?? true) && (settings?.powerMenu?.enabled ?? true)
    readonly property bool notificationsHistoryEnabled: (features?.notifications ?? true) && (settings?.notificationsHistory?.enabled ?? true)

    property bool launcherVisible: false
    property string launcherScreen: ""
    property bool powerMenuVisible: false
    property string powerMenuScreen: ""
    property bool notificationHistoryVisible: false
    property string notificationHistoryScreen: ""

    signal configsReloaded

    function openLauncherFor(screenName) {
        closePowerMenu()
        closeNotificationHistory()
        launcherScreen = screenName || ""
        launcherVisible = true
    }

    function closeLauncher() {
        launcherVisible = false
    }

    function openPowerMenuFor(screenName) {
        closeLauncher()
        closeNotificationHistory()
        powerMenuScreen = screenName || ""
        powerMenuVisible = true
    }

    function closePowerMenu() {
        powerMenuVisible = false
    }

    function openNotificationHistoryFor(screenName) {
        closeLauncher()
        closePowerMenu()
        notificationHistoryScreen = screenName || ""
        notificationHistoryVisible = true
    }

    function closeNotificationHistory() {
        notificationHistoryVisible = false
    }

    function toggleLauncher(screenName) {
        const normalized = screenName || ""
        if (launcherVisible && launcherScreen === normalized)
            closeLauncher()
        else
            openLauncherFor(normalized)
    }

    function togglePowerMenu(screenName) {
        const normalized = screenName || ""
        if (powerMenuVisible && powerMenuScreen === normalized)
            closePowerMenu()
        else
            openPowerMenuFor(normalized)
    }

    function toggleNotificationHistory(screenName) {
        const normalized = screenName || ""
        if (notificationHistoryVisible && notificationHistoryScreen === normalized)
            closeNotificationHistory()
        else
            openNotificationHistoryFor(normalized)
    }

    function reloadAll() {
        defaultsFile.reload();
        featuresFile.reload();
        keybindsFile.reload();
        configsReloaded();
    }

    onLauncherEnabledChanged: {
        if (!launcherEnabled)
            closeLauncher()
    }

    onPowerMenuEnabledChanged: {
        if (!powerMenuEnabled)
            closePowerMenu()
    }

    onNotificationsHistoryEnabledChanged: {
        if (!notificationsHistoryEnabled)
            closeNotificationHistory()
    }

    function _readText(fileView) {
        // FileView.text may be a string property OR a function depending on build/version
        if (!fileView)
            return "";
        const t = fileView.text;
        if (typeof t === "function")
            return t.call(fileView);
        return (typeof t === "string") ? t : "";
    }

    function _stripComments(text) {
    if (!text)
        return ""

    // remove // comments
    text = text.replace(/\/\/.*$/gm, "")

    // remove /* */ comments
    text = text.replace(/\/\*[\s\S]*?\*\//g, "")

    return text
}

function _safeParse(text) {
    try {
        const cleaned = _stripComments(text)
        return JSON.parse(cleaned)
    } catch (e) {
        log.error("State", "JSON parse error: " + e)
        return {}
    }
}
}
