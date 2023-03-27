import QtQuick
import QtQuick.Controls
import AudioDeviceModel
import QtQuick.Layouts

Repeater {
    property Layout topGrid
    property ScrollBar horizontalBar
    property string listTitle
    property var subModel

    model: 2

    // Allows us to access parent Repeater index
    Repeater {
        model: 1
        delegate: Qt.createComponent(index === 0 ? "ListTitle.qml" : "AudioDevice.qml")
    }
}
