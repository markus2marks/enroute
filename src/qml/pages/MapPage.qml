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

import QtLocation 5.15
import QtPositioning 5.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

import enroute 1.0

import "../items"

Page {
    id: page
	property var movingmap: false
	property var volume: false
	
    title: qsTr("Moving Map")
	focus: true
    Loader {
        id: mapLoader

        anchors.fill: parent
    }

    RoundButton {
        id: menuButton
        icon.source: "/icons/material/ic_menu.svg"

        anchors.left: parent.left
        anchors.leftMargin: 0.5*Qt.application.font.pixelSize
        anchors.top: parent.top
        anchors.topMargin: 0.5*Qt.application.font.pixelSize

        height: 66
        width: 66

        onClicked: {
            global.mobileAdaptor().vibrateBrief()
            drawer.open()
        }
    }

    Component.onCompleted: {
        mapLoader.source = "../items/MFM.qml"
    }

    Connections {
        target: global.geoMapProvider()

        function onStyleFileURLChanged() {
            mapLoader.active = false
            mapLoader.source = "../items/MFM.qml"
            mapLoader.active = true
        }
    }
    //zoom in and out for remote control
	Keys.onPressed: {
		event.accepted = true;
		if(movingmap == true)
		{
			//stay in moving map modus
			timer.restart();
			if (event.key == Qt.Key_Up) {
				mapLoader.item.map.pan(0,-50);
			}
			if (event.key == Qt.Key_Down) {
				mapLoader.item.map.pan(0,50);
			}
			if (event.key == Qt.Key_Right) {
				mapLoader.item.map.pan(50,0);
			}
			if (event.key == Qt.Key_Left) {
				mapLoader.item.map.pan(-50,0);
			}
		}
		else if(volume == true)
		{
			
		}
		else
		{
			//Menu open with remote control
			if (event.key == Qt.Key_Left) {
	            drawer.open()
	        }
			
			if (event.key == Qt.Key_Up) {
			    mapLoader.item.map.zoomLevel += 0.5
			}
			
			if (event.key == Qt.Key_Down) {
			    mapLoader.item.map.zoomLevel -= 0.5
			}
			
			if (event.key == Qt.Key_Return) {
			   	if(qickmenu.visible != true)
			   	{
					qickmenu.open();
				}
				else
				{
					qickmenu.close();
				}
			}
		}
			
	}
	
	function closeSession()  {
	 	if(movingmap == true)
	 	{
	 		movingmap = false;
	 		stackView.focus = true;
	 		page.focus = true;
	 	}
	 	else if(volume == true)
	 	{
	 		popupvolumecontrol.visible = false;
	 		page.focus = true;
	 		stackView.focus = true;
	 		volume = false;
	 	}
	 }
	
	
	Popup {
		id: qickmenu
		width: 200
		height: 162
		x: (parent.width / 2) - 100
		y: (parent.height / 2) - 140
		focus: true
		

		
		contentItem: ListView
		{
			anchors.fill: parent
			anchors.margins: 1
			headerPositioning : ListView.OverlayFooter
			keyNavigationEnabled : true
			focus: true
	  		clip: true
			header: Label
				{
					id:quickmenulabel
					width: ListView.view.width
					z:2
					//text:"Quick Menu"
					//font.pointSize: 16
					//color: "white"
					//horizontalAlignment : Text.AlignHCenter
				    //verticalAlignment : Text.AlignVCenter
				    //Layout.alignment :  Qt.AlignHCenter		
				    
				    Layout.fillWidth: true
				
				    text: "<strong>Quick Menu</strong>"
				    color: "white"
				    padding: Qt.application.font.pixelSize
					 
					background: Rectangle {
						color:  Material.primary
					}				
	                      				
			}//header
			
		    model: ListModel 
		    {
			    ListElement {
			        name: "Volume"
			    }
			    ListElement {
			        name: "Moving Map"
			    }
			    ListElement {
			        name: "Mc Ready"
			    }
			}
		
		    delegate: ItemDelegate {	    	
		  	 	
		  	 	Layout.alignment : Qt.AlignHCenter 
		  	 	id: wrapper
		        Text 
		        { 
		        	text: name
		        	color: wrapper.ListView.isCurrentItem ? Material.primary : "black"

		        	font.pointSize: 14
		        	horizontalAlignment : Text.AlignHCenter
		        	verticalAlignment : Text.AlignVCenter
		        	anchors.fill: parent
		        }
		       	background: Rectangle {
				    implicitWidth: 202
				    implicitHeight: 40
				    gradient: Gradient {
				         GradientStop { position: 0 ; color:  "#FFFFFF" }
				         GradientStop { position: 1 ; color:  "#EEEEEE" }
				    }
				}
				Keys.onPressed: {
					if (event.key == Qt.Key_Return) {
		    			event.accepted = true;
		    			qickmenu.close();
		    			timer.start();
		    			if(modelData == "Volume")
		    			{
		    				popupvolumecontrol.visible = true
		    				popupvolumecontrol.focus = true
		    				page.volume = true
		   				}
		   				if(modelData == "Moving Map")
		    			{
		    				 
		    				 page.movingmap = true
		    			}
					}
				}
		    }
		    highlight: Rectangle {
		        width: parent.width
		        color: "#AAAAAA"
		         
		    }
		
		    
		}

		
		background: Rectangle {
		   
		    color: "transparent"
			  border.color:"black"
			  border.width: 1
		}
        
	} 
	
	Popup {  
		id: icon
	}
	
		
	Popup {    
		id: popupvolumecontrol
		x: (parent.width / 2) - 150
		y: (parent.height / 2) - 40
		
		width: 300
		height: 40
		focus: true
    	contentItem:  Slider {
	    	id: volumecontrol
		    from: 1
		    value: 25
		    to: 100
		    stepSize : 5
		    focus: true
		    width: 200
	
		   // visible: false
		    
		    //x: (parent.width / 2) 
	        //y: (parent.height / 2) 
		   // orientation : Qt.Vertical
		    
		    background: Rectangle {
		        x: volumecontrol.leftPadding
		        y: volumecontrol.topPadding + volumecontrol.availableHeight / 2 - height / 2
		        implicitWidth: 200
		        implicitHeight: 4
		        width: volumecontrol.availableWidth
		        height: implicitHeight
		        radius: 2
		        color: "#bdbebf"
		
		        Rectangle {
		            width: volumecontrol.visualPosition * parent.width
		            height: parent.height
		            color: "#21be2b"
		            radius: 2
		        }
		    }
		    handle: Rectangle {
		        x: volumecontrol.leftPadding + volumecontrol.visualPosition * (volumecontrol.availableWidth - width)
		        y: volumecontrol.topPadding + volumecontrol.availableHeight / 2 - height / 2
		        implicitWidth: 26
		        implicitHeight: 26
		        radius: 13
		        color: volumecontrol.pressed ? "#f0f0f0" : "#f6f6f6"
		        border.color: "#bdbebf"
		    }
			Keys.onPressed: {
				timer.restart();
			}
		}
		
		
		background: Rectangle {
		   
		    color: "white"
			  border.color:"black"
			  border.width: 1
			  radius: 20
		}
	}
	
	Timer {
		id: timer
        interval: 1000; 
       	onTriggered: page.closeSession()	
    }

}
