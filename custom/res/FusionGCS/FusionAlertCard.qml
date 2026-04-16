import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls

Item {
    id: root

    property var alertModel: null
    readonly property bool _hasRealAlerts: alertModel !== null && alertModel.rowCount() > 0

    property var _av: QGroundControl.multiVehicleManager.activeVehicle
    readonly property var _report: _av ? _av.healthAndArmingCheckReport : null

    // Mock alerts for dev preview
    ListModel {
        id: _mockAlertModel
        ListElement { vehicleId: 1; severity: 2; alertText: "电池电压过低，请尽快返航" }
        ListElement { vehicleId: 3; severity: 4; alertText: "GPS 信号弱，切换至惯性导航" }
        ListElement { vehicleId: 1; severity: 5; alertText: "任务航点 3 已到达" }
        ListElement { vehicleId: 2; severity: 3; alertText: "遥控器信号丢失 2 秒" }
        ListElement { vehicleId: 4; severity: 1; alertText: "IMU 校准异常，建议重新校准" }
    }

    Rectangle {
        anchors.fill: parent
        color:        "#2c3035"
        radius:       6
    }

    ColumnLayout {
        anchors.fill:    parent
        anchors.margins: ScreenTools.defaultFontPixelWidth * 0.75
        spacing:         ScreenTools.defaultFontPixelHeight * 0.25

        // Header
        RowLayout {
            Layout.fillWidth: true

            QGCLabel {
                text:           qsTr("告警中心")
                color:          "#ffffff"
                font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
                font.bold:      true
            }

            Item { Layout.fillWidth: true }

            Rectangle {
                visible: alertModel && alertModel.unreadCount > 0
                width:   unreadLabel.width + ScreenTools.defaultFontPixelWidth * 1.2
                height:  ScreenTools.defaultFontPixelHeight * 1.2
                radius:  3
                color:   "#c92a2a"

                QGCLabel {
                    id:             unreadLabel
                    anchors.centerIn: parent
                    text:           (alertModel ? alertModel.unreadCount : 0) + qsTr(" 条未读")
                    color:          "#ffffff"
                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked:    { if (alertModel) alertModel.resetUnread() }
                }
            }
        }

        Rectangle { Layout.fillWidth: true; height: 1; color: "#343a40" }

        // Alert list
        ListView {
            Layout.fillWidth:  true
            Layout.fillHeight: true
            model:             _hasRealAlerts ? root.alertModel : _mockAlertModel
            clip:              true
            spacing:           ScreenTools.defaultFontPixelHeight * 0.25

            delegate: Rectangle {
                width:   ListView.view.width
                height:  ScreenTools.defaultFontPixelHeight * 2.5
                radius:  4
                color:   "#212529"

                RowLayout {
                    anchors.fill:    parent
                    anchors.margins: ScreenTools.defaultFontPixelWidth * 0.5
                    spacing:         ScreenTools.defaultFontPixelWidth * 0.5

                    QGCLabel {
                        text:           "V-" + vehicleId
                        color:          "#12b886"
                        font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                        font.bold:      true
                    }

                    Rectangle {
                        width:  sevLabel.width + ScreenTools.defaultFontPixelWidth * 0.8
                        height: ScreenTools.defaultFontPixelHeight * 1.1
                        radius: 3
                        color: {
                            if (severity <= 2) return "#c92a2a"
                            if (severity <= 4) return "#e67700"
                            return "#495057"
                        }

                        QGCLabel {
                            id:             sevLabel
                            anchors.centerIn: parent
                            text: {
                                if (severity <= 2) return qsTr("严重")
                                if (severity <= 4) return qsTr("常规")
                                return qsTr("已讯")
                            }
                            color:          "#ffffff"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                        }
                    }

                    QGCLabel {
                        Layout.fillWidth: true
                        text:             alertText
                        color:            "#adb5bd"
                        font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.7
                        elide:            Text.ElideRight
                    }
                }
            }
        }

        // HealthAndArmingCheck section
        ColumnLayout {
            Layout.fillWidth: true
            spacing:          ScreenTools.defaultFontPixelHeight * 0.2
            visible:          _report && _report.supported

            Rectangle { Layout.fillWidth: true; height: 1; color: "#343a40" }

            QGCLabel {
                text:           qsTr("解锁检查")
                color:          "#ffffff"
                font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.8
                font.bold:      true
            }

            RowLayout {
                Layout.fillWidth: true
                spacing:          ScreenTools.defaultFontPixelWidth * 0.5

                QGCLabel {
                    text:           qsTr("可解锁")
                    color:          "#8b90a0"
                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                }
                Item { Layout.fillWidth: true }
                QGCLabel {
                    text:           _report ? (_report.canArm ? qsTr("是") : qsTr("否")) : "—"
                    color:          _report ? (_report.canArm ? "#27bf89" : "#e1544c") : "#adb5bd"
                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing:          ScreenTools.defaultFontPixelWidth * 0.5

                QGCLabel {
                    text:           qsTr("可起飞")
                    color:          "#8b90a0"
                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                }
                Item { Layout.fillWidth: true }
                QGCLabel {
                    text:           _report ? (_report.canTakeoff ? qsTr("是") : qsTr("否")) : "—"
                    color:          _report ? (_report.canTakeoff ? "#27bf89" : "#e1544c") : "#adb5bd"
                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing:          ScreenTools.defaultFontPixelWidth * 0.5

                QGCLabel {
                    text:           qsTr("有警告/错误")
                    color:          "#8b90a0"
                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                }
                Item { Layout.fillWidth: true }
                QGCLabel {
                    text:           _report ? (_report.hasWarningsOrErrors ? qsTr("是") : qsTr("否")) : "—"
                    color:          _report ? (_report.hasWarningsOrErrors ? "#e67700" : "#27bf89") : "#adb5bd"
                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                }
            }

            Repeater {
                model: _report ? _report.problemsForCurrentMode : null
                delegate: Rectangle {
                    Layout.fillWidth: true
                    height:           ScreenTools.defaultFontPixelHeight * 2.2
                    radius:           3
                    color:            "#343a40"

                    RowLayout {
                        anchors.fill:    parent
                        anchors.margins: ScreenTools.defaultFontPixelWidth * 0.5
                        spacing:         ScreenTools.defaultFontPixelWidth * 0.5

                        Rectangle {
                            width:  sevProbLabel.width + ScreenTools.defaultFontPixelWidth * 0.8
                            height: ScreenTools.defaultFontPixelHeight * 1.1
                            radius: 3
                            color:  object.severity === "error" ? "#c92a2a" : "#e67700"

                            QGCLabel {
                                id:             sevProbLabel
                                anchors.centerIn: parent
                                text:           object.severity
                                color:          "#ffffff"
                                font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.6
                            }
                        }

                        QGCLabel {
                            Layout.fillWidth: true
                            text:             object.message
                            color:            "#adb5bd"
                            font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.7
                            elide:            Text.ElideRight
                        }
                    }
                }
            }
        }
    }
}
