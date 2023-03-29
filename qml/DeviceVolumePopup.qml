import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    width: popupOpener.width
    height: popupOpener.height

    ImageButton {
        id: popupOpener
        Layout.alignment: Qt.AlignVCenter
        image: (!volume || mute) ? "volume-mute" : (volume <= 0.5 ? "volume-low" : "volume-high")
        onPressed: popup.open();
    }

    Popup {
        id: popup
        x: popupOpener.x - padding
        y: popupOpener.y - height + popupOpener.height + padding
        height: 90
        visible: hasPopup
        width: popupOpener.width + padding * 2
        focus: true
        padding: 5
        Universal.theme: Universal.System
        background: Rectangle {
            color: Universal.chromeMediumLowColor
            border.color: Universal.chromeHighColor
            border.width: 1
            radius: 2
        }
        onOpened: hasPopup = true
        onClosed: hasPopup = false

        ColumnLayout {
            anchors.fill: parent
            spacing: 5

            Slider {
                value: volume
                Layout.preferredHeight: 70
                Layout.fillHeight: true
                Layout.fillWidth: true
                orientation: Qt.Vertical
                handle.width: 15
                Universal.accent: Universal.theme == Universal.Dark ? 'lightgreen' : 'green'
                onMoved: volume = value
            }

            ImageButton {
                Layout.alignment: Qt.AlignVCenter
                image: (!volume || mute) ? "volume-mute" : (volume <= 0.5 ? "volume-low" : "volume-high")
                onPressed: mute = !mute
            }
        }
    }
}
