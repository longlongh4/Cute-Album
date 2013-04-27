import QtQuick 2.0
import "../../components"
Item {
    id:pageObj
    width: parent.width/2
    height: parent.height
    property int index: 0
    x:index%2===0? 0:parent.width/2
    Rectangle {
        id:pageRect
        anchors.fill: parent
        Text {
            id: name
            anchors.centerIn: parent
            font.pixelSize: 60
            text: index
        }
        MHorizontalGradient{
            height: parent.height
            width: 20
            rotation: index%2===0? 270:90
            anchors.right: index%2===0? parent.right:undefined
            anchors.left: index%2===0? undefined : parent.left
            gradient: Gradient {
                id: gradLeft
                GradientStop { position: 0.0; color: "#00000000" }
                GradientStop { position: 0.9; color: "#80000000" }
                GradientStop { position: 1.0; color: "#c0000000" }
            }
        }
        // shine
        MHorizontalGradient {
            width: parent.width
            height: parent.height
            rotation: index % 2 == 0 ? 270 : 90;

            gradient: Gradient {
                GradientStop { position: 0.0; color: "lightgrey" }
                GradientStop { position: 0.5; color: "#00ffffff" }
                GradientStop { position: 0.8; color: "white" }
                GradientStop { position: 1.0; color: "#00ffffff" }
            }
        }
    }
}
