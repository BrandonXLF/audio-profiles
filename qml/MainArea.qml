import QtQuick
import QtQuick.Controls
import AudioDeviceModel
import DataFlowModel
import QtQuick.Layouts

GridLayout {
    rowSpacing: 0
    columnSpacing: 0

    Rectangle {
        id: outer
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true

        GridLayout {
            id: topGrid
            y: -verticalBar.position * (topGrid.Layout.minimumHeight + topGrid.anchors.margins)
            anchors.left: parent.left
            anchors.margins: 10
            width: Math.min(Layout.maximumWidth, outer.width) - anchors.margins * 2
            columns: 4

            Repeater {
                model: DataFlowModel {
                    devices: audioDevices
                }

                Repeater {
                    model: 2

                    Repeater {
                        model: 1

                        delegate: {
                            if (index === 0)
                                return Qt.createComponent("ListTitle.qml").createObject(parent, {
                                    titleText: groupTitle
                                })

                            return Qt.createComponent("DeviceList.qml").createObject(parent, {
                                model: subModel
                            })
                        }
                    }
                }
            }
        }
    }

    ScrollBar {
        id: verticalBar
        hoverEnabled: true
        active: hovered || pressed
        orientation: Qt.Vertical
        size: outer.height / (topGrid.Layout.minimumHeight + topGrid.anchors.margins)
        Layout.fillHeight: true
        Layout.row: 0
        Layout.column: 1
    }

    ScrollBar {
        id: horizontalBar
        hoverEnabled: true
        active: hovered || pressed
        orientation: Qt.Horizontal
        size: topGrid.width / (topGrid.Layout.maximumWidth - 70)
        Layout.fillWidth: true
        Layout.row: 1
        Layout.column: 0
    }
}
