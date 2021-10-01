/***************************************************************************
 *   Copyright (C) 2019-2020 by Stefan Kebekus                             *
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
import QtQuick.Layouts 1.2

import "../items"

Page {
    id: flarmsettingpage
    title: qsTr("Flarm Settings")
    
    header: StandardHeader {}
	focus: true
	
	ScrollView {
        id: view
        anchors.fill: parent
        anchors.topMargin: Qt.application.font.pixelSize
		focus: true
        ColumnLayout {
            width: flarmsettingpage.width
            implicitWidth: flarmsettingpage.width
   
	        
			ItemDelegate {
				id:item1
				focus: true
				Layout.fillWidth: true
				text: qsTr("Port:")
				font.pixelSize: 16
				KeyNavigation.down: item2
			
			    ComboBox {
			    	id:ports
			    	anchors.right:  parent.right
				    width: 200
				    popup.visible: ports.activeFocus
				    model: ListModel {
				        ListElement { text: "Banana" }
				        ListElement { text: "Apple" }
				        ListElement { text: "Coconut" }
				    }
				    Keys.onPressed: {
					    if (event.key == Qt.Key_Return) {
					        event.accepted = true;
					       	item1.focus = true;
					       	
					    }
					}
				}	
				  
				Keys.onPressed: {
				    if (event.key == Qt.Key_Return) {
				        event.accepted = true;
				       	ports.focus = true;
				       	ports.pressed = true;
				    }
				    else if (event.key == Qt.Key_Left) 
                    {
                        //stackView.push("InfoMenu.qml")
                        stackView.pop()
                    }
				}	
			}
			
			ItemDelegate {
				id: item2
				Layout.fillWidth: true
				text: qsTr("Baudrate:")
				font.pixelSize: 16
				
			    ComboBox {
			    	id:baudrate
			    	anchors.right:  parent.right
				    width: 200

				    //popup.visible: baudrate.activeFocus
				    model: ListModel {
				        
                        ListElement { text: "Banana" }
                        ListElement { text: "Apple" }
                        ListElement { text: "Coconut" }
                    }
				    Keys.onPressed: {
					    if (event.key == Qt.Key_Return) {
					        event.accepted = true;
					       	item2.focus = true;
					    }
					}
					onActivated: {
					   focus : true
					}
					onAccepted:{
					   baudrate.popup.close()
					}
				}
				Keys.onPressed: {
				    if (event.key == Qt.Key_Return) {
				        event.accepted = true;
				       	baudrate.popup.open();
				       
				        baudrate.popup.focus = true;
				       	baudrate.popup.forceActiveFocus(Qt.MenuBarFocusReason);
				       	
				    }
				    else if (event.key == Qt.Key_Left) 
                    {
                        //stackView.push("InfoMenu.qml")
                        stackView.pop()
                    }
				}	
			}
			
			
	
		}//ColumnLayout
	
	} // ScrollView
} // Page
