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

import enroute 1.0

import "../items"

Page {
    id: page

    title: qsTr("Moving Map")
	focus: true
    Loader {
        id: mapLoader

        anchors.fill: parent
    }

    Button {
        id: menuButton
        icon.source: "/icons/material/ic_menu.svg"

        anchors.left: parent.left
        anchors.leftMargin: 0.5*Qt.application.font.pixelSize
        anchors.top: parent.top
        anchors.topMargin: 0.5*Qt.application.font.pixelSize

        onClicked: {
            mobileAdaptor.vibrateBrief()
            drawer.open()
        }
    }

    Component.onCompleted: {
        mapLoader.source = "../items/MFM.qml"
    }

    Connections {
        target: geoMapProvider

        function onStyleFileURLChanged() {
            mapLoader.active = false
            mapLoader.source = "../items/MFM.qml"
            mapLoader.active = true
        }
    }
    //zoom in and out for remote control
	Keys.onPressed: {
		if (event.key == Qt.Key_Up) {
		    event.accepted = true;
		    mapLoader.item.map.zoomLevel += 0.5
		}
		
		if (event.key == Qt.Key_Down) {
		    event.accepted = true;
		    mapLoader.item.map.zoomLevel -= 0.5
		}
		
		if (event.key == Qt.Key_Return) {
		    event.accepted = true;
		   	if(qickmenulabel.visible != true)
		   	{
				qickmenu.popup(page, (parent.width / 2) - 100, (parent.height / 2) - 100);
				qickmenulabel.open();
			}
			else
			{
				qickmenulabel.close();
			}
		}
			
	}
	
	
	Popup {
		id: qickmenulabel
		width: 200
		height: 40
		x: (parent.width / 2) - 100
		y: (parent.height / 2) - 140
		contentItem: Text {
		        text: "Quick Menu"
				font.pixelSize: 20
		        opacity: enabled ? 1.0 : 0.3
		        color: "white"
		        horizontalAlignment: Text.AlignHCenter
		        verticalAlignment: Text.AlignVCenter
		        elide: Text.ElideRight
		}
		
		
		 background: Rectangle {
		    implicitWidth: 200
		    implicitHeight: 40
		    color: "#000000"
		    border.color: "darkgray"
		    radius: 10
		    gradient: Gradient {
		         GradientStop { position: 0 ; color:  "#525252" }
		         GradientStop { position: 1 ; color:  "#232323" }
		    }
		}
        
	} 
        
        
	Menu{
        id : qickmenu
        visible: false
        focus : true

        property var lablecolor: "white";
 		
 

 		
 		
        Action{ 
       		text: "Volume"
       		onTriggered: {
       	 		volumecontrol.visible = true,
       	 		qickmenulabel.visible = false,
       	 		volumecontrol.focus = true
       		}
        }
        MenuSeparator { }
        Action{ text: "Moving Map"}
        MenuSeparator { }
        Action{ 
        	text: "MC Ready"
        	
        }
 
        topPadding: 10
        bottomPadding: 10
		
		//Custom style, refer to Qt help documentation
        delegate: MenuItem {
            id: menuItem
            implicitWidth: 200
            implicitHeight: 40
           
 
            contentItem: Text {
                leftPadding: menuItem.indicator.width
                rightPadding: menuItem.arrow.width
                text: menuItem.text
                font: menuItem.font
                opacity: enabled ? 1.0 : 0.3
                color: menuItem.highlighted ? "#fff000" : lablecolor
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
 
            
        }
 
        background: Rectangle {
            implicitWidth: 200
            implicitHeight: 40
            color: "#000000"
            border.color: "darkgray"
            radius: 10
            gradient: Gradient {
                 GradientStop { position: 0 ; color:  "#525252" }
                 GradientStop { position: 1 ; color:  "#232323" }
			}
        }
    }
	        
	
	
	
		
	    
    Slider {
    	id: volumecontrol
	    from: 1
	    value: 25
	    to: 100
	    stepSize : 5
	    visible: false
	    
	    x: (parent.width / 2) 
        y: (parent.height / 2) 
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
	}

}
