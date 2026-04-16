import QtQuick
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls

import FusionGCS 1.0

Item {
    id:          root
    property int currentPage: 0

    readonly property int _pageIndex: 4

    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    property var _av: QGroundControl.multiVehicleManager.activeVehicle
    readonly property bool _hasVehicles: QGroundControl.multiVehicleManager.vehicles.count > 0

    // Mock vehicle list for dev preview
    readonly property var _mockVehicles: [
        { name: "UAV-01", type: "UAV", status: "RTK Fixed", batt: 87 },
        { name: "UAV-02", type: "UAV", status: "GPS 3D",    batt: 72 },
        { name: "UGV-01", type: "UGV", status: "RTK Float", batt: 93 },
        { name: "UAV-03", type: "UAV", status: "RTK Fixed", batt: 65 },
        { name: "UAV-04", type: "UAV", status: "GPS 3D",    batt: 54 },
        { name: "UGV-02", type: "UGV", status: "RTK Fixed", batt: 81 }
    ]

    RowLayout {
        anchors.fill:    parent
        anchors.margins: ScreenTools.defaultFontPixelWidth
        spacing:         ScreenTools.defaultFontPixelWidth

        // Left: device list
        Rectangle {
            Layout.fillHeight: true
            width:             ScreenTools.defaultFontPixelWidth * 22
            radius:            6
            color:             "#2c3035"

            ColumnLayout {
                anchors.fill:    parent
                anchors.margins: ScreenTools.defaultFontPixelWidth * 0.75
                spacing:         ScreenTools.defaultFontPixelHeight * 0.4

                RowLayout {
                    Layout.fillWidth: true

                    QGCLabel {
                        text:           qsTr("设备列表")
                        color:          "#ffffff"
                        font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
                        font.bold:      true
                    }
                    Item { Layout.fillWidth: true }
                    Rectangle {
                        width:  countLabel.width + ScreenTools.defaultFontPixelWidth
                        height: ScreenTools.defaultFontPixelHeight * 1.2
                        radius: height / 2
                        color:  "#12b886"

                        QGCLabel {
                            id:             countLabel
                            anchors.centerIn: parent
                            text:           _hasVehicles
                                            ? (QGroundControl.multiVehicleManager.vehicles.count + "/" +
                                               QGroundControl.multiVehicleManager.vehicles.count)
                                            : (_mockVehicles.length + "/" + _mockVehicles.length)
                            color:          "#ffffff"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                            font.bold:      true
                        }
                    }
                }

                // Real vehicles or mock list
                QGCFlickable {
                    Layout.fillWidth:  true
                    Layout.fillHeight: true
                    contentHeight:     _deviceListCol.height
                    clip:              true

                    Column {
                        id:      _deviceListCol
                        width:   parent.width
                        spacing: ScreenTools.defaultFontPixelHeight * 0.4

                        // Real vehicles
                        Repeater {
                            model: _hasVehicles ? QGroundControl.multiVehicleManager.vehicles : null
                            delegate: FusionVehicleCard {
                                width:   _deviceListCol.width
                                vehicle: object
                            }
                        }

                        // Mock vehicles (dev preview)
                        Repeater {
                            model: _hasVehicles ? null : _mockVehicles
                            delegate: Rectangle {
                                width:  _deviceListCol.width
                                height: ScreenTools.defaultFontPixelHeight * 4
                                radius: 4
                                color:  "#343a40"

                                ColumnLayout {
                                    anchors.fill:    parent
                                    anchors.margins: ScreenTools.defaultFontPixelWidth * 0.5
                                    spacing:         ScreenTools.defaultFontPixelHeight * 0.15

                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: ScreenTools.defaultFontPixelWidth * 0.5

                                        QGCLabel {
                                            text:           modelData.name
                                            color:          "#ffffff"
                                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.75
                                            font.bold:      true
                                        }
                                        Rectangle {
                                            width:  tLabel.width + ScreenTools.defaultFontPixelWidth * 0.8
                                            height: ScreenTools.defaultFontPixelHeight
                                            radius: 3
                                            color:  modelData.type === "UAV" ? "#1971c2" : "#2f9e44"
                                            QGCLabel {
                                                id: tLabel; anchors.centerIn: parent
                                                text: modelData.type; color: "#ffffff"
                                                font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.6
                                            }
                                        }
                                        Item { Layout.fillWidth: true }
                                        QGCLabel {
                                            text:           modelData.status
                                            color:          modelData.status === "RTK Fixed" ? "#27bf89" : "#f7b24a"
                                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.6
                                        }
                                    }
                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: ScreenTools.defaultFontPixelWidth * 0.5
                                        QGCLabel {
                                            text: modelData.batt + "%"; color: "#adb5bd"
                                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.6
                                        }
                                        Rectangle {
                                            Layout.fillWidth: true
                                            height: ScreenTools.defaultFontPixelHeight * 0.5
                                            radius: 3; color: "#495057"
                                            Rectangle {
                                                width: parent.width * (modelData.batt / 100.0)
                                                height: parent.height; radius: 3
                                                color: modelData.batt > 50 ? "#27bf89" : (modelData.batt > 20 ? "#f7b24a" : "#e1544c")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // Center: cluster task map
        FusionMapCard {
            Layout.fillHeight: true
            Layout.fillWidth:  true
            pageIndex:         _pageIndex
            currentPage:       root.currentPage
            cardTitle:         qsTr("集群任务布局")
        }

        // Right column: 批量操作 + 协同规则
        QGCFlickable {
            Layout.fillHeight:     true
            Layout.fillWidth:      true
            Layout.maximumWidth:   ScreenTools.defaultFontPixelWidth * 22
            contentHeight:         _clusterRightCol.height
            clip:                  true

            Column {
                id:      _clusterRightCol
                width:   parent.width
                spacing: ScreenTools.defaultFontPixelWidth

                // 批量操作 card
                Rectangle {
                    width:  parent.width
                    height: ScreenTools.defaultFontPixelHeight * 12
                    radius: 6
                    color:  "#2c3035"

                    ColumnLayout {
                        anchors.fill:    parent
                        anchors.margins: ScreenTools.defaultFontPixelWidth * 0.75
                        spacing:         ScreenTools.defaultFontPixelHeight * 0.4

                        QGCLabel {
                            text:           qsTr("批量操作")
                            color:          "#ffffff"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
                            font.bold:      true
                        }

                        Grid {
                            Layout.fillWidth:  true
                            Layout.fillHeight: true
                            columns:  2
                            spacing:  ScreenTools.defaultFontPixelWidth * 0.5

                            Repeater {
                                model: [
                                    { label: qsTr("批量起飞"), accent: true },
                                    { label: qsTr("批量降落"), accent: true },
                                    { label: qsTr("批量返航"), accent: false },
                                    { label: qsTr("批量悬停"), accent: false },
                                    { label: qsTr("编队集结"), accent: false },
                                    { label: qsTr("紧急制动"), accent: false }
                                ]
                                delegate: Rectangle {
                                    width:  (parent.width - ScreenTools.defaultFontPixelWidth * 0.5) / 2
                                    height: ScreenTools.defaultFontPixelHeight * 2.2
                                    radius: 4
                                    color:  modelData.accent ? "#12b886" : "#343a40"

                                    QGCLabel {
                                        anchors.centerIn: parent
                                        text:             modelData.label
                                        color:            "#ffffff"
                                        font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.7
                                    }
                                }
                            }
                        }
                    }
                }

                // 协同规则 card
                Rectangle {
                    width:  parent.width
                    height: ScreenTools.defaultFontPixelHeight * 16
                    radius: 6
                    color:  "#2c3035"

                    ColumnLayout {
                        anchors.fill:    parent
                        anchors.margins: ScreenTools.defaultFontPixelWidth * 0.75
                        spacing:         ScreenTools.defaultFontPixelHeight * 0.4

                        QGCLabel {
                            text:           qsTr("协同规则")
                            color:          "#ffffff"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
                            font.bold:      true
                        }

                        Repeater {
                            model: [
                                { label: qsTr("编队模式"),   value: qsTr("V 字编队") },
                                { label: qsTr("队形间距"),   value: "15 m" },
                                { label: qsTr("通信协议"),   value: "MAVLink v2" },
                                { label: qsTr("避障策略"),   value: qsTr("自动绕行") },
                                { label: qsTr("任务分配"),   value: qsTr("负载均衡") },
                                { label: qsTr("失联策略"),   value: qsTr("自动返航") },
                                { label: qsTr("协同频率"),   value: "10 Hz" }
                            ]
                            delegate: Rectangle {
                                Layout.fillWidth: true
                                height:           ScreenTools.defaultFontPixelHeight * 2
                                radius:           4
                                color:            "#343a40"
                                border.color:     "#495057"
                                border.width:     1

                                RowLayout {
                                    anchors.fill:    parent
                                    anchors.margins: ScreenTools.defaultFontPixelWidth * 0.5
                                    spacing:         ScreenTools.defaultFontPixelWidth * 0.5

                                    QGCLabel {
                                        text:           modelData.label
                                        color:          "#8b90a0"
                                        font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                                    }
                                    Item { Layout.fillWidth: true }
                                    QGCLabel {
                                        text:           modelData.value
                                        color:          "#ffffff"
                                        font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
