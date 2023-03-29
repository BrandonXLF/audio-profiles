import QtQuick
import QtQuick.Controls

Label {
    signal pressed()

    id: root

    background: Rectangle {
        color: mouseArea.containsMouse ? Universal.chromeDisabledHighColor : "transparent"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled : true
        onPressed: root.pressed()
    }
}
