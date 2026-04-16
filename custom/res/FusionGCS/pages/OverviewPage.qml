import QtQuick
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls

import FusionGCS 1.0

Item {
    id:          root
    property int currentPage: 0
    property var alertModel: null

    readonly property int _pageIndex: 0

    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    property var _av: QGroundControl.multiVehicleManager.activeVehicle

    // Use real data when vehicles present, mock data for dev preview
    readonly property bool _hasVehicles: QGroundControl.multiVehicleManager.vehicles.count > 0
    property int _onlineCount:  _hasVehicles ? QGroundControl.multiVehicleManager.vehicles.count : 12
    property int _missionCount: {
        if (!_hasVehicles) return 5
        let n = 0
        const vs = QGroundControl.multiVehicleManager.vehicles
        for (let i = 0; i < vs.count; i++) {
            if (vs.get(i).missionManager.inProgress) n++
        }
        return n
    }
    property real _avgHealth: {
        if (!_hasVehicles) return 87
        const vs = QGroundControl.multiVehicleManager.vehicles
        let sum = 0
        for (let i = 0; i < vs.count; i++) {
            const v = vs.get(i)
            if (v.batteries.count > 0)
                sum += v.batteries.get(0).percentRemaining.value
        }
        return sum / vs.count
    }

    ColumnLayout {
        anchors.fill:    parent
        anchors.margins: ScreenTools.defaultFontPixelWidth
        spacing:         ScreenTools.defaultFontPixelWidth

        // KPI cards row — fixed height strip, never grows
        RowLayout {
            Layout.fillWidth:      true
            Layout.preferredHeight: ScreenTools.defaultFontPixelHeight * 5
            Layout.maximumHeight:   ScreenTools.defaultFontPixelHeight * 5
            spacing:               ScreenTools.defaultFontPixelWidth

            Repeater {
                model: [
                    { title: qsTr("在线设备"),  value: _onlineCount,            sub: qsTr("今日离线: 0") },
                    { title: qsTr("执行中任务"), value: _missionCount,           sub: "1/10/3" },
                    { title: qsTr("设备数量"),  value: _onlineCount,            sub: qsTr("1产品") },
                    { title: qsTr("平均健康度"), value: _avgHealth.toFixed(0) + "%", sub: qsTr("月平均") }
                ]
                delegate: Rectangle {
                    Layout.fillWidth:  true
                    Layout.fillHeight: true
                    radius:  6
                    color:   "#2c3035"

                    Column {
                        anchors.centerIn: parent
                        spacing:          ScreenTools.defaultFontPixelHeight * 0.15

                        QGCLabel {
                            text:           modelData.value.toString()
                            color:          "#12b886"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.5
                            font.bold:      true
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        QGCLabel {
                            text:           modelData.title
                            color:          "#ffffff"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.75
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        QGCLabel {
                            text:           modelData.sub
                            color:          "#8b90a0"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }
        }

        // Main content row
        RowLayout {
            Layout.fillWidth:  true
            Layout.fillHeight: true
            spacing:           ScreenTools.defaultFontPixelWidth

            // Center: map (~60% of remaining width)
            FusionMapCard {
                Layout.fillHeight:     true
                Layout.fillWidth:      true
                Layout.preferredWidth: 3   // stretch factor 3 vs 2
                pageIndex:   _pageIndex
                currentPage: root.currentPage
                cardTitle:   qsTr("全局态势")
            }

            // Right column: 3 cards (~40% of remaining width), scrollable
            QGCFlickable {
                Layout.fillWidth:      true
                Layout.fillHeight:     true
                Layout.preferredWidth: 2   // stretch factor 2 vs 3
                contentHeight:         _overviewRightCol.height
                clip:                  true

                Column {
                    id:      _overviewRightCol
                    width:   parent.width
                    spacing: ScreenTools.defaultFontPixelWidth

                    // Focused vehicle card
                    Rectangle {
                        width:  parent.width
                        height: ScreenTools.defaultFontPixelHeight * 8
                        radius: 6
                        color:  "#2c3035"

                        ColumnLayout {
                            anchors.fill:    parent
                            anchors.margins: ScreenTools.defaultFontPixelWidth * 0.75
                            spacing:         ScreenTools.defaultFontPixelHeight * 0.25

                            RowLayout {
                                Layout.fillWidth: true

                                QGCLabel {
                                    text:           qsTr("聚焦中设备")
                                    color:          "#ffffff"
                                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
                                    font.bold:      true
                                }
                                Item { Layout.fillWidth: true }
                                Rectangle {
                                    width:  idLabel.width + ScreenTools.defaultFontPixelWidth
                                    height: ScreenTools.defaultFontPixelHeight * 1.2
                                    radius: 3
                                    color:  "#1971c2"
                                    QGCLabel {
                                        id:             idLabel
                                        anchors.centerIn: parent
                                        text:           _av ? ("UAV-0" + _av.id) : "UAV-01"
                                        color:          "#ffffff"
                                        font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                                    }
                                }
                            }

                            Repeater {
                                model: [
                                    { label: qsTr("类型"),  value: _av ? (_av.multiRotor ? qsTr("无人机") : qsTr("无人车")) : qsTr("无人机") },
                                    { label: qsTr("状态"),  value: _av ? (_av.gps.lock.rawValue >= 6 ? "RTK Fixed" : "GPS 3D") : "RTK Fixed" },
                                    { label: qsTr("电量"),  value: (_av && _av.batteries.count > 0)
                                                                    ? (_av.batteries.get(0).percentRemaining.value.toFixed(0) + "%") : "87%" }
                                ]
                                delegate: RowLayout {
                                    Layout.fillWidth: true
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

                            // Battery bar
                            Rectangle {
                                Layout.fillWidth: true
                                height:           ScreenTools.defaultFontPixelHeight * 0.6
                                radius:           3
                                color:            "#495057"
                                property int _pct: (_av && _av.batteries.count > 0)
                                                   ? Math.round(_av.batteries.get(0).percentRemaining.value) : 87
                                Rectangle {
                                    width:  parent.width * (parent._pct / 100.0)
                                    height: parent.height
                                    radius: 3
                                    color:  parent._pct > 50 ? "#27bf89" : (parent._pct > 20 ? "#f7b24a" : "#e1544c")
                                }
                            }
                        }
                    }

                    // Quick workbench card
                    Rectangle {
                        width:  parent.width
                        height: ScreenTools.defaultFontPixelHeight * 8
                        radius: 6
                        color:  "#2c3035"

                        ColumnLayout {
                            anchors.fill:    parent
                            anchors.margins: ScreenTools.defaultFontPixelWidth * 0.75
                            spacing:         ScreenTools.defaultFontPixelHeight * 0.25

                            QGCLabel {
                                text:           qsTr("快捷工作台")
                                color:          "#ffffff"
                                font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
                                font.bold:      true
                            }

                            Grid {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                columns:  3
                                spacing:  ScreenTools.defaultFontPixelWidth * 0.5

                                Repeater {
                                    model: [qsTr("一键起飞"), qsTr("任务调度"), qsTr("视频巡查"),
                                            qsTr("参数设置"), qsTr("编队控制"), qsTr("安全维护")]
                                    delegate: Rectangle {
                                        width:  (parent.width - 2 * ScreenTools.defaultFontPixelWidth * 0.5) / 3
                                        height: ScreenTools.defaultFontPixelHeight * 2
                                        radius: 4
                                        color:  "#343a40"

                                        QGCLabel {
                                            anchors.centerIn: parent
                                            text:           modelData
                                            color:          "#adb5bd"
                                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Alert card
                    FusionAlertCard {
                        width:      parent.width
                        height:     ScreenTools.defaultFontPixelHeight * 12
                        alertModel: root.alertModel
                    }
                }
            }
        }
    }
}
