import QtQuick

Row {
    property bool showForm: false;
    signal formToggled(visible: bool);
    signal createProfile(name: string);

    id: root
    spacing: 5

    ImageButton {
        visible: !root.showDelete && !root.showForm
        anchors.verticalCenter: parent.verticalCenter
        image: "plus"
        onPressed: {
            root.showForm = true;
            root.formToggled(root.showForm);
            profileName.text = "Profile";
        }
    }

    TextInput {
        id: profileName
        visible: root.showForm
        color: palette.windowText
        font.pointSize: mainWindow.font.pointSize
        text: "Profile"
        anchors.verticalCenter: parent.verticalCenter
    }

    ImageButton {
        image: "save"
        visible: root.showForm
        anchors.verticalCenter: parent.verticalCenter
        onPressed: {
            root.showForm = false;
            root.formToggled(root.showForm);
            root.createProfile(profileName.text);
        }
    }

    ImageButton {
        image: "cancel"
        visible: root.showForm
        anchors.verticalCenter: parent.verticalCenter
        onPressed: {
            root.showForm = false;
            root.formToggled(root.showForm);
        }
    }
}
