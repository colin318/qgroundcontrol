import QtQuick
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls

import FusionGCS 1.0

Item {
    id: root
    anchors.fill: parent

    FusionStatusTextModel { id: _sharedAlertModel }

    Rectangle {
        anchors.fill: parent
        color:        "#1a1c1f"
    }

    RowLayout {
        anchors.fill: parent
        spacing:      0

        FusionSidebar {
            Layout.fillHeight: true
            width:             ScreenTools.defaultFontPixelWidth * 22
            currentPage:       pageStack.currentIndex
            onNavigate:        (idx) => { FusionPlugin.fusionPage = idx }
        }

        ColumnLayout {
            Layout.fillWidth:  true
            Layout.fillHeight: true
            spacing:           0

            FusionTopBar {
                Layout.fillWidth: true
                height:           ScreenTools.defaultFontPixelHeight * 3.5
                currentPageIndex: pageStack.currentIndex
                alertModel:       _sharedAlertModel
            }

            StackLayout {
                id:                    pageStack
                Layout.fillWidth:      true
                Layout.fillHeight:     true
                currentIndex:          FusionPlugin.fusionPage

                OverviewPage  { currentPage: pageStack.currentIndex; alertModel: _sharedAlertModel }

                Loader {
                    id: controlLoader
                    active: pageStack.currentIndex === 1
                    sourceComponent: Component {
                        ControlPage {
                            width:       controlLoader.width
                            height:      controlLoader.height
                            currentPage: pageStack.currentIndex
                        }
                    }
                }
                Loader {
                    id: missionLoader
                    active: pageStack.currentIndex === 2
                    sourceComponent: Component {
                        MissionPage {
                            width:       missionLoader.width
                            height:      missionLoader.height
                            currentPage: pageStack.currentIndex
                        }
                    }
                }
                Loader {
                    id: deviceLoader
                    active: pageStack.currentIndex === 3
                    sourceComponent: Component {
                        DevicePage {
                            width:      deviceLoader.width
                            height:     deviceLoader.height
                            alertModel: _sharedAlertModel
                        }
                    }
                }
                Loader {
                    id: analyticsLoader
                    active: pageStack.currentIndex === 4
                    sourceComponent: Component {
                        AnalyticsPage {
                            width:       analyticsLoader.width
                            height:      analyticsLoader.height
                            currentPage: pageStack.currentIndex
                        }
                    }
                }
            }
        }
    }

    // Return to QGC button
    Rectangle {
        anchors.right:        parent.right
        anchors.bottom:       parent.bottom
        anchors.margins:      ScreenTools.defaultFontPixelWidth
        width:                ScreenTools.defaultFontPixelWidth * 12
        height:               ScreenTools.defaultFontPixelHeight * 2
        radius:               4
        color:                "#343a40"
        z:                    200

        QGCLabel {
            anchors.centerIn: parent
            text:             qsTr("返回 QGC")
            color:            "#ffffff"
            font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.75
        }

        MouseArea {
            anchors.fill: parent
            onClicked:    FusionPlugin.fusionDashboardVisible = false
        }
    }
}
