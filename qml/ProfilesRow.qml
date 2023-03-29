import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import ProfileModel

Row {
    property bool showDelete: false
    property bool showForm: false

    id: root
    spacing: 10
    topPadding: 5
    bottomPadding: 5
    leftPadding: 10
    rightPadding: 10

    Label {
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
            spacing: 5

            BorderlessButton {
                text: name
                anchors.verticalCenter: parent.verticalCenter
                onPressed: repeater.model.loadProfile(index)
            }

            ImageButton {
                visible: root.showDelete
                anchors.verticalCenter: parent.verticalCenter
                image: "trash"
                onPressed: {
                    root.showDelete = false;
                    repeater.model.deleteProfile(index);
                }
            }
        }
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
            image: root.showDelete ? "cancel" : "trash"
            onPressed: root.showDelete = !root.showDelete
        }
    }
}
