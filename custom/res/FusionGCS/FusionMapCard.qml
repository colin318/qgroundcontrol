import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtLocation
import QtPositioning

import QGroundControl
import QGroundControl.Controls
import QGroundControl.FlightMap 1.0

Item {
    id: root

    property int    pageIndex:   0
    property int    currentPage: 0
    property string cardTitle:   qsTr("地图")

    property var _av: QGroundControl.multiVehicleManager.activeVehicle

    // Map type state: 0 = Satellite, 1 = Hybrid, 2 = Street
    property int _mapTypeIndex: 0

    readonly property var _mapTypeNames: [qsTr("卫星"), qsTr("混合"), qsTr("常规")]
    readonly property var _mapTypeKeys:  ["Satellite", "Hybrid", "Road"]

    function _applyMapType(idx) {
        _mapTypeIndex = idx
        var settings = QGroundControl.settingsManager.flightMapSettings
        settings.mapType.value = _mapTypeKeys[idx]
    }

    Rectangle {
        anchors.fill: parent
        color:        "#2c3035"
        radius:       6
    }

    ColumnLayout {
        anchors.fill:    parent
        anchors.margins: 4
        spacing:         0

        // Top bar: title + mode chips
        RowLayout {
            Layout.fillWidth: true
            height:           ScreenTools.defaultFontPixelHeight * 2
            spacing:          ScreenTools.defaultFontPixelWidth * 0.5

            QGCLabel {
                text:           root.cardTitle
                color:          "#ffffff"
                font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
                font.bold:      true
                leftPadding:    ScreenTools.defaultFontPixelWidth * 0.5
            }

            Item { Layout.fillWidth: true }

            // View mode chips (cosmetic)
            Row {
                spacing: ScreenTools.defaultFontPixelWidth * 0.25
                Repeater {
                    model: [qsTr("2D地图"), qsTr("多机态势")]
                    delegate: Rectangle {
                        width:  modeText.width + ScreenTools.defaultFontPixelWidth * 1.2
                        height: ScreenTools.defaultFontPixelHeight * 1.4
                        radius: 3
                        color:  index === 0 ? "#12b886" : "#343a40"

                        QGCLabel {
                            id:             modeText
                            anchors.centerIn: parent
                            text:           modelData
                            color:          "#ffffff"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                        }
                    }
                }
            }

            // Map type chips (functional)
            Row {
                spacing: ScreenTools.defaultFontPixelWidth * 0.25
                Repeater {
                    model: _mapTypeNames
                    delegate: Rectangle {
                        width:  satText.width + ScreenTools.defaultFontPixelWidth * 1.2
                        height: ScreenTools.defaultFontPixelHeight * 1.4
                        radius: 3
                        color:  _mapTypeIndex === index ? "#12b886" : "#343a40"

                        QGCLabel {
                            id:             satText
                            anchors.centerIn: parent
                            text:           modelData
                            color:          _mapTypeIndex === index ? "#ffffff" : "#adb5bd"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked:    root._applyMapType(index)
                        }
                    }
                }
            }
        }

        // Map loader — active only when this page is current
        Loader {
            id:              mapLoader
            Layout.fillWidth:  true
            Layout.fillHeight: true
            asynchronous:    true
            active:          root.pageIndex === root.currentPage
            sourceComponent: _mapComponent

            Rectangle {
                anchors.fill: parent
                color:        "#1a1c1f"
                visible:      mapLoader.status !== Loader.Ready

                QGCLabel {
                    anchors.centerIn: parent
                    text:             mapLoader.status === Loader.Loading
                                      ? qsTr("地图加载中…") : qsTr("地图未激活")
                    color:            "#8b90a0"
                    font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.8
                }
            }
        }

        // Bottom bar: 4 telemetry values
        Rectangle {
            Layout.fillWidth: true
            height:           ScreenTools.defaultFontPixelHeight * 2.8
            color:            "#212529"
            radius:           4

            RowLayout {
                anchors.fill:    parent
                anchors.margins: ScreenTools.defaultFontPixelWidth * 0.5
                spacing:         0

                Repeater {
                    model: [
                        { label: qsTr("高度"),  value: _av ? _av.altitudeRelative.value.toFixed(1) + " m"   : "—" },
                        { label: qsTr("速度"),  value: _av ? _av.groundSpeed.value.toFixed(1)      + " m/s" : "—" },
                        { label: qsTr("航程"),  value: _av ? _av.distanceToHome.value.toFixed(0)   + " m"   : "—" },
                        { label: qsTr("航向"),  value: _av ? _av.heading.value.toFixed(0)          + "°"    : "—" }
                    ]
                    delegate: ColumnLayout {
                        Layout.fillWidth: true
                        spacing:          0

                        QGCLabel {
                            Layout.alignment: Qt.AlignHCenter
                            text:           modelData.value
                            color:          "#ffffff"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
                            font.bold:      true
                        }
                        QGCLabel {
                            Layout.alignment: Qt.AlignHCenter
                            text:           modelData.label
                            color:          "#8b90a0"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                        }
                    }
                }
            }
        }
    }

    Component {
        id: _mapComponent

        FlightMap {
            mapName:                   "FusionMap_" + root.pageIndex
            allowGCSLocationCenter:    true
            allowVehicleLocationCenter: true

            // Multi-vehicle nodes
            MapItemView {
                model: QGroundControl.multiVehicleManager.vehicles
                delegate: MapQuickItem {
                    coordinate:   object.coordinate
                    anchorPoint:  Qt.point(vehicleDot.width / 2, vehicleDot.height / 2)
                    sourceItem: Rectangle {
                        id:     vehicleDot
                        width:  ScreenTools.defaultFontPixelWidth * 1.5
                        height: width
                        radius: width / 2
                        color:  "#12b886"
                        border.color: "#ffffff"
                        border.width: 2
                    }
                }
            }

            // Hub-spoke lines from activeVehicle to others
            MapItemView {
                model: QGroundControl.multiVehicleManager.activeVehicle
                       ? QGroundControl.multiVehicleManager.vehicles : null
                delegate: MapPolyline {
                    path: [
                        QGroundControl.multiVehicleManager.activeVehicle
                            ? QGroundControl.multiVehicleManager.activeVehicle.coordinate
                            : QtPositioning.coordinate(),
                        object.coordinate
                    ]
                    line.color: "#ffffff44"
                    line.width: 1
                }
            }
        }
    }
}
