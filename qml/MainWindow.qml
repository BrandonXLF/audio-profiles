import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Universal

ApplicationWindow {
    Universal.theme: Universal.System
    id: mainWindow
    width: 360
    height: 450
    visible: true
    color: palette.window
    title: "Audio Profiles"
    font.pointSize: 10.5

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        TopArea {}
        MainArea {}
    }
}
