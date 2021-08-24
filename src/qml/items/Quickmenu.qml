import QtQuick 2.9
import QtQuick.Controls 2.3


    Menu{
        id : testmenu
        visible: true
        focus : true
 		title: "Quickmenu"
        property var lablecolor: "white";
 		
 		 
 		
 		
        Action{ text: "Volume"}
        MenuSeparator { }
        Action{ text: "Moving Map"}
        MenuSeparator { }
        Action{ text: "MC Ready"}
 
        topPadding: 50
        bottomPadding: 10
		
		//Custom style, refer to Qt help documentation
        delegate: MenuItem {
            id: menuItem
            implicitWidth: 200
            implicitHeight: 40
            arrow: Canvas {
                x: parent.width - width
                implicitWidth: 40
                implicitHeight: 40
                visible: menuItem.subMenu
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.fillStyle = menuItem.highlighted ? "#ffffff" : "#21be2b"
                    ctx.moveTo(15, 15)
                    ctx.lineTo(width - 15, height / 2)
                    ctx.lineTo(15, height - 15)
                    ctx.closePath()
                    ctx.fill()
                }
            }
 
            indicator: Item {
                anchors.verticalCenter: parent.verticalCenter
                implicitWidth: 18
                implicitHeight: 20
                Rectangle {
                    width: 18
                    height: 20
                    anchors.centerIn: parent
                    visible: menuItem.checkable
                    border.color: "#21be2b"
                    radius: 10
                    Rectangle {
 
                        width: 14
                        height: 14
                        anchors.centerIn: parent
                        visible: menuItem.checked
                        color: "#21be2b"
                        radius: 2
                    }
                }
            }
 
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
 
            background: Rectangle {
                implicitWidth: 160
                implicitHeight: 40
                opacity: enabled ? 1 : 0.3
                color: menuItem.highlighted ? "#000000" : "transparent"
                gradient: Gradient {
                     GradientStop { position: 0 ; color: menuItem.highlighted ? "#272424" : "#525252" }
                     GradientStop { position: 1 ; color: menuItem.highlighted ? "#080808" : "#232323" }
                  }
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
