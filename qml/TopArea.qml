import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ColumnLayout {
    spacing: 0

    Rectangle {
        id: outer
        Layout.fillWidth: true
        color: Universal.chromeMediumLowColor
        height: row.height

        ProfilesRow {
            id: row
            x: -topBar.position * width
        }
    }

    DiscreteScrollBar {
        id: topBar
        orientation: Qt.Horizontal
        size: outer.width / row.width
        Layout.fillWidth: true
        bgColor: Universal.chromeMediumLowColor
    }
}
