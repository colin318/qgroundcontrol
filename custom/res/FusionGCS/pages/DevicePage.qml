import QtQuick
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls

Item {
    id: root

    property var alertModel: null

    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    property var _av: QGroundControl.multiVehicleManager.activeVehicle

    readonly property string _sensorStatusText: {
        if (!_av) return "—"
        if (!_av.healthAndArmingCheckReport.supported)
            return _av.allSensorsHealthy ? qsTr("正常") : qsTr("异常")
        if (_av.healthAndArmingCheckReport.hasWarningsOrErrors)
            return qsTr("警告/错误")
        return qsTr("正常")
    }

    RowLayout {
        anchors.fill:    parent
        anchors.margins: ScreenTools.defaultFontPixelWidth
        spacing:         ScreenTools.defaultFontPixelWidth

        // Center-left: device nav + sub-cards (~55%), scrollable
        QGCFlickable {
            Layout.fillWidth:      true
            Layout.fillHeight:     true
            Layout.preferredWidth: 55
            contentHeight:         _deviceLeftCol.height
            clip:                  true

            Column {
                id:      _deviceLeftCol
                width:   parent.width
                spacing: ScreenTools.defaultFontPixelWidth

                // Device info card
                Rectangle {
                    width:  parent.width
                    height: ScreenTools.defaultFontPixelHeight * 10
                    radius: 6
                    color:  "#2c3035"

                    ColumnLayout {
                        anchors.fill:    parent
                        anchors.margins: ScreenTools.defaultFontPixelWidth * 0.75
                        spacing:         ScreenTools.defaultFontPixelHeight * 0.4

                        QGCLabel {
                            text:           qsTr("设备信息")
                            color:          "#ffffff"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
                            font.bold:      true
                        }

                        Repeater {
                            model: [
                                { label: qsTr("设备 ID"),   value: _av ? _av.id : "—" },
                                { label: qsTr("固件类型"),  value: _av ? _av.firmwareTypeString : "—" },
                                { label: qsTr("机架类型"),  value: _av ? _av.vehicleTypeString : "—" },
                                { label: qsTr("飞行模式"),  value: _av ? _av.flightMode : "—" },
                                { label: qsTr("解锁状态"),  value: _av ? (_av.armed ? qsTr("已解锁") : qsTr("已上锁")) : "—" },
                                { label: qsTr("传感器"),    value: _sensorStatusText }
                            ]
                            delegate: RowLayout {
                                Layout.fillWidth: true
                                QGCLabel { text: modelData.label; color: "#8b90a0"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7 }
                                Item { Layout.fillWidth: true }
                                QGCLabel { text: modelData.value.toString(); color: "#ffffff"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7 }
                            }
                        }
                    }
                }

                // Main device nav grid
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
                            text:           qsTr("设备中心·导航")
                            color:          "#ffffff"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
                            font.bold:      true
                        }

                        Grid {
                            Layout.fillWidth: true
                            columns:  3
                            spacing:  ScreenTools.defaultFontPixelWidth * 0.5

                            Repeater {
                                model: [
                                    qsTr("机型·车型设置"),
                                    qsTr("安装方向与标定"),
                                    qsTr("参数设置"),
                                    qsTr("遥控·手柄标定"),
                                    qsTr("电池·BMS"),
                                    qsTr("舵机·RTK·传感器"),
                                    qsTr("视频与加载"),
                                    qsTr("图像标称"),
                                    qsTr("固件与升级")
                                ]
                                delegate: Rectangle {
                                    width:  (parent.width - 2 * ScreenTools.defaultFontPixelWidth * 0.5) / 3
                                    height: ScreenTools.defaultFontPixelHeight * 3
                                    radius: 4
                                    color:  "#343a40"

                                    QGCLabel {
                                        anchors.centerIn: parent
                                        text:             modelData
                                        color:            "#adb5bd"
                                        font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.7
                                        horizontalAlignment: Text.AlignHCenter
                                        wrapMode:         Text.WordWrap
                                        width:            parent.width - 8
                                    }
                                }
                            }
                        }
                    }
                }

                // Side-by-side: mounting + RTK
                Row {
                    width:   parent.width
                    height:  ScreenTools.defaultFontPixelHeight * 10
                    spacing: ScreenTools.defaultFontPixelWidth

                    // Mounting direction card
                    Rectangle {
                        width:  (parent.width - ScreenTools.defaultFontPixelWidth) / 2
                        height: parent.height
                        radius: 6
                        color:  "#2c3035"

                        ColumnLayout {
                            anchors.fill:    parent
                            anchors.margins: ScreenTools.defaultFontPixelWidth * 0.75
                            spacing:         ScreenTools.defaultFontPixelHeight * 0.4

                            QGCLabel {
                                text:           qsTr("安装方向设置")
                                color:          "#ffffff"
                                font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
                                font.bold:      true
                            }

                            Repeater {
                                model: [
                                    { label: qsTr("机座安装"), value: qsTr("水平轴向") },
                                    { label: qsTr("侧斜"),    value: "0°" },
                                    { label: qsTr("在线"),    value: "0°" }
                                ]
                                delegate: RowLayout {
                                    Layout.fillWidth: true
                                    QGCLabel { text: modelData.label; color: "#8b90a0"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7 }
                                    Item { Layout.fillWidth: true }
                                    QGCLabel { text: modelData.value; color: "#ffffff"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7 }
                                }
                            }
                        }
                    }

                    // RTK / IMU status card
                    Rectangle {
                        id:     _rtkCard
                        width:  (parent.width - ScreenTools.defaultFontPixelWidth) / 2
                        height: parent.height
                        radius: 6
                        color:  "#2c3035"

                        readonly property bool _rtkConnected: QGroundControl.gpsRtk.connected.value

                        ColumnLayout {
                            anchors.fill:    parent
                            anchors.margins: ScreenTools.defaultFontPixelWidth * 0.75
                            spacing:         ScreenTools.defaultFontPixelHeight * 0.4

                            QGCLabel {
                                text:           qsTr("RTK / IMU 状态")
                                color:          "#ffffff"
                                font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
                                font.bold:      true
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                QGCLabel { text: qsTr("动态定位"); color: "#8b90a0"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7 }
                                Item { Layout.fillWidth: true }
                                QGCLabel { text: _av ? (_av.gps.lock.rawValue >= 5 ? qsTr("正常") : qsTr("弱")) : "—"; color: "#ffffff"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7 }
                            }
                            RowLayout {
                                Layout.fillWidth: true
                                QGCLabel { text: qsTr("RTK 连接"); color: "#8b90a0"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7 }
                                Item { Layout.fillWidth: true }
                                QGCLabel { text: _rtkCard._rtkConnected ? qsTr("已连接") : qsTr("未连接"); color: "#ffffff"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7 }
                            }
                            RowLayout {
                                Layout.fillWidth: true
                                QGCLabel { text: qsTr("RTK 精度"); color: "#8b90a0"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7 }
                                Item { Layout.fillWidth: true }
                                QGCLabel { text: _rtkCard._rtkConnected ? QGroundControl.gpsRtk.currentAccuracy.valueString : "—"; color: "#ffffff"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7 }
                            }
                            RowLayout {
                                Layout.fillWidth: true
                                QGCLabel { text: qsTr("RTK 卫星"); color: "#8b90a0"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7 }
                                Item { Layout.fillWidth: true }
                                QGCLabel { text: _rtkCard._rtkConnected ? QGroundControl.gpsRtk.numSatellites.value : "—"; color: "#ffffff"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7 }
                            }
                            RowLayout {
                                Layout.fillWidth: true
                                QGCLabel { text: qsTr("Survey-in"); color: "#8b90a0"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7 }
                                Item { Layout.fillWidth: true }
                                QGCLabel {
                                    text: _rtkCard._rtkConnected
                                          ? (QGroundControl.gpsRtk.active.value ? qsTr("进行中") : (QGroundControl.gpsRtk.valid.value ? qsTr("有效") : qsTr("未完成")))
                                          : "—"
                                    color:          "#ffffff"
                                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                                }
                            }
                        }
                    }
                }
            }
        }

        // Right column (~45%), scrollable
        QGCFlickable {
            Layout.fillHeight:     true
            Layout.fillWidth:      true
            Layout.preferredWidth: 45
            contentHeight:         _deviceRightCol.height
            clip:                  true

            Column {
                id:      _deviceRightCol
                width:   parent.width
                spacing: ScreenTools.defaultFontPixelWidth

                // Parameters & debug
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
                            text:           qsTr("参数与调试指标")
                            color:          "#ffffff"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
                            font.bold:      true
                        }

                        // Parameter ready row
                        RowLayout {
                            Layout.fillWidth: true
                            QGCLabel { text: qsTr("参数就绪"); color: "#8b90a0"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7 }
                            Item { Layout.fillWidth: true }
                            QGCLabel {
                                text:           _av ? (_av.parameterManager.parametersReady ? qsTr("是") : qsTr("否")) : "—"
                                color:          _av ? (_av.parameterManager.parametersReady ? "#27bf89" : "#f7b24a") : "#adb5bd"
                                font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                            }
                        }

                        // Parameter load progress bar
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing:          ScreenTools.defaultFontPixelHeight * 0.15

                            RowLayout {
                                Layout.fillWidth: true
                                QGCLabel { text: qsTr("加载进度"); color: "#8b90a0"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7 }
                                Item { Layout.fillWidth: true }
                                QGCLabel {
                                    text:           _av ? Math.round(_av.parameterManager.loadProgress * 100) + "%" : "—"
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
                                    width:  parent.width * (_av ? _av.parameterManager.loadProgress : 0)
                                    height: parent.height
                                    radius: 3
                                    color:  "#12b886"
                                }
                            }
                        }

                        Rectangle { Layout.fillWidth: true; height: 1; color: "#343a40" }

                        // Mock debug metrics
                        Repeater {
                            model: [
                                { label: qsTr("偏航角速度"), value: 66 },
                                { label: qsTr("俯仰角速度"), value: 72 },
                                { label: qsTr("缓慢角"),    value: 56 }
                            ]
                            delegate: ColumnLayout {
                                Layout.fillWidth: true
                                spacing:          ScreenTools.defaultFontPixelHeight * 0.15

                                RowLayout {
                                    Layout.fillWidth: true
                                    QGCLabel { text: modelData.label; color: "#8b90a0"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7 }
                                    Item { Layout.fillWidth: true }
                                    QGCLabel { text: modelData.value; color: "#ffffff"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7 }
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

                // Firmware & log card
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
                            text:           qsTr("日志与固件")
                            color:          "#ffffff"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
                            font.bold:      true
                        }

                        Repeater {
                            model: [
                                { label: qsTr("飞控固件"), value: _av ? ("v" + _av.firmwareMajorVersion + "." + _av.firmwareMinorVersion + "." + _av.firmwarePatchVersion) : "v?.?.?" },
                                { label: qsTr("地面版本"), value: "GCS-0.9 Prototype" },
                                { label: qsTr("更新日期"), value: "2026-04-14 14:21:33" }
                            ]
                            delegate: RowLayout {
                                Layout.fillWidth: true
                                QGCLabel { text: modelData.label; color: "#8b90a0"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7 }
                                Item { Layout.fillWidth: true }
                                QGCLabel { text: modelData.value; color: "#ffffff"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7; elide: Text.ElideRight }
                            }
                        }

                        Rectangle { Layout.fillWidth: true; height: 1; color: "#343a40" }

                        Grid {
                            Layout.fillWidth: true
                            columns:  2
                            spacing:  ScreenTools.defaultFontPixelWidth * 0.5

                            QGCButton {
                                width:  (parent.width - ScreenTools.defaultFontPixelWidth * 0.5) / 2
                                height: ScreenTools.defaultFontPixelHeight * 2
                                text:   qsTr("在线升级")
                                onClicked: { /* TODO: QGroundControl.corePlugin.showFirmwareUpgrade() */ }
                            }

                            QGCButton {
                                width:  (parent.width - ScreenTools.defaultFontPixelWidth * 0.5) / 2
                                height: ScreenTools.defaultFontPixelHeight * 2
                                text:   qsTr("本地升级")
                                onClicked: { }
                            }

                            Rectangle {
                                width:  (parent.width - ScreenTools.defaultFontPixelWidth * 0.5) / 2
                                height: ScreenTools.defaultFontPixelHeight * 2
                                radius: 4
                                color:  "#343a40"
                                QGCLabel {
                                    anchors.centerIn: parent
                                    text:             qsTr("下载日志")
                                    color:            "#adb5bd"
                                    font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.7
                                }
                            }

                            Rectangle {
                                width:  (parent.width - ScreenTools.defaultFontPixelWidth * 0.5) / 2
                                height: ScreenTools.defaultFontPixelHeight * 2
                                radius: 4
                                color:  "#343a40"
                                QGCLabel {
                                    anchors.centerIn: parent
                                    text:             qsTr("导出参数")
                                    color:            "#adb5bd"
                                    font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.7
                                }
                            }
                        }
                    }
                }

                // Alert card
                FusionAlertCard {
                    width:      parent.width
                    height:     ScreenTools.defaultFontPixelHeight * 18
                    alertModel: root.alertModel
                }
            }
        }
    }
}
