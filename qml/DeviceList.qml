import QtQuick

Repeater {
    Repeater {
        model: 4

        Repeater {
            model: 1

            delegate: Qt.createComponent([
                "DeviceLabel.qml",
                "DeviceVolumePopup.qml",
                "DeviceMainButton.qml",
                "DeviceCommButton.qml"
            ][index])
        }
    }
}
