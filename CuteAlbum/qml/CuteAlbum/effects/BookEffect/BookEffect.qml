// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 2.0

Item{
    id:container

    BookEffectPage {id: bookpage;
        width: parent.width/2;
        height: parent.height
        index:2}
    BookEffectPage {id: bookpage2;
        width: parent.width/2;
        height: parent.height
        index:3
    }

    property real rotationOriginX: 0

    MouseArea{
        anchors.fill: parent
        onClicked: {
            leftToRightAnimation.complete();
            rightToLeftAnimation.complete();
            if(mouseX<parent.width/2)
            {
                shaderEffectItem.flipDirection = 0;
                leftToRightAnimation.start();
            }
            else
            {
                shaderEffectItem.flipDirection = 1;
                rightToLeftAnimation.start();
            }
        }
    }

    ShaderEffect {
        id:shaderEffectItem
        width: parent.width/2
        height: parent.height
        mesh: GridMesh {
            resolution: Qt.size(10, 15)
        }

        property variant frontSource: ShaderEffectSource {sourceItem: bookpage;}
        property variant backSource: ShaderEffectSource {sourceItem: bookpage2;}
        property real t: 0

        property real rotation_origin_x: container.rotationOriginX
        property int flipDirection: 0 //0 stands for left to right and 1 stands for right to left

        NumberAnimation {
            id:leftToRightAnimation
            target: shaderEffectItem
            properties: "t"
            from: 0.0
            to: 1.0
            duration: 800
        }

        NumberAnimation {
            id:rightToLeftAnimation
            target: shaderEffectItem
            properties: "t"
            from: 1.0
            to: 0.0
            duration: 800
        }

        vertexShader:"
        uniform highp mat4 qt_Matrix;
        attribute highp vec4 qt_Vertex;
        attribute highp vec2 qt_MultiTexCoord0;
        varying highp vec2 qt_TexCoord0;
        uniform highp float t;
        uniform highp float rotation_origin_x;
        uniform lowp int flipDirection;
        void main() {
            const float M_PI = 3.14159265358979323846;
            const float RAD = 180.0 / M_PI;
            float rho = t*M_PI;
            float theta;
            float A;

            float f1,f2,dt;
            float k = 1.2;
            float angle1 =  90.0 / RAD;
            float angle2 =   8.0 / RAD;
            float angle3 =   6.0 / RAD;
            float     A1 =  -15.0*k;
            float     A2 =  -2.5*k;
            float     A3 =  -3.5*k;
            float theta1 =  0.05;
            float theta2 =   0.5;
            float theta3 =  10.0;
            float theta4 =   2.0;

            float R, r ,beta;

            if( t <= 0.15 )
            {
                dt = t / 0.15;
                f1 = sin(M_PI*pow(dt,theta1) / 2.0);
                f2 = sin(M_PI*pow(dt,theta2) / 2.0);
                theta = mix(angle1,angle2,f1);
                A = mix(A1,A2,f2);
            }
            else if(t<= 0.4)
            {
                dt = (t-0.15)/0.25;
                theta = mix(angle2,angle3,dt);
                A = mix(A2,A3,dt);
            }
            else
            {
                dt = (t-0.4) / 0.6;
                f1 = sin(M_PI * pow(dt,theta3)/2.0);
                f2 = sin(M_PI * pow(dt,theta4)/2.0);
                theta = mix(angle3,angle1,f1);
                A = mix(A3,A1,f2);
            }
                qt_TexCoord0 = qt_MultiTexCoord0;
                highp vec4 pos = qt_Matrix * qt_Vertex;
                R = sqrt(pos.x*pos.x + (pos.y-A)*(pos.y-A));
                r = R * sin(theta);
                beta = asin(pos.x / R) / sin(theta);

                highp vec4 v1 = pos;
                v1.x = r*sin(beta);
                v1.y = R+A-r*(1.0-cos(beta))*sin(theta);
                v1.z = r*(1.0-cos(beta))*cos(theta);
                if(flipDirection==0)
                {
                    pos.x = v1.x*cos(rho)-v1.z*sin(rho);
                    pos.z = v1.x*sin(rho)+v1.z*cos(rho);
                }
                else
                {
                    pos.x = v1.x*cos(rho)+v1.z*sin(rho);
                    pos.z = v1.x*sin(rho)-v1.z*cos(rho);
                }

                pos.y = v1.y;
                gl_Position =  pos;
            }"
        fragmentShader: "
            uniform sampler2D frontSource;
            uniform sampler2D backSource;
            uniform lowp float qt_Opacity;
            varying highp vec2 qt_TexCoord0;
            varying lowp float shade;
            void main() {
                vec2 backSourceTexCoord;
                backSourceTexCoord.x = 1.0-qt_TexCoord0.x;
                backSourceTexCoord.y = qt_TexCoord0.y;
                gl_FragColor = texture2D(frontSource, qt_TexCoord0);
//                gl_FragColor = (gl_FrontFacing ? texture2D(frontSource, qt_TexCoord0)
//                                               : texture2D(backSource, backSourceTexCoord)) * qt_Opacity;
            }
        "
    }
}
