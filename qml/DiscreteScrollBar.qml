import QtQuick
import QtQuick.Controls

ScrollBar {
    property color bgColor: palette.window;

    policy: size >= 1 ? ScrollBar.AlwaysOff : ScrollBar.AlwaysOn

    contentItem: Rectangle {
        implicitWidth: 10
        implicitHeight: 10
        color: Universal.theme == Universal.Dark ? palette.window.lighter(1.75) : palette.window.darker(1.25)
    }

    background: Rectangle {
        implicitWidth: 10
        implicitHeight: 10
        color: bgColor
    }
}
