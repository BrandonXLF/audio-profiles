import QtQuick
import QtQuick.Controls

Label {
    signal pressed()

    id: root

    background: Rectangle {
        color: nameMouseArea.containsMouse ? "#d7eff7" : "transparent"
    }

    MouseArea {
        id: nameMouseArea
        anchors.fill: parent
        hoverEnabled : true
        onPressed: root.pressed()
    }
}
