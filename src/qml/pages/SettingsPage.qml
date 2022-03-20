/***************************************************************************
 *   Copyright (C) 2019-2021 by Stefan Kebekus                             *
 *   stefan.kebekus@gmail.com                                              *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 3 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
 ***************************************************************************/

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15

import "../dialogs"
import "../items"

Page {
    id: settingsPage
    title: qsTr("Settings")

    header: StandardHeader {}
    focus: true
    ScrollView {
        id: view
        focus: true
        anchors.fill: parent
        anchors.topMargin: Qt.application.font.pixelSize
        contentWidth: availableWidth

        ColumnLayout {
    
            width: settingsPage.width
            implicitWidth: settingsPage.width

            Label {
                Layout.leftMargin: Qt.application.font.pixelSize
                Layout.fillWidth: true
                text: qsTr("Moving Map")
                font.pixelSize: Qt.application.font.pixelSize*1.2
                font.bold: true
                color: Material.accent
            }

            WordWrappingItemDelegate {
                focus: true
                id: hideUpperAsp
                KeyNavigation.down: hideGlidingSectors
                text: {
                    var secondLineString = ""
                    var altitudeLimit = global.settings().airspaceAltitudeLimit
                    if (!altitudeLimit.isFinite()) {
                        secondLineString = qsTr("No limit, all airspaces shown")
                    } else {
                        // Mention
                        global.navigator().aircraft.verticalDistanceUnit

                        var airspaceAltitudeLimit = global.settings().airspaceAltitudeLimit
                        var airspaceAltitudeLimitString = global.navigator().aircraft.verticalDistanceToString(airspaceAltitudeLimit)
                        secondLineString = qsTr("Showing airspaces up to %1").arg(airspaceAltitudeLimitString)
                    }
                    return qsTr("Airspace Altitude Limit") +
                            `<br><font color="#606060" size="2">` +
                            secondLineString +
                            `</font>`

                }
                icon.source: "/icons/material/ic_map.svg"
                Layout.fillWidth: true
                onClicked: {
                    global.mobileAdaptor().vibrateBrief()
                    heightLimitDialog.open()
                }
                //remote control
                Keys.onPressed: {
                    if (event.key == Qt.Key_Return) 
                    { 
                        hideUpperAsp.toggle()
                        hideUpperAsp.toggled()
                    } 
                    else if (event.key == Qt.Key_Left) 
                    {
                        //stackView.push("InfoMenu.qml")
                        stackView.pop()
                    }
                }
            }

            WordWrappingSwitchDelegate {
                id: hideGlidingSectors
                text: qsTr("Hide Gliding Sectors")
                icon.source: "/icons/material/ic_map.svg"
                Layout.fillWidth: true
                Component.onCompleted: {
                    hideGlidingSectors.checked = global.settings().hideGlidingSectors
                }
                onToggled: {
                    global.mobileAdaptor().vibrateBrief()
                    global.settings().hideGlidingSectors = hideGlidingSectors.checked
                }
                //remote control
                Keys.onPressed: {
                    if (event.key == Qt.Key_Return) 
                    { 
                        hideGlidingSectors.toggle()
                        hideGlidingSectors.toggled()
                    } 
                    else if (event.key == Qt.Key_Left) 
                    {
                        //stackView.push("InfoMenu.qml")
                        stackView.pop()
                    }
                }
            }

            Label {
                Layout.leftMargin: Qt.application.font.pixelSize
                text: qsTr("System")
                font.pixelSize: Qt.application.font.pixelSize*1.2
                font.bold: true
                color: Material.accent
            }

            WordWrappingItemDelegate {
                id: trafficDataReceiverPositioning
                text: {
                    var secondLineString = ""
                    if (global.settings().positioningByTrafficDataReceiver) {
                        secondLineString = qsTr("Traffic data receiver")
                    } else {
                        secondLineString = qsTr("Built-in satnav receiver")
                    }
                    return qsTr("Primary position data source") +
                            `<br><font color="#606060" size="2">` +
                            secondLineString +
                            `</font>`
                }
                icon.source: "/icons/material/ic_satellite.svg"
                Layout.fillWidth: true
                onClicked: {
                    global.mobileAdaptor().vibrateBrief()
                    primaryPositionDataSourceDialog.open()
                }
            }

            WordWrappingSwitchDelegate {
                id: nightMode
                KeyNavigation.up: hideGlidingSectors
                KeyNavigation.down: ignoreSSL 
                text: qsTr("Night mode")
                icon.source: "/icons/material/ic_brightness_3.svg"
                Layout.fillWidth: true
                Component.onCompleted: {
                    nightMode.checked = global.settings().nightMode
                }
                onToggled: {
                    global.mobileAdaptor().vibrateBrief()
                    global.settings().nightMode = nightMode.checked
                }
                //remote control
                Keys.onPressed: {
                    if (event.key == Qt.Key_Return) 
                    { 
                        nightMode.toggle()
                        nightMode.toggled()
                    } 
                    else if (event.key == Qt.Key_Left) 
                    {
                        //stackView.push("InfoMenu.qml")
                        stackView.pop()
                    }
                }
            }

            WordWrappingSwitchDelegate {
                id: ignoreSSL
                text: qsTr("Ignore network security errors")
                icon.source: "/icons/material/ic_lock.svg"
                Layout.fillWidth: true
                visible: global.settings().ignoreSSLProblems
                Component.onCompleted: {
                    ignoreSSL.checked = global.settings().ignoreSSLProblems
                }
                onToggled: {
                    global.mobileAdaptor().vibrateBrief()
                    global.settings().ignoreSSLProblems = ignoreSSL.checked
                }
            }

            WordWrappingItemDelegate {
                Layout.fillWidth: true
                icon.source: "/icons/material/ic_lock.svg"
                text: qsTr("Clear password storage")
                onClicked: clearPasswordDialog.open()
                visible: !global.passwordDB().empty
            }

            Label {
                Layout.leftMargin: Qt.application.font.pixelSize
                text: qsTr("Help")
                font.pixelSize: Qt.application.font.pixelSize*1.2
                font.bold: true
                color: Material.accent
            }

            WordWrappingItemDelegate {
                Layout.fillWidth: true
                icon.source: "/icons/material/ic_info_outline.svg"
                text: qsTr("How to connect your traffic receiver…")
                onClicked: openManual("02-steps/traffic.html")
            }

            WordWrappingItemDelegate {
                Layout.fillWidth: true
                icon.source: "/icons/material/ic_info_outline.svg"
                text: qsTr("How to connect your flight simulator…")
                onClicked: openManual("02-steps/simulator.html")
            }

            Item { // Spacer
                height: 3
            }

        } // ColumnLayout
    }

    Dialog {
        id: clearPasswordDialog

        // Size is chosen so that the dialog does not cover the parent in full
        width: Math.min(parent.width-Qt.application.font.pixelSize, 40*Qt.application.font.pixelSize)

        // Center in Overlay.overlay. This is a funny workaround against a bug, I believe,
        // in Qt 15.1 where setting the parent (as recommended in the Qt documentation) does not seem to work right if the Dialog is opend more than once.
        parent: Overlay.overlay
        x: (parent.width-width)/2.0
        y: (parent.height-height)/2.0

        topMargin: Qt.application.font.pixelSize/2.0
        bottomMargin: Qt.application.font.pixelSize/2.0

        modal: true

        title: qsTr("Clear password storage?")

        Label {
            width: heightLimitDialog.availableWidth

            text: qsTr("Once the storage is cleared, the passwords can no longer be retrieved.")
            wrapMode: Text.Wrap
        }

        footer: DialogButtonBox {
            ToolButton {
                text: qsTr("Clear")
                DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
            }
            ToolButton {
                text: qsTr("Cancel")
                DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
            }

        } // DialogButtonBox


        onAccepted: {
            global.passwordDB().clear()
            toast.doToast(qsTr("Password storage cleared"))
        }

    }
    
    Keys.onPressed: 
    {
        event.accepted = true;
        if (event.key == Qt.Key_Left) {
            //stackView.push("InfoMenu.qml")
            stackView.pop()
        }
    } 


} // Page
