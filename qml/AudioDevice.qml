import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Repeater {
    model: 4

    // Allows us to access parent Repeater index
    delegate: Repeater {
        model: 1

        delegate: Qt.createComponent([
            "DeviceLabel.qml",
            "DeviceVolumePopup.qml",
            "DeviceDefaultMainButton.qml",
            "DeviceDefaultCommButton.qml"
        ][index])
    }
}
