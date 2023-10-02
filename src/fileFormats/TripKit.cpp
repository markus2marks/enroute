/***************************************************************************
 *   Copyright (C) 2023 by Stefan Kebekus                                  *
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

#include <QFile>
#include <QGeoCoordinate>
#include <QImage>
#include <QJsonDocument>
#include <QJsonObject>

#include "fileFormats/TripKit.h"


FileFormats::TripKit::TripKit(const QString& fileName)
    : m_zip(fileName)
{
    if (!m_zip.isValid())
    {
        setError(m_zip.error());
        return;
    }

    auto errorMsg1 = readTripKitData();
    setError(errorMsg1);
}

QString FileFormats::TripKit::extract(const QString &directoryPath, qsizetype index)
{
    if ((index < 0) || (index >= m_entries.size()))
    {
        return {};
    }
    auto entry = m_entries.at(index);

    auto newPath = u"%1/%2-geo_%3_%4_%5_%6.webp"_qs
                       .arg(directoryPath, entry.name)
                       .arg(entry.topLeft.longitude())
                       .arg(entry.topLeft.latitude())
                       .arg(entry.bottomRight.longitude())
                       .arg(entry.bottomRight.latitude());

    auto imageData = m_zip.extract(entry.path);
    if (imageData.isEmpty())
    {
        imageData = m_zip.extract("charts/"+entry.name+"-geo."+entry.ending);
    }
    if (imageData.isEmpty())
    {
        return {};
    }

    if (entry.ending == u"webp"_qs)
    {
        QFile outFile(newPath);
        if (!outFile.open(QIODeviceBase::WriteOnly))
        {
            return {};
        }
        if (outFile.write(imageData) != imageData.size())
        {
            outFile.close();
            outFile.remove();
            return {};
        }
        outFile.close();
    }
    else
    {
        QImage const img = QImage::fromData(imageData);
        if (!img.save(newPath))
        {
            QFile::remove(newPath);
            return {};
        }
    }
    return newPath;
}

QString FileFormats::TripKit::readTripKitData()
{
    {
        auto json = m_zip.extract(u"toc.json"_qs);
        if (json.isNull())
        {
            return QObject::tr("The zip archive does not contain the required file 'toc.json'.", "FileFormats::TripKit");
        }
        auto jDoc = QJsonDocument::fromJson(json);
        if (jDoc.isNull())
        {
            return QObject::tr("The file 'toc.json' from the zip archive cannot be interpreted.", "FileFormats::TripKit");
        }
        auto rootObject = jDoc.object();
        m_name = rootObject[u"name"_qs].toString();
    }

    {
        auto json = m_zip.extract(u"charts/charts_toc.json"_qs);
        if (json.isNull())
        {
            return QObject::tr("The zip archive %1 does not contain the required file 'charts/charts_toc.json'.", "FileFormats::TripKit");
        }
        auto jDoc = QJsonDocument::fromJson(json);
        if (jDoc.isNull())
        {
            return QObject::tr("The file 'charts/charts_toc.json' from the zip archive %1 cannot be interpreted.", "FileFormats::TripKit");
        }
        auto rootObject = jDoc.object();
        m_charts = rootObject[u"charts"_qs].toArray();
        if (m_charts.isEmpty())
        {
            return QObject::tr("The trip kit does not contain any charts.", "FileFormats::TripKit");
        }

        foreach (auto chart, m_charts)
        {
            chartEntry entry;
            entry.name = chart.toObject()[u"name"_qs].toString();
            entry.path = chart.toObject()[u"filePath"_qs].toString();

            auto idx = entry.path.lastIndexOf('.');
            if (idx >= 0)
            {
                entry.ending = entry.path.mid(idx+1, -1).toLower();
            }

            entry.topLeft.setLatitude(chart.toObject()[u"geoCorners"_qs].toObject()[u"upperLeft"_qs].toObject()[u"latitude"_qs].toDouble());
            entry.topLeft.setLongitude(chart.toObject()[u"geoCorners"_qs].toObject()[u"upperLeft"_qs].toObject()[u"longitude"_qs].toDouble());
            entry.topRight.setLatitude(chart.toObject()[u"geoCorners"_qs].toObject()[u"upperRight"_qs].toObject()[u"latitude"_qs].toDouble());
            entry.topRight.setLongitude(chart.toObject()[u"geoCorners"_qs].toObject()[u"upperRight"_qs].toObject()[u"longitude"_qs].toDouble());
            entry.bottomLeft.setLatitude(chart.toObject()[u"geoCorners"_qs].toObject()[u"lowerLeft"_qs].toObject()[u"latitude"_qs].toDouble());
            entry.bottomLeft.setLongitude(chart.toObject()[u"geoCorners"_qs].toObject()[u"lowerLeft"_qs].toObject()[u"longitude"_qs].toDouble());
            entry.bottomRight.setLatitude(chart.toObject()[u"geoCorners"_qs].toObject()[u"lowerRight"_qs].toObject()[u"latitude"_qs].toDouble());
            entry.bottomRight.setLongitude(chart.toObject()[u"geoCorners"_qs].toObject()[u"lowerRight"_qs].toObject()[u"longitude"_qs].toDouble());

            if (!entry.topLeft.isValid() ||
                !entry.topRight.isValid() ||
                !entry.bottomLeft.isValid() ||
                !entry.bottomRight.isValid())
            {
                addWarning( QObject::tr("The coordinates for the entry '%1' in the trip kit are invalid.", "FileFormats::TripKit").arg(entry.name) );
                continue;
            }

            m_entries += entry;
        }
    }
    return {};
}
