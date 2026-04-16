import QtQuick
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls

import FusionGCS 1.0

Item {
    id:          root
    property int currentPage: 0

    readonly property int _pageIndex: 2

    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    property var _av: QGroundControl.multiVehicleManager.activeVehicle
    readonly property bool _hasWaypoints: missionModel.waypointCoordinates.length > 0

    FusionMissionModel { id: missionModel }

    // Mock waypoints for dev preview
    readonly property var _mockWaypoints: [
        { lat: 30.57281, lon: 104.06583 },
        { lat: 30.57395, lon: 104.06721 },
        { lat: 30.57512, lon: 104.06498 },
        { lat: 30.57448, lon: 104.06352 },
        { lat: 30.57320, lon: 104.06410 }
    ]

    RowLayout {
        anchors.fill:    parent
        anchors.margins: ScreenTools.defaultFontPixelWidth
        spacing:         ScreenTools.defaultFontPixelWidth

        // Left column — scrollable
        QGCFlickable {
            Layout.fillHeight: true
            width:             ScreenTools.defaultFontPixelWidth * 22
            contentHeight:     _missionLeftCol.height
            clip:              true

            Column {
                id:      _missionLeftCol
                width:   parent.width
                spacing: ScreenTools.defaultFontPixelWidth

                // Mission mode card
                Rectangle {
                    width:  parent.width
                    height: ScreenTools.defaultFontPixelHeight * 11
                    radius: 6
                    color:  "#2c3035"

                    ColumnLayout {
                        anchors.fill:    parent
                        anchors.margins: ScreenTools.defaultFontPixelWidth * 0.75
                        spacing:         ScreenTools.defaultFontPixelHeight * 0.4

                        QGCLabel {
                            text:           qsTr("任务模式")
                            color:          "#ffffff"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
                            font.bold:      true
                        }

                        Repeater {
                            model: [
                                { title: qsTr("AI 规划"),   sub: qsTr("智能路径规划") },
                                { title: qsTr("多点导航"),   sub: qsTr("多航点任务") },
                                { title: qsTr("自由巡航"),   sub: qsTr("手动路线飞行") },
                                { title: qsTr("UGV 联动"),  sub: qsTr("地面车协同") }
                            ]
                            delegate: Rectangle {
                                Layout.fillWidth: true
                                height:           ScreenTools.defaultFontPixelHeight * 2
                                radius:           4
                                color:            index === 0 ? "#1a3a2e" : "#343a40"
                                border.color:     index === 0 ? "#12b886" : "transparent"
                                border.width:     1

                                RowLayout {
                                    anchors.fill:    parent
                                    anchors.margins: ScreenTools.defaultFontPixelWidth * 0.5
                                    spacing:         ScreenTools.defaultFontPixelWidth * 0.5

                                    QGCLabel {
                                        text:           modelData.title
                                        color:          index === 0 ? "#12b886" : "#adb5bd"
                                        font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.75
                                        font.bold:      index === 0
                                    }
                                    QGCLabel {
                                        text:           modelData.sub
                                        color:          "#8b90a0"
                                        font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                                    }
                                }
                            }
                        }
                    }
                }

                // Waypoint attributes card
                Rectangle {
                    width:  parent.width
                    height: ScreenTools.defaultFontPixelHeight * 15
                    radius: 6
                    color:  "#2c3035"

                    ColumnLayout {
                        anchors.fill:    parent
                        anchors.margins: ScreenTools.defaultFontPixelWidth * 0.75
                        spacing:         ScreenTools.defaultFontPixelHeight * 0.4

                        QGCLabel {
                            text:           qsTr("航点属性")
                            color:          "#ffffff"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
                            font.bold:      true
                        }

                        Repeater {
                            model: [
                                { label: qsTr("高度"),   value: missionModel.currentWaypointAltitude },
                                { label: qsTr("速度"),   value: missionModel.currentWaypointSpeed },
                                { label: qsTr("动作"),   value: qsTr("空中悬停") },
                                { label: qsTr("航向"),   value: qsTr("自动跟随") },
                                { label: qsTr("悬停时间"), value: "3s" }
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

        // Center: map
        FusionMapCard {
            Layout.fillHeight: true
            Layout.fillWidth:  true
            pageIndex:         _pageIndex
            currentPage:       root.currentPage
            cardTitle:         qsTr("地图规划区")
        }

        // Right column — scrollable
        QGCFlickable {
            Layout.fillHeight: true
            width:             ScreenTools.defaultFontPixelWidth * 22
            contentHeight:     _missionRightCol.height
            clip:              true

            Column {
                id:      _missionRightCol
                width:   parent.width
                spacing: ScreenTools.defaultFontPixelWidth

                // Waypoint list
                Rectangle {
                    width:  parent.width
                    height: ScreenTools.defaultFontPixelHeight * 18
                    radius: 6
                    color:  "#2c3035"

                    ColumnLayout {
                        anchors.fill:    parent
                        anchors.margins: ScreenTools.defaultFontPixelWidth * 0.75
                        spacing:         ScreenTools.defaultFontPixelHeight * 0.25

                        QGCLabel {
                            text:           qsTr("航点列表")
                            color:          "#ffffff"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
                            font.bold:      true
                        }

                        ListView {
                            Layout.fillWidth:  true
                            Layout.fillHeight: true
                            model:             _hasWaypoints ? missionModel.waypointCoordinates : _mockWaypoints
                            clip:              true
                            spacing:           ScreenTools.defaultFontPixelHeight * 0.25

                            delegate: Rectangle {
                                width:   ListView.view.width
                                height:  ScreenTools.defaultFontPixelHeight * 2
                                radius:  4
                                color:   "#343a40"

                                RowLayout {
                                    anchors.fill:    parent
                                    anchors.margins: ScreenTools.defaultFontPixelWidth * 0.5
                                    spacing:         ScreenTools.defaultFontPixelWidth * 0.5

                                    QGCLabel {
                                        text:           index + 1
                                        color:          "#12b886"
                                        font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                                        font.bold:      true
                                    }
                                    QGCLabel {
                                        Layout.fillWidth: true
                                        text: {
                                            if (_hasWaypoints) {
                                                const c = missionModel.waypointCoordinates[index]
                                                return c ? (c.latitude.toFixed(5) + ", " + c.longitude.toFixed(5)) : "—"
                                            }
                                            return modelData.lat.toFixed(5) + ", " + modelData.lon.toFixed(5)
                                        }
                                        color:          "#adb5bd"
                                        font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                                        elide:          Text.ElideRight
                                    }
                                }
                            }
                        }
                    }
                }

                // Mission operations
                Rectangle {
                    width:  parent.width
                    height: ScreenTools.defaultFontPixelHeight * 10
                    radius: 6
                    color:  "#2c3035"

                    ColumnLayout {
                        anchors.fill:    parent
                        anchors.margins: ScreenTools.defaultFontPixelWidth * 0.75
                        spacing:         ScreenTools.defaultFontPixelHeight * 0.25

                        QGCLabel {
                            text:           qsTr("任务操作")
                            color:          "#ffffff"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
                            font.bold:      true
                        }

                        Grid {
                            Layout.fillWidth: true
                            columns:  2
                            spacing:  ScreenTools.defaultFontPixelWidth * 0.5

                            Repeater {
                                model: [qsTr("上传任务"), qsTr("执行任务"), qsTr("暂停任务"), qsTr("激活任务")]
                                delegate: Rectangle {
                                    width:  (parent.width - ScreenTools.defaultFontPixelWidth * 0.5) / 2
                                    height: ScreenTools.defaultFontPixelHeight * 2.2
                                    radius: 4
                                    color:  index < 2 ? "#12b886" : "#343a40"

                                    QGCLabel {
                                        anchors.centerIn: parent
                                        text:             modelData
                                        color:            "#ffffff"
                                        font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.7
                                    }
                                }
                            }
                        }

                        // Edit mission — jumps back to native PlanView
                        Rectangle {
                            Layout.fillWidth: true
                            height:           ScreenTools.defaultFontPixelHeight * 2.2
                            radius:           4
                            color:            "#1971c2"

                            QGCLabel {
                                anchors.centerIn: parent
                                text:             qsTr("编辑任务（跳转原生 PlanView）")
                                color:            "#ffffff"
                                font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.7
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked:    FusionPlugin.fusionDashboardVisible = false
                            }
                        }
                    }
                }
            }
        }
    }
}
