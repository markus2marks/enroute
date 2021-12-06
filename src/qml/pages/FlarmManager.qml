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
			   
			    Component.onCompleted: {
                    ports.currentIndex = 0;
                }  
			    
			    ComboBox {
			        ListModel {
                        id: comports   
                    }  
			    
			        Component.onCompleted: {
			            QStringList liste = global.trafficDataSource_Serial().getSerialPorts()
                        comports.insert(0,{"text":"COM1"})
                        comports.insert(1,{"text":"COM2"})
                        comports.insert(2,{"text":"COM3"})
                    }
			    	id:ports
			    	anchors.right:  parent.right
				    width: 200
				    model: comports
				    Keys.onPressed: {
					    if (event.key == Qt.Key_Return) {
					       	item1.focus = true;
					       	ports.focus = false;       	
					    }
					}
					onActivated: {
                       ports.pressed = true;
                    }
                    
				}	
				  
				Keys.onPressed: {
				    if (event.key == Qt.Key_Return && (ports.popup.opened == false)) {
				        ports.popup.close();
				       	ports.focus = true;
				    }
				    else if (event.key == Qt.Key_Left && (ports.focus == false)) 
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
				    model: ListModel {
				        
                        ListElement { text: "Banana" }
                        ListElement { text: "Apple" }
                        ListElement { text: "Coconut" }
                    }
				    Keys.onPressed: {
					    if (event.key == Qt.Key_Return) {
					       	item2.focus = true;
					       	baudrate.focus = false;
					    }
					}
					onActivated: {
					   baudrate.pressed = true;
					}
				}
				Keys.onPressed: {
				   if (event.key == Qt.Key_Return && (baudrate.popup.opened == false)) {
                        baudrate.popup.close();
                        baudrate.focus = true;      
                    }
				    else if (event.key == Qt.Key_Left && (baudrate.focus == false)) 
                    {
                        //stackView.push("InfoMenu.qml")
                        stackView.pop()
                    }
				}	
			}
			
			
	
		}//ColumnLayout
	
	} // ScrollView
} // Page
