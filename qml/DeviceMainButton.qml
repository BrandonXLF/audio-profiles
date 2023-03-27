import QtQuick
import QtQuick.Layouts

ImageButton {
    Layout.alignment: Qt.AlignVCenter
    image: "qrc:/images/" + (defaultMain ? "check-green.svg" : "check.svg")
    onPressed: defaultMain = true
}
