import QtQuick
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls

Item {
    id: root
    property int currentPageIndex: 0
    property var alertModel: null

    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    property var _pageNames: [
        qsTr("总览首页"),
        qsTr("实时控制"),
        qsTr("任务规划"),
        qsTr("设备中心"),
        qsTr("集群协网")
    ]

    property var _av: QGroundControl.multiVehicleManager.activeVehicle

    Rectangle {
        anchors.fill: parent
        color:        "#212529"
    }

    RowLayout {
        anchors.fill:    parent
        anchors.margins: ScreenTools.defaultFontPixelWidth
        spacing:         ScreenTools.defaultFontPixelWidth * 2

        // Left: title
        Column {
            spacing: ScreenTools.defaultFontPixelHeight * 0.15

            QGCLabel {
                text:           qsTr("通用地面站控制平台")
                color:          "#ffffff"
                font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.9
                font.bold:      true
            }
            Row {
                spacing: ScreenTools.defaultFontPixelWidth * 0.5

                Rectangle {
                    width:  protoLabel.width + ScreenTools.defaultFontPixelWidth
                    height: ScreenTools.defaultFontPixelHeight * 1.1
                    radius: 3
                    color:  "#495057"
                    anchors.verticalCenter: parent.verticalCenter

                    QGCLabel {
                        id: protoLabel
                        anchors.centerIn: parent
                        text:             "Prototype"
                        color:            "#adb5bd"
                        font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.7
                    }
                }
                QGCLabel {
                    text:           _pageNames[root.currentPageIndex]
                    color:          "#8b90a0"
                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        Item { Layout.fillWidth: true }

        // Right: status chips
        Row {
            spacing: ScreenTools.defaultFontPixelWidth

            // Link quality chip
            FusionChip {
                label: _av ? (Math.max(0, _av.telemetryLRSSI + 100) > 60 ? qsTr("链路良好") : qsTr("链路弱")) : qsTr("无链路")
                chipColor: _av ? (Math.max(0, _av.telemetryLRSSI + 100) > 60 ? "#2f9e44" : "#e67700") : "#868e96"
            }

            // Battery chip
            FusionChip {
                label: (_av && _av.batteries.count > 0)
                       ? (_av.batteries.get(0).percentRemaining.value.toFixed(0) + qsTr("% 电量"))
                       : qsTr("无电量")
                chipColor: "#1971c2"
            }

            // Alert chip (unread count)
            FusionChip {
                label: (alertModel && alertModel.unreadCount > 0)
                       ? (alertModel.unreadCount + qsTr(" 条告警"))
                       : qsTr("无告警")
                chipColor: (alertModel && alertModel.unreadCount > 0) ? "#c92a2a" : "#495057"
                MouseArea {
                    anchors.fill: parent
                    onClicked:    { if (alertModel) alertModel.resetUnread() }
                }
            }

            // Video chip
            FusionChip {
                label:     qsTr("视频在线")
                chipColor: "#0c8599"
            }
        }
    }

    // inline helper component — private to this file
    component FusionChip : Rectangle {
        property string label
        property color  chipColor: "#495057"

        width:  chipText.width + ScreenTools.defaultFontPixelWidth * 1.5
        height: ScreenTools.defaultFontPixelHeight * 1.4
        radius: 3
        color:  chipColor

        QGCLabel {
            id:             chipText
            anchors.centerIn: parent
            text:           label
            color:          "#ffffff"
            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
        }
    }
}
