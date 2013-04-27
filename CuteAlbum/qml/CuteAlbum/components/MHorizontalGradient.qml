// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 2.0

Item {
    property alias gradient: horizGradient.gradient
    property alias rotation: horizGradient.rotation
    Rectangle {
        id: horizGradient
        width: parent.height
        height: parent.width
        anchors.centerIn: parent
        rotation: 270
    }
}
