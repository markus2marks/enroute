import QtQuick.Window 2.14
import QtLocation 5.6
import QtPositioning 5.6
import QtQuick 2.7
import QtQuick.Controls 2.4

Window {
    visible: true

    Plugin {
        id: mapPlugin
        name: "mapboxgl" // "mapboxgl", "esri", ...
        // specify plugin parameters if necessary
        // PluginParameter {
        //     name:
        //     value:
        // }
    }

    Map {
        anchors.fill: parent
        plugin: mapPlugin
        center: QtPositioning.coordinate(59.91, 10.75) // Oslo
        zoomLevel: 14
    }
}