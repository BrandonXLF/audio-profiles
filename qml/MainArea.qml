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
        color: "transparent"
        clip: true

        GridLayout {
            id: topGrid
            y: -verticalBar.position * (topGrid.Layout.minimumHeight + topGrid.anchors.margins)
            anchors.left: parent.left
            anchors.margins: 16
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

    DiscreteScrollBar {
        id: verticalBar
        orientation: Qt.Vertical
        size: outer.height / (topGrid.Layout.minimumHeight + topGrid.anchors.margins)
        Layout.fillHeight: true
        Layout.row: 0
        Layout.column: 1
    }

    DiscreteScrollBar {
        id: horizontalBar
        orientation: Qt.Horizontal
        size: topGrid.width / (topGrid.Layout.maximumWidth - 70)
        Layout.fillWidth: true
        Layout.row: 1
        Layout.column: 0
    }
}
