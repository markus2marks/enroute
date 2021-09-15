import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15

import "../items"

Page { // Info Menu
    id: infomenu
                   
    title: qsTr("Informations")
    Layout.fillWidth : true
    header: StandardHeader {}
    ScrollView {
        id: view
        anchors.fill: parent
        anchors.topMargin: Qt.application.font.pixelSize
        
        ColumnLayout {
             width: infomenu.width
            
            ItemDelegate { // Sat Status
                text: qsTr("Positioning")
                      +`<br><font color="#606060" size="2">`
                      + (positionProvider.receivingPositionInfo ? qsTr("Receiving position information.") : qsTr("Not receiving position information."))
                      + `</font>`
                icon.source: "/icons/material/ic_satellite.svg"
                Layout.fillWidth: true
                onClicked: {
                    global.mobileAdaptor().vibrateBrief()
                    stackView.pop()
                    stackView.push("pages/Positioning.qml")
                    aboutMenu.close()
                    drawer.close()
                }
                background: Rectangle {
                    anchors.fill: parent
                    color: positionProvider.receivingPositionInfo ? "green" : "red"
                    opacity: 0.2
                }
            }

            ItemDelegate { // FLARM Status
                Layout.fillWidth: true

                text: qsTr("Traffic Receiver")
                      + `<br><font color="#606060" size="2">`
                      + ((global.trafficDataProvider().receivingHeartbeat) ? qsTr("Receiving traffic data.") : qsTr("Not receiving traffic data."))
                      + `</font>`
                icon.source: "/icons/material/ic_airplanemode_active.svg"
                onClicked: {
                    global.mobileAdaptor().vibrateBrief()
                    stackView.pop()
                    stackView.push("pages/TrafficReceiver.qml")
                    aboutMenu.close()
                    drawer.close()
                }
                background: Rectangle {
                    anchors.fill: parent
                    color: (global.trafficDataProvider().receivingHeartbeat) ? "green" : "red"
                    opacity: 0.2
                }
            }

            Rectangle {
                height: 1
                Layout.fillWidth: true
                color: Material.primary
            }

            ItemDelegate { // About
                text: qsTr("About Enroute Flight Navigation")
                icon.source: "/icons/material/ic_info_outline.svg"
                Layout.fillWidth: true
                
                onClicked: {
                    global.mobileAdaptor().vibrateBrief()
                    stackView.pop()
                    stackView.push("pages/InfoPage.qml")
                    aboutMenu.close()
                    drawer.close()
                }
            }

            ItemDelegate { // Participate
                text: qsTr("Participate")
                icon.source: "/icons/nav_participate.svg"
                icon.color: Material.primary
                Layout.fillWidth: true
                
                onClicked: {
                    global.mobileAdaptor().vibrateBrief()
                    stackView.pop()
                    stackView.push("pages/ParticipatePage.qml")
                    aboutMenu.close()
                    drawer.close()
                }
            }

            ItemDelegate { // Donate
                text: qsTr("Donate")
                icon.source: "/icons/material/ic_attach_money.svg"
                Layout.fillWidth: true
                
                onClicked: {
                    global.mobileAdaptor().vibrateBrief()
                    stackView.pop()
                    stackView.push("pages/DonatePage.qml")
                    aboutMenu.close()
                    drawer.close()
                }
            }
       }      
    }
}
                    