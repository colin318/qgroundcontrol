import QtQuick
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls

Rectangle {
    id: root

    property var vehicle: null

    height:  ScreenTools.defaultFontPixelHeight * 4.5
    radius:  4
    color:   "#2c3035"

    property string _linkStatus: {
        if (!vehicle) return qsTr("Weak Link")
        const lock = vehicle.gps.lock.rawValue
        if (lock >= 6) return qsTr("RTK Fixed")
        if (lock >= 5) return qsTr("RTK Float")
        if (lock >= 3) return qsTr("3D Lock")
        return qsTr("Weak Link")
    }
    property color _linkColor: {
        if (!vehicle) return "#e03131"
        const lock = vehicle.gps.lock.rawValue
        if (lock >= 6) return "#27bf89"
        if (lock >= 5) return "#f7b24a"
        if (lock >= 3) return "#f7b24a"
        return "#e03131"
    }
    property int _battPct: {
        if (!vehicle) return 0
        if (vehicle.batteries.count > 0)
            return Math.round(vehicle.batteries.get(0).percentRemaining.value)
        return 0
    }
    property bool _isUAV: vehicle ? vehicle.multiRotor : true

    ColumnLayout {
        anchors.fill:    parent
        anchors.margins: ScreenTools.defaultFontPixelWidth * 0.75
        spacing:         ScreenTools.defaultFontPixelHeight * 0.2

        RowLayout {
            Layout.fillWidth: true
            spacing:          ScreenTools.defaultFontPixelWidth * 0.5

            QGCLabel {
                text:           vehicle ? ("UAV-0" + vehicle.id) : qsTr("无载具")
                color:          "#ffffff"
                font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
                font.bold:      true
            }

            Rectangle {
                width:  typeLabel.width + ScreenTools.defaultFontPixelWidth
                height: ScreenTools.defaultFontPixelHeight * 1.1
                radius: 3
                color:  _isUAV ? "#1971c2" : "#2f9e44"

                QGCLabel {
                    id:             typeLabel
                    anchors.centerIn: parent
                    text:           _isUAV ? "UAV" : "UGV"
                    color:          "#ffffff"
                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                }
            }

            Item { Layout.fillWidth: true }

            Rectangle {
                width:  linkLabel.width + ScreenTools.defaultFontPixelWidth * 0.8
                height: ScreenTools.defaultFontPixelHeight
                radius: 3
                color:  "transparent"
                border.color: _linkColor
                border.width: 1

                QGCLabel {
                    id:             linkLabel
                    anchors.centerIn: parent
                    text:           _linkStatus
                    color:          _linkColor
                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
                }
            }
        }

        // Battery bar
        RowLayout {
            Layout.fillWidth: true
            spacing:          ScreenTools.defaultFontPixelWidth * 0.5

            QGCLabel {
                text:           _battPct + "%"
                color:          "#adb5bd"
                font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.7
            }

            Rectangle {
                Layout.fillWidth: true
                height:           ScreenTools.defaultFontPixelHeight * 0.6
                radius:           3
                color:            "#495057"

                Rectangle {
                    width:  parent.width * (_battPct / 100.0)
                    height: parent.height
                    radius: 3
                    color:  _battPct > 50 ? "#27bf89" : (_battPct > 20 ? "#f7b24a" : "#e1544c")
                }
            }
        }
    }
}
