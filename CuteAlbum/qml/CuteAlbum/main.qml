import QtQuick 2.0
import "./effects/BookEffect"

Rectangle {
    width: 960
    height: 960
    BookEffect{
        anchors.fill: parent
        anchors.margins: 30
    }
}
