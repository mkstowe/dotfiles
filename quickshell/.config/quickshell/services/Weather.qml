import QtQuick
import Quickshell.Io

Item {
    id: root

    property string location: ""
    property int intervalMs: 600000

    property string icon: "󰖙"
    property string displayText: "--"
    property string condition: ""
    property string temperature: ""
    property string conditionKey: "unknown"

    function update(text) {
        const trimmed = (text || "").trim()
        if (!trimmed.length)
            return

        // expected format: "Weather,+41°F"
        const parts = trimmed.split(",")

        const rawCondition = parts.length > 0 ? (parts[0] || "").trim() : ""
        const rawTemp = parts.length > 1 ? (parts[1] || "").trim() : ""

        condition = rawCondition
        temperature = rawTemp
        conditionKey = getConditionKey(rawCondition)
        icon = getIconForCondition(conditionKey)
        displayText = rawTemp.length > 0 ? rawTemp : "--"
    }

    function getConditionKey(text) {
        const value = (text || "").toLowerCase()

        if (value.includes("sun") || value.includes("clear"))
            return "clear"

        if (value.includes("partly"))
            return "partly-cloudy"

        if (value.includes("cloud") || value.includes("overcast"))
            return "cloudy"

        if (value.includes("drizzle"))
            return "drizzle"

        if (value.includes("rain") || value.includes("shower"))
            return "rain"

        if (value.includes("snow") || value.includes("sleet") || value.includes("ice"))
            return "snow"

        if (value.includes("thunder") || value.includes("storm"))
            return "storm"

        if (value.includes("fog") || value.includes("mist") || value.includes("haze"))
            return "fog"

        if (value.includes("wind"))
            return "wind"

        return "unknown"
    }

    function getIconForCondition(key) {
        switch (key) {
        case "clear":
            return "󰖙"
        case "partly-cloudy":
            return "󰖕"
        case "cloudy":
            return "󰖐"
        case "drizzle":
            return "󰖗"
        case "rain":
            return "󰖗"
        case "snow":
            return "󰼶"
        case "storm":
            return "󰙾"
        case "fog":
            return "󰖑"
        case "wind":
            return "󰖝"
        default:
            return "󰖙"
        }
    }

    function refresh() {
        weatherProc.running = false
        weatherProc.running = true
    }

    Process {
        id: weatherProc

        command: {
            const suffix = root.location && root.location.length > 0
                ? "/" + root.location
                : ""

            return [
                "bash",
                "-lc",
                "curl -s 'https://wttr.in" + suffix + "?format=%C,%t'"
            ]
        }

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: function(data) {
                root.update(data)
            }
        }
    }

    Timer {
        interval: root.intervalMs
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }

    Component.onCompleted: root.refresh()
}