import QtQuick
import QtQuick.Layouts

ImageButton {
    Layout.alignment: Qt.AlignVCenter
    image: defaultMain ? "check-green" : "check"
    onPressed: defaultMain = true
}
