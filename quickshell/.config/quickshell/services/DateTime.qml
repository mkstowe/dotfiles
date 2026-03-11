import QtQuick

Item {
    id: root

    property var stateObj

    property date now: new Date()

    readonly property bool showSeconds: stateObj && stateObj.settings && stateObj.settings.widgets && stateObj.settings.widgets.dateTime && stateObj.settings.widgets.dateTime.showSeconds !== undefined ? stateObj.settings.widgets.dateTime.showSeconds : false

    readonly property string separator: stateObj && stateObj.settings && stateObj.settings.widgets && stateObj.settings.widgets.dateTime && stateObj.settings.widgets.dateTime.separator ? stateObj.settings.widgets.dateTime.separator : " | "

    readonly property string text: formattedDate + separator + formattedTime

    readonly property string formattedDate: formatDate(now)
    readonly property string formattedTime: formatTime(now, showSeconds)

    Timer {
        interval: root.showSeconds ? 250 : 1000
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }

    function pad2(n) {
        return n < 10 ? "0" + n : "" + n;
    }

    function formatDate(d) {
        if (!d)
            return "";

        const weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

        const months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

        return weekdays[d.getDay()] + ", " + months[d.getMonth()] + " " + pad2(d.getDate());
    }

    function formatTime(d, includeSeconds) {
        if (!d)
            return "";

        const hours24 = d.getHours();
        const hours12 = hours24 % 12 === 0 ? 12 : hours24 % 12;
        const minutes = pad2(d.getMinutes());
        const seconds = pad2(d.getSeconds());
        const meridiem = hours24 < 12 ? "AM" : "PM";

        if (includeSeconds)
            return hours12 + ":" + minutes + ":" + seconds + " " + meridiem;

        return hours12 + ":" + minutes + " " + meridiem;
    }
}
