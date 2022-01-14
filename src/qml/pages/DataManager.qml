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
    id: pg
    objectName: "DataManagerPage"

    title: qsTr("Map and Data Library")

    Component {
        id: sectionHeading

        Label {
            x: Qt.application.font.pixelSize
            text: section
            font.pixelSize: Qt.application.font.pixelSize*1.2
            font.bold: true
            color: Material.accent
        }
    }

    Component {
        id: mapItem

        Item {
            id: element
            width: pg.width
            height: gridLayout.height

            function startFileDownload() {
                // check how many files are already downloaded:
                var nFilesTotal;
                var mapTypeString;
                if (sv.currentIndex == 0) {  // swipe view shows aviation maps
<<<<<<< HEAD
=======
<<<<<<<< HEAD:src/qml/pages/DataManager.qml
>>>>>>> master
                    nFilesTotal = global.dataManager().aviationMaps.numberOfFilesTotal();
                    mapTypeString = qsTr("aviation maps")
                } else {  // swipe view shows base maps
                    nFilesTotal = global.dataManager().baseMaps.numberOfFilesTotal();
<<<<<<< HEAD
=======
========
                    nFilesTotal = global.mapManager().aviationMaps.numberOfFilesTotal();
                    mapTypeString = qsTr("aviation maps")
                } else {  // swipe view shows base maps
                    nFilesTotal = global.mapManager().baseMaps.numberOfFilesTotal();
>>>>>>>> master:src/qml/pages/MapManager.qml
>>>>>>> master
                    mapTypeString = qsTr("base maps")
                }

                // if the user downloads more than 8 files, show them a dialog telling them that
                // the bandwidth is sponsored and they shouldn't over-consume.
                if (nFilesTotal > 7) {
                    dialogLoader.active = false;
                    dialogLoader.dialogArgs = {onAcceptedCallback: model.modelData.startFileDownload,
                        nFilesTotal: nFilesTotal,
                        mapTypeString: mapTypeString};
                    dialogLoader.source = "../dialogs/TooManyDownloadsDialog.qml";
                    dialogLoader.active = true;
                } else {
                    model.modelData.startFileDownload();
                }
            }

            GridLayout {
                id: gridLayout

                columnSpacing: 0
                rowSpacing: 0

                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                columns: 6

                ItemDelegate {
                    text: model.modelData.objectName + `<br><font color="#606060" size="2">${model.modelData.infoText}</font>`
                    icon.source: model.modelData.updatable ? "/icons/material/ic_new_releases.svg" : "/icons/material/ic_map.svg"
                    Layout.fillWidth: true
                    enabled: !model.modelData.hasFile
                    onClicked: {
                        if (!model.modelData.downloading && (!model.modelData.hasFile || model.modelData.updatable)) {
                            global.mobileAdaptor().vibrateBrief()
                            startFileDownload()
                        }
                    }
                }

                ToolButton {
                    id: downloadButton
                    icon.source: "/icons/material/ic_file_download.svg"
                    visible: !model.modelData.hasFile && !model.modelData.downloading
                    onClicked: {
                        global.mobileAdaptor().vibrateBrief()
                        startFileDownload()
                    }
                }

                ToolButton {
                    id: updateButton
                    icon.source: "/icons/material/ic_refresh.svg"
                    visible: model.modelData.updatable
                    onClicked: {
                        global.mobileAdaptor().vibrateBrief()
                        startFileDownload()
                    }
                }

                ToolButton {
                    id: cancelButton
                    icon.source: "/icons/material/ic_cancel.svg"
                    visible: model.modelData.downloading
                    onClicked: {
                        global.mobileAdaptor().vibrateBrief()
                        model.modelData.stopFileDownload()
                    }
                }

                ToolButton {
                    id: removeButton
                    icon.source: "/icons/material/ic_more_horiz.svg"

                    visible: model.modelData.hasFile & !model.modelData.downloading
                    onClicked: {
                        global.mobileAdaptor().vibrateBrief()
                        removeMenu.popup()
                    }

                    AutoSizingMenu {
                        id: removeMenu

                        Action {
                            id: infoAction

<<<<<<< HEAD
=======
<<<<<<<< HEAD:src/qml/pages/DataManager.qml
>>>>>>> master
                            text: qsTr("Info")

                            onTriggered: {
                                global.mobileAdaptor().vibrateBrief()
                                infoDialog.title = model.modelData.objectName
                                infoDialog.text = global.dataManager().describeMapFile(model.modelData.fileName)
<<<<<<< HEAD
=======
========
                            text: qsTr("Map Info")

                            onTriggered: {
                                global.mobileAdaptor().vibrateBrief()
                                infoDialog.title = qsTr("Map Info: ") + model.modelData.objectName
                                infoDialog.text = global.geoMapProvider().describeMapFile(model.modelData.fileName)
>>>>>>>> master:src/qml/pages/MapManager.qml
>>>>>>> master
                                infoDialog.open()
                            }
                        }
                        Action {
                            id: removeAction

                            text: qsTr("Uninstall")

                            onTriggered: {
                                global.mobileAdaptor().vibrateBrief()
                                model.modelData.deleteFile()
                            }
                        }
                    }

                } // ToolButton
            }

            Connections {
                target: model.modelData
                function onError(objectName, message) {
<<<<<<< HEAD
=======
<<<<<<<< HEAD:src/qml/pages/DataManager.qml
>>>>>>> master
                    dialogLoader.active = false
                    dialogLoader.title = qsTr("Download Error")
                    dialogLoader.text = qsTr("<p>Failed to download <strong>%1</strong>.</p><p>Reason: %2.</p>").arg(objectName).arg(message)
                    dialogLoader.source = "../dialogs/ErrorDialog.qml"
                    dialogLoader.active = true
                }
            }

        }

    }

    Component {
        id: databaseItem

        Item {
            id: element
            width: pg.width
            height: gridLayout.height

            GridLayout {
                id: gridLayout

                columnSpacing: 0
                rowSpacing: 0

                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                columns: 6

                ItemDelegate {
                    text: model.modelData.objectName + `<br><font color="#606060" size="2">${model.modelData.infoText}</font>`
                    icon.source: model.modelData.updatable ? "/icons/material/ic_new_releases.svg" : "/icons/material/ic_library_books.svg"
                    Layout.fillWidth: true
                    enabled: !model.modelData.hasFile
                    onClicked: {
                        if (!model.modelData.downloading && (!model.modelData.hasFile || model.modelData.updatable)) {
                            global.mobileAdaptor().vibrateBrief()
                            model.modelData.startFileDownload();
                        }
                    }
                }

                ToolButton {
                    id: downloadButton
                    icon.source: "/icons/material/ic_file_download.svg"
                    visible: !model.modelData.hasFile && !model.modelData.downloading
                    onClicked: {
                        global.mobileAdaptor().vibrateBrief()
                        startFileDownload()
                    }
                }

                ToolButton {
                    id: updateButton
                    icon.source: "/icons/material/ic_refresh.svg"
                    visible: model.modelData.updatable
                    onClicked: {
                        global.mobileAdaptor().vibrateBrief()
                        startFileDownload()
                    }
                }

                ToolButton {
                    id: cancelButton
                    icon.source: "/icons/material/ic_cancel.svg"
                    visible: model.modelData.downloading
                    onClicked: {
                        global.mobileAdaptor().vibrateBrief()
                        model.modelData.stopFileDownload()
                    }
                }

                ToolButton {
                    id: removeButton
                    icon.source: "/icons/material/ic_more_horiz.svg"

                    visible: model.modelData.hasFile & !model.modelData.downloading
                    onClicked: {
                        global.mobileAdaptor().vibrateBrief()
                        removeMenu.popup()
                    }

                    AutoSizingMenu {
                        id: removeMenu

                        Action {
                            id: infoAction

                            text: qsTr("Info")

                            onTriggered: {
                                global.mobileAdaptor().vibrateBrief()
                                infoDialog.title = model.modelData.objectName
                                infoDialog.text = global.dataManager().describeMapFile(model.modelData.fileName)
                                infoDialog.open()
                            }
                        }
                        Action {
                            id: removeAction

                            text: qsTr("Uninstall")

                            onTriggered: {
                                global.mobileAdaptor().vibrateBrief()
                                model.modelData.deleteFile()
                            }
                        }
                    }

                } // ToolButton
            }

            Connections {
                target: model.modelData
                function onError(objectName, message) {
<<<<<<< HEAD
=======
========
>>>>>>>> master:src/qml/pages/MapManager.qml
>>>>>>> master
                    dialogLoader.active = false
                    dialogLoader.title = qsTr("Download Error")
                    dialogLoader.text = qsTr("<p>Failed to download <strong>%1</strong>.</p><p>Reason: %2.</p>").arg(objectName).arg(message)
                    dialogLoader.source = "../dialogs/ErrorDialog.qml"
                    dialogLoader.active = true
                }
            }

        }

    }


    header: ToolBar {

        Material.foreground: "white"
        height: 60

        ToolButton {
            id: backButton

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            icon.source: "/icons/material/ic_arrow_back.svg"

            onClicked: {
                global.mobileAdaptor().vibrateBrief()
                stackView.pop()
            }
        }

        Label {
            id: lbl

            anchors.verticalCenter: parent.verticalCenter

            anchors.left: parent.left
            anchors.leftMargin: 72
            anchors.right: headerMenuToolButton.left

            text: stackView.currentItem.title
            elide: Label.ElideRight
            font.pixelSize: 20
            verticalAlignment: Qt.AlignVCenter
        }

        ToolButton {
            id: headerMenuToolButton

            anchors.verticalCenter: parent.verticalCenter

            anchors.right: parent.right

            icon.source: "/icons/material/ic_more_vert.svg"
            icon.color: "white"

            onClicked: {
                global.mobileAdaptor().vibrateBrief()
                headerMenuX.popup()
            }

        }

        AutoSizingMenu {
            id: headerMenuX

            MenuItem {
                id: updateMenu

                text: qsTr("Update list of maps")

                onTriggered: {
                    global.mobileAdaptor().vibrateBrief()
                    highlighted = false
<<<<<<< HEAD
                    global.dataManager().updateGeoMapList()
=======
<<<<<<<< HEAD:src/qml/pages/DataManager.qml
                    global.dataManager().updateGeoMapList()
========
                    global.mapManager().updateGeoMapList()
>>>>>>>> master:src/qml/pages/MapManager.qml
>>>>>>> master
                }
            }

            MenuItem {
                id: downloadUpdatesMenu

                text: qsTr("Download all updates…")
<<<<<<< HEAD
                enabled: global.dataManager().geoMaps.updatable
=======
<<<<<<<< HEAD:src/qml/pages/DataManager.qml
                enabled: global.dataManager().geoMaps.updatable
========
                enabled: global.mapManager().geoMaps.updatable
>>>>>>>> master:src/qml/pages/MapManager.qml
>>>>>>> master

                onTriggered: {
                    global.mobileAdaptor().vibrateBrief()
                    highlighted = false
<<<<<<< HEAD
                    global.dataManager().geoMaps.updateAll()
=======
<<<<<<<< HEAD:src/qml/pages/DataManager.qml
                    global.dataManager().geoMaps.updateAll()
========
                    global.mapManager().geoMaps.updateAll()
>>>>>>>> master:src/qml/pages/MapManager.qml
>>>>>>> master
                }
            }

        }

    }


    TabBar {
        id: bar

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        currentIndex: sv.currentIndex
        TabButton {
            text: qsTr("Aviation Maps")
        }
        TabButton {
            text: qsTr("Base Maps")
        }
        TabButton {
            text: qsTr("Data")
        }
        Material.elevation: 3
    }

    ColumnLayout {
        anchors.top: bar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        anchors.topMargin: Qt.application.font.pixelSize*0.2

        SwipeView{
            id: sv

            currentIndex: bar.currentIndex
            Layout.fillWidth: true
            Layout.fillHeight: true

            ListView {
                clip: true
<<<<<<< HEAD
                model: global.dataManager().aviationMaps.downloadablesAsObjectList
=======
<<<<<<<< HEAD:src/qml/pages/DataManager.qml
                model: global.dataManager().aviationMaps.downloadablesAsObjectList
========
                model: global.mapManager().aviationMaps.downloadablesAsObjectList
>>>>>>>> master:src/qml/pages/MapManager.qml
>>>>>>> master
                delegate: mapItem
                ScrollIndicator.vertical: ScrollIndicator {}

                section.property: "modelData.section"
                section.delegate: sectionHeading

                footer: ColumnLayout {
                    width: parent.width

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: "gray"
                    }

                    WordWrappingItemDelegate {
                        Layout.fillWidth: true
                        icon.source: "/icons/material/ic_info_outline.svg"
                        text: qsTr("How to request additional aviation maps…")
                        onClicked: ltd.open()

                        LongTextDialog {
                            id: ltd
                            standardButtons: Dialog.Ok

                            title: qsTr("Request additional aviation maps")
<<<<<<< HEAD
                            text: global.librarian().getStringFromRessource(":text/aviationMapMissing.html")
=======
<<<<<<<< HEAD:src/qml/pages/DataManager.qml
                            text: global.librarian().getStringFromRessource(":text/aviationMapMissing.html")
========
                            text: librarian.getStringFromRessource(":text/aviationMapMissing.html")
>>>>>>>> master:src/qml/pages/MapManager.qml
>>>>>>> master
                        }

                    }

                    Item { // Spacer
                        height: 3
                    }

                }

                // Refresh list of maps on overscroll
                property int refreshFlick: 0
                onFlickStarted: {
                    refreshFlick = atYBeginning
                }
                onFlickEnded: {
                    if ( atYBeginning && refreshFlick ) {
                        global.mobileAdaptor().vibrateBrief()
<<<<<<< HEAD
                        global.dataManager().updateGeoMapList()
=======
<<<<<<<< HEAD:src/qml/pages/DataManager.qml
                        global.dataManager().updateGeoMapList()
========
                        global.mapManager().updateGeoMapList()
>>>>>>>> master:src/qml/pages/MapManager.qml
>>>>>>> master
                    }
                }
            } // ListView

            ListView {
                Layout.fillHeight: true
                Layout.fillWidth: true
                clip: true
<<<<<<< HEAD
                model: global.dataManager().baseMaps.downloadablesAsObjectList
=======
<<<<<<<< HEAD:src/qml/pages/DataManager.qml
                model: global.dataManager().baseMaps.downloadablesAsObjectList
========
                model: global.mapManager().baseMaps.downloadablesAsObjectList
>>>>>>>> master:src/qml/pages/MapManager.qml
>>>>>>> master
                delegate: mapItem
                ScrollIndicator.vertical: ScrollIndicator {}

                section.property: "modelData.section"
                section.delegate: sectionHeading

                // Refresh list of maps on overscroll
                property int refreshFlick: 0
                onFlickStarted: {
                    refreshFlick = atYBeginning
                }
                onFlickEnded: {
                    if ( atYBeginning && refreshFlick ) {
                        global.mobileAdaptor().vibrateBrief()
<<<<<<< HEAD
=======
<<<<<<<< HEAD:src/qml/pages/DataManager.qml
>>>>>>> master
                        global.dataManager().updateGeoMapList()
                    }
                }
            } // ListView

            ListView {
                Layout.fillHeight: true
                Layout.fillWidth: true
                clip: true
                model: global.dataManager().databases.downloadablesAsObjectList
                delegate: databaseItem
                ScrollIndicator.vertical: ScrollIndicator {}

                section.property: "modelData.section"
                section.delegate: sectionHeading

                // Refresh list of maps on overscroll
                property int refreshFlick: 0
                onFlickStarted: {
                    refreshFlick = atYBeginning
                }
                onFlickEnded: {
                    if ( atYBeginning && refreshFlick ) {
                        global.mobileAdaptor().vibrateBrief()
                        global.dataManager().updateGeoMapList()
<<<<<<< HEAD
=======
========
                        global.mapManager().updateGeoMapList()
>>>>>>>> master:src/qml/pages/MapManager.qml
>>>>>>> master
                    }
                }
            } // ListView

        } // SwipeView

    }


    Rectangle {
        id: noMapListWarning

        anchors.top: bar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        color: "white"
<<<<<<< HEAD
        visible: !global.dataManager().downloadingGeoMapList && !global.dataManager().hasGeoMapList
=======
<<<<<<<< HEAD:src/qml/pages/DataManager.qml
        visible: !global.dataManager().downloadingGeoMapList && !global.dataManager().hasGeoMapList
========
        visible: !global.mapManager().downloadingGeoMapList && !global.mapManager().hasGeoMapList
>>>>>>>> master:src/qml/pages/MapManager.qml
>>>>>>> master

        Label {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: Qt.application.font.pixelSize*2
<<<<<<< HEAD
=======
            anchors.leftMargin: Qt.application.font.pixelSize*2
            anchors.rightMargin: Qt.application.font.pixelSize*2
>>>>>>> master

            horizontalAlignment: Text.AlignHCenter
            textFormat: Text.StyledText
            wrapMode: Text.Wrap
<<<<<<< HEAD
            text: qsTr("<h3>Sorry!</h3><p>The list of available maps has not yet been downloaded from the server. You can restart the download manually using the item 'Update' from the menu. You find the menu at the top right corner of the screen.</p>")
=======
<<<<<<<< HEAD:src/qml/pages/DataManager.qml
            text: qsTr("<h3>Sorry!</h3><p>The list of available maps has not yet been downloaded from the server. You can restart the download manually using button below.</p>")
========
            text: qsTr("<h3>Sorry!</h3><p>The list of available maps has not yet been downloaded from the server. You can restart the download manually using the item 'Update' from the menu.  To find the menu, look for the symbol '&#8942;' at the top right corner of the screen.</p>")
>>>>>>>> master:src/qml/pages/MapManager.qml
>>>>>>> master
        }
    }

    Rectangle {
        id: downloadIndicator

        anchors.top: bar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        color: "white"
<<<<<<< HEAD
        visible: global.dataManager().downloadingGeoMapList
=======
<<<<<<<< HEAD:src/qml/pages/DataManager.qml
        visible: global.dataManager().downloadingGeoMapList
========
        visible: global.mapManager().downloadingGeoMapList
>>>>>>>> master:src/qml/pages/MapManager.qml
>>>>>>> master

        Label {
            id: downloadIndicatorLabel

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: Qt.application.font.pixelSize*2
<<<<<<< HEAD
=======
            anchors.leftMargin: Qt.application.font.pixelSize*2
            anchors.rightMargin: Qt.application.font.pixelSize*2
>>>>>>> master

            horizontalAlignment: Text.AlignHCenter
            textFormat: Text.StyledText
            wrapMode: Text.Wrap
            text: qsTr("<h3>Download in progress…</h3><p>Please stand by while we download the list of available maps from the server…</p>")
<<<<<<< HEAD
        } // downloadIndicatorLabel
=======
<<<<<<<< HEAD:src/qml/pages/DataManager.qml
        }
========
        } // downloadIndicatorLabel
>>>>>>>> master:src/qml/pages/MapManager.qml
>>>>>>> master

        BusyIndicator {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: downloadIndicatorLabel.bottom
            anchors.topMargin: 10
        }

        // The Connections and the SequentialAnimation here provide a fade-out animation for the downloadindicator.
        // Without this, the downaloadIndication would not be visible on very quick downloads, leaving the user
        // without any feedback if the download did actually take place.
        Connections {
<<<<<<< HEAD
            target: global.dataManager()
            function onDownloadingGeoMapListChanged () {
                if (global.dataManager().downloadingGeoMapList) {
=======
<<<<<<<< HEAD:src/qml/pages/DataManager.qml
            target: global.dataManager()
            function onDownloadingGeoMapListChanged () {
                if (global.dataManager().downloadingGeoMapList) {
========
            target: global.mapManager()
            function onDownloadingGeoMapListChanged () {
                if (global.mapManager().downloadingGeoMapList) {
>>>>>>>> master:src/qml/pages/MapManager.qml
>>>>>>> master
                    downloadIndicator.visible = true
                    downloadIndicator.opacity = 1.0
                } else
                    fadeOut.start()
            }
        }
        SequentialAnimation{
            id: fadeOut
            NumberAnimation { target: downloadIndicator; property: "opacity"; to:1.0; duration: 400 }
            NumberAnimation { target: downloadIndicator; property: "opacity"; to:0.0; duration: 400 }
            NumberAnimation { target: downloadIndicator; property: "visible"; to:1.0; duration: 20}
        }
    }

    footer: Pane {
        width: parent.width

        Material.elevation: 3
<<<<<<< HEAD
        visible: !global.dataManager().geoMaps.downloading && global.dataManager().geoMaps.updatable
=======
<<<<<<<< HEAD:src/qml/pages/DataManager.qml
        visible: (!global.dataManager().downloadingGeoMapList && !global.dataManager().hasGeoMapList) || (!global.dataManager().geoMaps.downloading && global.dataManager().geoMaps.updatable)
        contentHeight: Math.max(downloadMapListActionButton.height, downloadUpdatesActionButton.height)

        ToolButton {
            id: downloadMapListActionButton
            anchors.centerIn: parent
            visible: !global.dataManager().downloadingGeoMapList && !global.dataManager().hasGeoMapList

            text: qsTr("Download list of maps…")
            icon.source: "/icons/material/ic_file_download.svg"

            onClicked: {
                global.mobileAdaptor().vibrateBrief()
                global.dataManager().updateGeoMapList()
            }
        }
========
        visible: !global.mapManager().geoMaps.downloading && global.mapManager().geoMaps.updatable
>>>>>>>> master:src/qml/pages/MapManager.qml
>>>>>>> master

        ToolButton {
            id: downloadUpdatesActionButton
            anchors.centerIn: parent
<<<<<<< HEAD
            text: qsTr("Download all updates…")
=======
            visible: !global.dataManager().geoMaps.downloading && global.dataManager().geoMaps.updatable

            text: qsTr("Update")
>>>>>>> master
            icon.source: "/icons/material/ic_file_download.svg"

            onClicked: {
                global.mobileAdaptor().vibrateBrief()
<<<<<<< HEAD
                global.dataManager().geoMaps.updateAll()
=======
<<<<<<<< HEAD:src/qml/pages/DataManager.qml
                global.dataManager().geoMaps.updateAll()
========
                global.mapManager().geoMaps.updateAll()
>>>>>>>> master:src/qml/pages/MapManager.qml
>>>>>>> master
            }
        }
    }

    // Show error when list of maps cannot be downloaded
    Connections {
<<<<<<< HEAD
        target: global.dataManager()
=======
<<<<<<<< HEAD:src/qml/pages/DataManager.qml
        target: global.dataManager()
========
        target: global.mapManager()
>>>>>>>> master:src/qml/pages/MapManager.qml
>>>>>>> master
        function onError (message) {
            dialogLoader.active = false
            dialogLoader.title = qsTr("Download Error")
            dialogLoader.text = qsTr("<p>Failed to download the list of aviation maps.</p><p>Reason: %1.</p>").arg(message)
            dialogLoader.source = "../dialogs/ErrorDialog.qml"
            dialogLoader.active = true
        }
    }

<<<<<<< HEAD

=======
<<<<<<<< HEAD:src/qml/pages/DataManager.qml
========

>>>>>>>> master:src/qml/pages/MapManager.qml
>>>>>>> master
    LongTextDialog {
        id: infoDialog

        text: ""
        standardButtons: Dialog.Ok
    }
<<<<<<< HEAD
=======
<<<<<<<< HEAD:src/qml/pages/DataManager.qml

========
>>>>>>>> master:src/qml/pages/MapManager.qml
>>>>>>> master
} // Page
