/***************************************************************************
 *   Copyright (C) 2019-2023 by Stefan Kebekus                             *
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

import QtLocation
import QtQml
import QtQuick
import QtQuick.Controls

import QtLocation.MapLibre 3.0
import akaflieg_freiburg.enroute

Map {
    id: flightMap

    /*! \brief Pixel per 10 kilometer

    This read-only propery is set to the number of screen pixel per ten
    kilometers on the map. It is updated whenever the zoom value changes. If the
    value cannot be determined for whatever reason, the property is set to zero.

    @warning The value is only a rough approximation and can be wrong at times.
    */
    property real pixelPer10km: 0.0

    /*
    * Handle changes in zoom level
    */

    onZoomLevelChanged: {
        var vec1 = flightMap.fromCoordinate(flightMap.center, false)
        var vec2 = flightMap.fromCoordinate(flightMap.center.atDistanceAndAzimuth(10000.0, 0.0), false)
        var dx = vec2.x - vec1.x
        var dy = vec2.y - vec1.y
        pixelPer10km = Math.sqrt(dx*dx+dy*dy);
    }

    onMapReadyChanged: {
        onZoomLevelChanged(zoomLevel)
    }

    maximumZoomLevel: 13.5
    minimumZoomLevel: 7.0001  // When setting 7 precisely, MapBox is looking for tiles of zoom 6, which we do not have…


    MapLibre.style: Style {
        id: style

        SourceParameter {
            id: approachChart

            styleId: "vac"
            type: "image"

            property string url: {
                GeoMapProvider.approachChart
                console.log("url:" + GeoMapProvider.approachChart)

                var bbox = GeoMapProvider.approachChartBox
                if (!bbox.isValid)
                    approachChart.coordinates = [ [7, 48], [8, 48], [8, 47], [7, 47] ]
                else
                    approachChart.coordinates = [[bbox.topLeft.longitude, bbox.topLeft.latitude],
                                  [bbox.bottomRight.longitude, bbox.topLeft.latitude],
                                  [bbox.bottomRight.longitude, bbox.bottomRight.latitude],
                                  [bbox.topLeft.longitude, bbox.bottomRight.latitude]]

                if (GeoMapProvider.approachChart === "")
                    return "qrc:/icons/appIcon.png"
                else
                    return "file://" + GeoMapProvider.approachChart
            }

            property var coordinates: {
                GeoMapProvider.approachChart
                console.log("coordinate:" + GeoMapProvider.approachChart)

                var bbox = GeoMapProvider.approachChartBox
                if (!bbox.isValid)
                    return [ [7, 48], [8, 48], [8, 47], [7, 47] ]
                else
                    return [[bbox.topLeft.longitude, bbox.topLeft.latitude],
                                                 [bbox.bottomRight.longitude, bbox.topLeft.latitude],
                                                 [bbox.bottomRight.longitude, bbox.bottomRight.latitude],
                                                 [bbox.topLeft.longitude, bbox.bottomRight.latitude]]
            }

            onCoordinatesChanged: console.log(coordinates)

        }

        LayerParameter {
            id: approachChartLayer

            styleId: "vacLayer"
            type: "raster"
            property string source: "vac"

            layout: {
                "visibility": GeoMapProvider.approachChart === "" ? 'none' : 'visible'
            }
        }

        SourceParameter {
            id: waypointLib

            styleId: "waypointlib"
            type: "geojson"
            property string data: WaypointLibrary.GeoJSON
        }

        LayerParameter {
            id: waypointLibParam

            styleId: "waypoint-layer"

            type: "symbol"
            property string source: "waypointlib"

            layout: {
                "icon-image": '["get", "CAT"]',
                "text-field": '["get", "NAM"]',
                "text-size": 12,
                "text-anchor": "top",
                "text-offset": [0, 1],
                "text-optional": true,
            }

            paint: {
                "text-color": "black",
                "text-halo-width": 2,
                "text-halo-color": "white"
            }
        }

    }

} // End of FlightMap
