import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ColumnLayout {
    spacing: 0

    ColumnLayout {
        id: rowParent
        Layout.minimumWidth: 0
        Layout.topMargin: 5
        Layout.bottomMargin: 5
        Layout.leftMargin: 10
        Layout.rightMargin: 10

        ProfilesRow {
            id: row
            x: -topBar.position * width
        }
    }

    ScrollBar {
        id: topBar
        hoverEnabled: true
        active: hovered || pressed
        orientation: Qt.Horizontal
        size: row.parent.width / row.width
        Layout.fillWidth: true
    }

    Rectangle {
        height: 1
        color: '#444'
        Layout.fillWidth: true
    }
}
