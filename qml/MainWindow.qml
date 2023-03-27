import QtQuick
import QtQuick.Layouts

Window {
    id: mainWindow
    width: 360
    height: 500
    visible: true
    title: "Audio Profiles"

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        TopArea {}
        MainArea {}
    }
}
