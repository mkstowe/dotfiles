import QtQuick

Item {
    id: root

    property bool enabled: true
    property bool hovered: mouseArea.containsMouse
    property bool pressed: mouseArea.pressed
    property int cursorShape: Qt.PointingHandCursor

    signal clicked
    signal doubleClicked
    signal pressAndHold
    signal wheelUp
    signal wheelDown
    signal entered
    signal exited

    default property alias contentData: content.data

    implicitWidth: content.childrenRect.width
    implicitHeight: content.childrenRect.height

    Item {
        id: content
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        enabled: root.enabled
        cursorShape: root.cursorShape

        onClicked: root.clicked()
        onDoubleClicked: root.doubleClicked()
        onPressAndHold: root.pressAndHold()
        onEntered: root.entered()
        onExited: root.exited()

        onWheel: function(wheel) {
            if (wheel.angleDelta.y > 0)
                root.wheelUp();
            else if (wheel.angleDelta.y < 0)
                root.wheelDown();
        }
    }
}