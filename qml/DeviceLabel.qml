import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    clip: true
    height: child.height + 2
    Layout.maximumWidth: child.width + 70
    Layout.preferredWidth: Layout.maximumWidth
    Layout.fillWidth: true
    color: "transparent"

    BorderlessButton {
        id: child
        text: name
        x: -horizontalBar.position * (topGrid.Layout.maximumWidth - 70)
        y: 1

        onPressed: {
            defaultMain = true;
            defaultComm = true;
        }
    }
}
