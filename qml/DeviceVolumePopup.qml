import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    width: popupOpener.width
    height: popupOpener.height

    ImageButton {
        id: popupOpener
        Layout.alignment: Qt.AlignVCenter
        image: "qrc:/images/" + ((!volume || mute) ? "volume-mute.svg" : (volume <= 0.5 ? "volume-low.svg" : "volume-high.svg"))
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
        background: Rectangle {
            color: "white"
            border.color: '#888'
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

                background: Rectangle {
                    x: (parent.availableWidth - width) / 2
                    color: '#bbb'
                    height: parent.availableHeight
                    width: 4
                    radius: 1

                    Rectangle {
                        width: parent.width
                        height: (1 - parent.parent.visualPosition) * parent.height
                        y: parent.parent.visualPosition * parent.height
                        color: 'green'
                        radius: 2
                    }
                }

                handle: Rectangle {
                    color: 'green'
                    implicitHeight: 6
                    implicitWidth: parent.availableWidth * 0.7
                    radius: 2
                    x: (parent.availableWidth - width) / 2
                    y: parent.visualPosition * (parent.availableHeight - height)
                }

                onMoved: volume = value
            }

            ImageButton {
                Layout.alignment: Qt.AlignVCenter
                image: "qrc:/images/" + ((!volume || mute) ? "volume-mute.svg" : (volume <= 0.5 ? "volume-low.svg" : "volume-high.svg"))
                onPressed: mute = !mute
            }
        }
    }
}
