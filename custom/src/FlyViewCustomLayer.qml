import QtQuick
import QtQuick.Controls

import QGroundControl
import QGroundControl.Controls

import FusionGCS 1.0

Item {
    property var parentToolInsets
    property var totalToolInsets:  _totalToolInsets
    property var mapControl

    QGCToolInsets {
        id: _totalToolInsets
        leftEdgeTopInset:       parentToolInsets.leftEdgeTopInset
        leftEdgeCenterInset:    parentToolInsets.leftEdgeCenterInset
        leftEdgeBottomInset:    parentToolInsets.leftEdgeBottomInset
        rightEdgeTopInset:      parentToolInsets.rightEdgeTopInset
        rightEdgeCenterInset:   parentToolInsets.rightEdgeCenterInset
        rightEdgeBottomInset:   parentToolInsets.rightEdgeBottomInset
        topEdgeLeftInset:       parentToolInsets.topEdgeLeftInset
        topEdgeCenterInset:     parentToolInsets.topEdgeCenterInset
        topEdgeRightInset:      parentToolInsets.topEdgeRightInset
        bottomEdgeLeftInset:    parentToolInsets.bottomEdgeLeftInset
        bottomEdgeCenterInset:  parentToolInsets.bottomEdgeCenterInset
        bottomEdgeRightInset:   parentToolInsets.bottomEdgeRightInset
    }

    Loader {
        id: fusionLoader
        anchors.fill: parent
        active:       FusionPlugin.fusionDashboardVisible
        z:            100
        sourceComponent: FusionDashboard { }
    }
}
