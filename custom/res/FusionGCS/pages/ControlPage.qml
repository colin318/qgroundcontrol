import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls

import FusionGCS 1.0

Item {
    id:          root
    property int currentPage: 0

    readonly property int _pageIndex: 1

    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    property var _av: QGroundControl.multiVehicleManager.activeVehicle

    RowLayout {
        anchors.fill:    parent
        anchors.margins: ScreenTools.defaultFontPixelWidth
        spacing:         ScreenTools.defaultFontPixelWidth

        // Left column — scrollable
        QGCFlickable {
            Layout.fillHeight: true
            width:             ScreenTools.defaultFontPixelWidth * 22
            contentHeight:     _controlLeftCol.height
            clip:              true

            Column {
                id:      _controlLeftCol
                width:   parent.width
                spacing: ScreenTools.defaultFontPixelWidth

                // Payload type card
                Rectangle {
                    width:  parent.width
                    height: ScreenTools.defaultFontPixelHeight * 5
                    radius: 6
                    color:  "#2c3035"

                    ColumnLayout {
                        anchors.fill:    parent
                        anchors.margins: ScreenTools.defaultFontPixelWidth * 0.75
                        spacing:         ScreenTools.defaultFontPixelHeight * 0.25

                        QGCLabel {
                            text:           qsTr("载荷平台类型")
                            color:          "#ffffff"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
                            font.bold:      true
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing:          ScreenTools.defaultFontPixelWidth * 0.5

                            Repeater {
                                model: ["UAV", "UGV"]
                                delegate: Rectangle {
                                    Layout.fillWidth: true
                                    height:           ScreenTools.defaultFontPixelHeight * 2
                                    radius:           4
                                    color:            index === 0 ? "#12b886" : "#343a40"

                                    QGCLabel {
                                        anchors.centerIn: parent
                                        text:             modelData
                                        color:            "#ffffff"
                                        font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.8
                                        font.bold:        index === 0
                                    }
                                }
                            }
                        }
                    }
                }

                // Video card
                Rectangle {
                    width:  parent.width
                    height: ScreenTools.defaultFontPixelHeight * 22
                    radius: 6
                    color:  "#2c3035"

                    ColumnLayout {
                        anchors.fill:    parent
                        anchors.margins: ScreenTools.defaultFontPixelWidth * 0.75
                        spacing:         ScreenTools.defaultFontPixelHeight * 0.25

                        QGCLabel {
                            text:           qsTr("实时视频")
                            color:          "#ffffff"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
                            font.bold:      true
                        }

                        Rectangle {
                            Layout.fillWidth:  true
                            Layout.fillHeight: true
                            color:             "#1a1c1f"
                            radius:            4

                            QGCLabel {
                                anchors.centerIn: parent
                                text:             qsTr("视频窗口")
                                color:            "#495057"
                                font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.85
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing:          ScreenTools.defaultFontPixelWidth * 0.5

                            Repeater {
                                model: [qsTr("广角"), qsTr("变焦"), qsTr("抓拍")]
                                delegate: Rectangle {
                                    Layout.fillWidth: true
                                    height:           ScreenTools.defaultFontPixelHeight * 1.8
                                    radius:           4
                                    color:            "#343a40"

                                    QGCLabel {
                                        anchors.centerIn: parent
                                        text:             modelData
                                        color:            "#adb5bd"
                                        font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.7
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // Center: map (≥55% of available width after left column)
        FusionMapCard {
            Layout.fillHeight: true
            Layout.fillWidth:  true
            pageIndex:         _pageIndex
            currentPage:       root.currentPage
            cardTitle:         qsTr("地图与任务态势")
        }

        // Right column — scrollable when window is small
        QGCFlickable {
            Layout.fillHeight: true
            width:             ScreenTools.defaultFontPixelWidth * 22
            contentHeight:     _controlRightCol.height
            clip:              true

            Column {
                id:      _controlRightCol
                width:   parent.width
                spacing: ScreenTools.defaultFontPixelWidth

                // Core operations
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
                            text:           qsTr("核心操作")
                            color:          "#ffffff"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
                            font.bold:      true
                        }

                        Grid {
                            Layout.fillWidth: true
                            columns:  2
                            spacing:  ScreenTools.defaultFontPixelWidth * 0.5

                            Repeater {
                                model: [qsTr("解锁/起飞"), qsTr("悬停"), qsTr("返航"), qsTr("执行任务")]
                                delegate: Rectangle {
                                    width:  (parent.width - ScreenTools.defaultFontPixelWidth * 0.5) / 2
                                    height: ScreenTools.defaultFontPixelHeight * 2.2
                                    radius: 4
                                    color:  index === 0 ? "#12b886" : "#343a40"

                                    QGCLabel {
                                        anchors.centerIn: parent
                                        text:             modelData
                                        color:            "#ffffff"
                                        font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.7
                                    }
                                }
                            }
                        }
                    }
                }

                // Manual control assist
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
                            text:           qsTr("手动控制辅助")
                            color:          "#ffffff"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
                            font.bold:      true
                        }

                        Grid {
                            Layout.fillWidth: true
                            columns:  3
                            spacing:  ScreenTools.defaultFontPixelWidth * 0.4

                            Repeater {
                                model: [qsTr("俯仰/横滚"), qsTr("右转"), qsTr("左转"),
                                        qsTr("上升/加速"), qsTr("减速"), qsTr("下降/减速")]
                                delegate: Rectangle {
                                    width:  (parent.width - 2 * ScreenTools.defaultFontPixelWidth * 0.4) / 3
                                    height: ScreenTools.defaultFontPixelHeight * 2
                                    radius: 4
                                    color:  "#343a40"

                                    QGCLabel {
                                        anchors.centerIn: parent
                                        text:             modelData
                                        color:            "#adb5bd"
                                        font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.7
                                    }
                                }
                            }
                        }
                    }
                }

                // Status monitor
                Rectangle {
                    width:  parent.width
                    height: ScreenTools.defaultFontPixelHeight * 14
                    radius: 6
                    color:  "#2c3035"

                    ColumnLayout {
                        anchors.fill:    parent
                        anchors.margins: ScreenTools.defaultFontPixelWidth * 0.75
                        spacing:         ScreenTools.defaultFontPixelHeight * 0.4

                        QGCLabel {
                            text:           qsTr("状态监控")
                            color:          "#ffffff"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
                            font.bold:      true
                        }

                        Repeater {
                            model: [
                                { label: qsTr("电量"),        value: (_av && _av.batteries.count > 0)
                                                                      ? Math.round(_av.batteries.get(0).percentRemaining.value) : 0 },
                                { label: qsTr("GNSS·RTK"),   value: _av ? Math.min(100, _av.gps.count.rawValue * 10) : 0 },
                                { label: qsTr("链路质量"),    value: _av ? Math.max(0, _av.telemetryLRSSI + 100) : 0 },
                                { label: qsTr("视频链路"),    value: 69 }
                            ]
                            delegate: ColumnLayout {
                                Layout.fillWidth: true
                                spacing:          ScreenTools.defaultFontPixelHeight * 0.15

                                RowLayout {
                                    Layout.fillWidth: true

                                    QGCLabel {
                                        text:           modelData.label
                                        color:          "#adb5bd"
                                        font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                                    }
                                    Item { Layout.fillWidth: true }
                                    QGCLabel {
                                        text:           modelData.value + "%"
                                        color:          "#ffffff"
                                        font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                                    }
                                }

                                Rectangle {
                                    Layout.fillWidth: true
                                    height:           ScreenTools.defaultFontPixelHeight * 0.5
                                    radius:           3
                                    color:            "#495057"

                                    Rectangle {
                                        width:  parent.width * (modelData.value / 100.0)
                                        height: parent.height
                                        radius: 3
                                        color:  "#12b886"
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
