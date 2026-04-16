import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls

Item {
    id: root

    property int currentPage: 0
    signal navigate(int index)

    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    property var _pageNames: [
        qsTr("总览首页"),
        qsTr("实时控制"),
        qsTr("任务规划"),
        qsTr("设备中心"),
        qsTr("集群协网")
    ]

    property var _av: QGroundControl.multiVehicleManager.activeVehicle
    readonly property bool _hasVehicles: QGroundControl.multiVehicleManager.vehicles.count > 0

    // Mock vehicles for dev preview
    readonly property var _mockSidebarVehicles: [
        { name: "UAV-01", type: "UAV", status: "RTK Fixed", batt: 87 },
        { name: "UAV-02", type: "UAV", status: "GPS 3D",    batt: 72 },
        { name: "UGV-01", type: "UGV", status: "RTK Float", batt: 93 }
    ]

    Rectangle {
        anchors.fill: parent
        color:        "#212529"
    }

    ColumnLayout {
        anchors.fill:   parent
        anchors.margins: ScreenTools.defaultFontPixelWidth * 0.75
        spacing:         0

        // Brand area
        Item {
            Layout.fillWidth: true
            height:           ScreenTools.defaultFontPixelHeight * 4

            Column {
                anchors.centerIn: parent
                width:            parent.width
                spacing:          ScreenTools.defaultFontPixelHeight * 0.3

                QGCLabel {
                    text:                qsTr("Fusion GCS")
                    color:               "#12b886"
                    font.pixelSize:      ScreenTools.defaultFontPixelHeight * 1.1
                    font.bold:           true
                    horizontalAlignment: Text.AlignHCenter
                    width:               parent.width
                }
                QGCLabel {
                    text:                qsTr("UAV / UGV 通用地面站")
                    color:               "#8b90a0"
                    font.pixelSize:      ScreenTools.defaultFontPixelHeight * 0.75
                    horizontalAlignment: Text.AlignHCenter
                    width:               parent.width
                    elide:               Text.ElideRight
                }
            }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: "#343a40" }

        // Navigation items
        Repeater {
            model: _pageNames
            delegate: Item {
                Layout.fillWidth: true
                height:           ScreenTools.defaultFontPixelHeight * 2.4

                Rectangle {
                    anchors.fill: parent
                    color:        root.currentPage === index ? "#2c3035" : "transparent"
                    radius:       4
                }
                Rectangle {
                    visible: root.currentPage === index
                    width:   3
                    height:  parent.height * 0.6
                    color:   "#12b886"
                    radius:  2
                    anchors.left:           parent.left
                    anchors.verticalCenter: parent.verticalCenter
                }
                QGCLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left:           parent.left
                    anchors.leftMargin:     ScreenTools.defaultFontPixelWidth * 1.2
                    text:      modelData
                    color:     root.currentPage === index ? "#12b886" : "#adb5bd"
                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.8
                    font.bold: root.currentPage === index
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked:    root.navigate(index)
                }
            }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: "#343a40"; Layout.topMargin: 4 }

        // Online vehicles header
        Item {
            Layout.fillWidth: true
            height:           ScreenTools.defaultFontPixelHeight * 2

            QGCLabel {
                anchors.left:           parent.left
                anchors.verticalCenter: parent.verticalCenter
                text:   qsTr("在线设备")
                color:  "#8b90a0"
                font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7 * 1.2
            }
            Rectangle {
                anchors.right:          parent.right
                anchors.verticalCenter: parent.verticalCenter
                width:  onlineBadge.width + ScreenTools.defaultFontPixelWidth
                height: ScreenTools.defaultFontPixelHeight * 1.2
                radius: height / 2
                color:  "#12b886"

                QGCLabel {
                    id: onlineBadge
                    anchors.centerIn: parent
                    text: _hasVehicles
                          ? (QGroundControl.multiVehicleManager.vehicles.count + "/" +
                             QGroundControl.multiVehicleManager.vehicles.count)
                          : (_mockSidebarVehicles.length + "/" + _mockSidebarVehicles.length)
                    color: "#ffffff"
                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7 * 1.1
                    font.bold: true
                }
            }
        }

        // Vehicle cards scroll
        ScrollView {
            Layout.fillWidth:  true
            Layout.fillHeight: true
            clip:              true
            contentWidth:      availableWidth

            Column {
                width:   parent.width
                spacing: ScreenTools.defaultFontPixelHeight * 0.4

                // Real vehicles
                Repeater {
                    model: _hasVehicles ? QGroundControl.multiVehicleManager.vehicles : null
                    delegate: FusionVehicleCard {
                        width:   parent.width
                        vehicle: object
                    }
                }

                // Mock vehicles (dev preview)
                Repeater {
                    model: _hasVehicles ? null : _mockSidebarVehicles
                    delegate: Rectangle {
                        width:  parent.width
                        height: ScreenTools.defaultFontPixelHeight * 4
                        radius: 4
                        color:  "#2c3035"

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
                                    width:  stLabel.width + ScreenTools.defaultFontPixelWidth * 0.8
                                    height: ScreenTools.defaultFontPixelHeight
                                    radius: 3
                                    color:  modelData.type === "UAV" ? "#1971c2" : "#2f9e44"
                                    QGCLabel {
                                        id: stLabel; anchors.centerIn: parent
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
