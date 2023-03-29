import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import ProfileModel

Row {
    property bool showDelete: false
    property bool showForm: false

    id: root
    spacing: 10
    topPadding: 6
    bottomPadding: 6
    leftPadding: 16
    rightPadding: 16

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

        ProfileName { }
    }

    AddProfile {
        onFormToggled: visible => root.showForm = visible;
        onCreateProfile: name => repeater.model.newProfile(name);
    }
}
