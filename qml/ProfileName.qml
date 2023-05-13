import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import ProfileModel

Row {
    property bool showRename: false

    spacing: 5
    Layout.alignment: Qt.AlignVCenter

    BorderlessButton {
        onPressed: repeater.model.loadProfile(index)
        visible: !showRename
        text: name

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.RightButton
            onClicked: contextMenu.popup()

            Menu {
                id: contextMenu
                width: Math.max(100, implicitContentHeight)

                MenuItem {
                    text: "Delete"
                    padding: 6
                    height: implicitContentHeight + topPadding + bottomPadding
                    onTriggered: repeater.model.deleteProfile(index)
                }

                MenuItem {
                    text: "Rename"
                    padding: 6
                    height: implicitContentHeight + topPadding + bottomPadding
                    onTriggered: showRename = true
                }

                MenuItem {
                    text: "Overwrite"
                    padding: 6
                    height: implicitContentHeight + topPadding + bottomPadding
                    onTriggered: repeater.model.updateProfile(index)
                }
            }
        }
    }

    TextInput {
        id: renameInput
        text: name
        visible: showRename
        color: palette.windowText
        font.pointSize: mainWindow.font.pointSize
    }

    ImageButton {
        image: "save"
        visible: showRename
        onPressed: {
            name = renameInput.text;
            showRename = false;
        }
    }
}
