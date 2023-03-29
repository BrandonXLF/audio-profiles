import QtQuick
import QtQuick.Layouts

ImageButton {
    Layout.alignment: Qt.AlignVCenter
    image: defaultComm ? "phone-green" : "phone"
    onPressed: defaultComm = true
}
