import QtQuick
import QtQuick.Controls

import QGroundControl
import QGroundControl.Controls

Rectangle {
    id: root

    width:  ScreenTools.defaultFontPixelWidth * 10
    height: ScreenTools.defaultFontPixelHeight * 2.2
    radius: 4
    color:  _pressed ? "#0ca678" : (_hovered ? "#0ca678" : "#12b886")

    property bool showIndicator: true
    property bool _hovered: false
    property bool _pressed: false

    Component.onCompleted: console.warn("[Fusion] FusionToolBarButton loaded, visible=", visible, "width=", width, "height=", height)

    QGCLabel {
        anchors.centerIn: parent
        text:             qsTr("Fusion GCS")
        color:            "#ffffff"
        font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.85
        font.bold:        true
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered:    root._hovered = true
        onExited:     root._hovered = false
        onPressed:    root._pressed = true
        onReleased:   root._pressed = false
        onClicked:    FusionPlugin.fusionDashboardVisible = !FusionPlugin.fusionDashboardVisible
    }
}
