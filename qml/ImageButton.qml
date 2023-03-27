import QtQuick
import QtQuick.Layouts

Rectangle {
    property string image
    signal pressed()

    id: root
    width: 20
    height: 20
    color: mouseArea.containsMouse ? "#d7eff7" : "transparent"

    Image {
        width: 20
        height: 20
        anchors.centerIn: parent
        source: image
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled : true
        onPressed: root.pressed()
    }
}
