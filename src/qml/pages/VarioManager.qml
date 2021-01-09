import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.2
import QtCharts 2.15

import "../items"

Page {
    id: flarmsettingpage
    title: qsTr("Variometer Settings")

    Component {
        id: sectionHeading

        Label {
            x: Qt.application.font.pixelSize
            text: section
            font.pixelSize: Qt.application.font.pixelSize*1.2
            font.bold: true
            color: Material.primary
        }
    }

    header: ToolBar {

        ToolButton {
            id: backButton

            anchors.left: parent.left
            anchors.leftMargin: drawer.dragMargin

            icon.source: "/icons/material/ic_arrow_back.svg"
            onClicked: {
                mobileAdaptor.vibrateBrief()
                stackView.pop()
            }
        } // ToolButton

        Label {
            anchors.left: backButton.right
            anchors.bottom: parent.bottom
            anchors.top: parent.top

            text: stackView.currentItem.title
            elide: Label.ElideRight
            font.bold: true
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
        }

    } // ToolBar
    
    
   ChartView {
		title: "Line"
		anchors.fill: parent
		antialiasing: true
		
		LineSeries {
		    name: "LineSeries"
		    id:lines
		    XYPoint { x: 0; y: 0 }
		    XYPoint { x: 1.1; y: 2.1 }
		    XYPoint { x: 1.9; y: 3.3 }
		    XYPoint { x: 2.1; y: 2.1 }
		    XYPoint { x: 2.9; y: 4.9 }
		    XYPoint { x: 3.4; y: 3.0 }
		    XYPoint { x: 4.1; y: 3.3 }
		}
		
		function addPoint(x: float, y: float)
		{
    		lines.append(x,y);
      
    	}
	}
}// page