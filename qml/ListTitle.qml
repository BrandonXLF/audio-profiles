import QtQuick
import QtQuick.Layouts

Text {
    property string titleText;

    text: titleText
    font.pointSize: 16
    Layout.fillWidth: true
    Layout.columnSpan: 4
    Layout.topMargin: 4
}
