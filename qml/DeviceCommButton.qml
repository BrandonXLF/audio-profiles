import QtQuick
import QtQuick.Layouts

ImageButton {
    Layout.alignment: Qt.AlignVCenter
    image: "qrc:/images/" + (defaultComm ? "phone-green.svg" : "phone.svg")
    onPressed: defaultComm = true
}
