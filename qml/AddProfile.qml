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
        image: "qrc:/images/plus.svg"
        onPressed: {
            root.showForm = true;
            root.formToggled(root.showForm);
            profileName.text = "Profile";
        }
    }

    TextInput {
        id: profileName
        visible: root.showForm
        text: "Profile"
        anchors.verticalCenter: parent.verticalCenter
    }

    ImageButton {
        image: "qrc:/images/save.svg"
        visible: root.showForm
        anchors.verticalCenter: parent.verticalCenter
        onPressed: {
            root.showForm = false;
            root.formToggled(root.showForm);
            root.createProfile(profileName.text);
        }
    }

    ImageButton {
        image: "qrc:/images/cancel.svg"
        visible: root.showForm
        anchors.verticalCenter: parent.verticalCenter
        onPressed: {
            root.showForm = false;
            root.formToggled(root.showForm);
        }
    }
}
