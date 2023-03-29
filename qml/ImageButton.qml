import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    property string image
    signal pressed()

    id: root
    width: 20
    height: 20
    color: mouseArea.containsMouse ? Universal.chromeDisabledHighColor : "transparent"

    Image {
        width: 20
        height: 20
        anchors.centerIn: parent
        source: "qrc:/images/" + (Universal.theme == Universal.Dark ? 'dark' : 'light') + "/" + image + ".svg"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled : true
        onPressed: root.pressed()
    }
}
