import QtQuick
import QtQuick.Layouts
import ProfileModel

RowLayout {
    property bool showDelete: false;
    property bool showForm: false;

    id: root
    spacing: 10
    Layout.fillHeight: false

    Text {
        text: "Profiles:"
        Layout.alignment: Qt.AlignVCenter
    }

    Repeater {
        id: repeater
        model: ProfileModel {
            devices: audioDevices
            settings: appSettings
        }

        delegate: Row {
            height: parent.height
            spacing: 5

            BorderlessButton {
                text: name
                anchors.verticalCenter: parent.verticalCenter
                onPressed: repeater.model.loadProfile(index)
            }

            ImageButton {
                visible: root.showDelete
                anchors.verticalCenter: parent.verticalCenter
                image: "qrc:/images/trash.svg"
                onPressed: {
                    root.showDelete = false;
                    repeater.model.deleteProfile(index);
                }
            }
        }
    }

    Rectangle {
        visible: repeater.count > 0
        width: 1
        color: "#444"
        Layout.fillHeight: true
    }

    Row {
        spacing: 5

        AddProfile {
            visible: !root.showDelete
            onFormToggled: visible => root.showForm = visible;
            onCreateProfile: name => repeater.model.newProfile(name);
        }

        ImageButton {
            visible: !root.showForm && repeater.count > 0
            anchors.verticalCenter: parent.verticalCenter
            image: "qrc:/images/" + (root.showDelete ? "cancel.svg" : "trash.svg")
            onPressed: root.showDelete = !root.showDelete
        }
    }
}
