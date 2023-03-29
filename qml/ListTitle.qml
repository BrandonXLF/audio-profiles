import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Label {
    property string titleText;

    text: titleText
    font.pointSize: 16
    Layout.fillWidth: true
    Layout.columnSpan: 4
    Layout.topMargin: 4
}
