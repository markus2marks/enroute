import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15

import enroute 1.0

import "../dialogs"
import "../items"
import "../pages"

Page { // Info Menu
    id: libraryMenu
                   
    title: qsTr("Library")
    Layout.fillWidth : true
    header: StandardHeader {}
    focus: true
    ScrollView {
        id: view
        anchors.fill: parent
        anchors.topMargin: Qt.application.font.pixelSize
        focus: true
        
        ColumnLayout {
            width: libraryMenu.width
            
            ItemDelegate {
                id: aircraft
                text: qsTr("Aircraft")
                icon.source: "/icons/material/ic_airplanemode_active.svg"
                Layout.fillWidth: true
                focus: true
                KeyNavigation.down: flightRoutes
                onClicked: {
                    global.mobileAdaptor().vibrateBrief()
                    stackView.push("AircraftLibrary.qml")
                    libraryMenu.close()
                    drawer.close()
                }
                //remote control
                Keys.onPressed: {
                    if (event.key == Qt.Key_Return) 
                    { 
                        stackView.pop()
                        stackView.push("AircraftLibrary.qml")
                    } 
                    else if (event.key == Qt.Key_Left) 
                    {
                        //stackView.push("InfoMenu.qml")
                        stackView.pop()
                    }
                }
            }

            ItemDelegate {
                id: flightRoutes
                text: qsTr("Flight Routes")
                icon.source: "/icons/material/ic_directions.svg"
                Layout.fillWidth: true
                KeyNavigation.up: aircraft
                KeyNavigation.down: mapsAndData
                
                onClicked: {
                    global.mobileAdaptor().vibrateBrief()
                    stackView.push("FlightRouteLibrary.qml")
                    libraryMenu.close()
                    drawer.close()
                }
                Keys.onPressed: {
                    if (event.key == Qt.Key_Return) 
                    { 
                        stackView.pop()
                        stackView.push("FlightRouteLibrary.qml")
                    } 
                    else if (event.key == Qt.Key_Left) 
                    {
                        //stackView.push("InfoMenu.qml")
                        stackView.pop()
                    }
                }
            }


            ItemDelegate {
                id: mapsAndData
                text: qsTr("Maps and Data")
                      + (global.dataManager().geoMaps.updatable ? `<br><font color="#606060" size="2">` +qsTr("Updates available") + "</font>" : "")
                      + ( (global.navigator().flightStatus === Navigator.Flight) ? `<br><font color="#606060" size="2">` +qsTr("Item not available in flight") + "</font>" : "")
                icon.source: "/icons/material/ic_map.svg"
                Layout.fillWidth: true
                KeyNavigation.up: flightRoutes
                
                enabled: global.navigator().flightStatus !== Navigator.Flight
                onClicked: {
                    global.mobileAdaptor().vibrateBrief()
                    stackView.push("DataManager.qml")
                    libraryMenu.close()
                    drawer.close()
                }
                Keys.onPressed: {
                    if (event.key == Qt.Key_Return) 
                    { 
                        stackView.pop()
                        stackView.push("DataManager.qml")
                    } 
                    else if (event.key == Qt.Key_Left) 
                    {
                        //stackView.push("InfoMenu.qml")
                        stackView.pop()
                    }
                }
            }
        }      
    }
    Keys.onPressed: 
    {
        event.accepted = true
        if (event.key == Qt.Key_Left) {
            //stackView.push("InfoMenu.qml")
            stackView.pop()
        }
    } 
}
                    