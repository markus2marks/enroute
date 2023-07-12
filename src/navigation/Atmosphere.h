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

#pragma once

#include <QQmlEngine>

#include "GlobalObject.h"


#if defined(Q_OS_ANDROID) or defined(Q_OS_IOS)
#include <QAmbientTemperatureSensor>
#include <QPressureSensor>
#endif


namespace Navigation {

/*! \brief Atmospherical data
 *
 *  This class collects data from ambient pressure/temperature sensors and computes
 *  pressure/density heights.
 *
 */

class Atmosphere : public GlobalObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    //
    // Constructors and destructors
    //

    /*! \brief Standard constructor
     *
     * @param parent The standard QObject parent pointer
     */
    explicit Atmosphere(QObject* parent = nullptr);

    // deferred initialization
    void deferredInitialization() override;

    // No default constructor, important for QML singleton
    explicit Atmosphere() = delete;

    /*! \brief Standard destructor */
    ~Atmosphere() override = default;

    // factory function for QML singleton
    static Navigation::Atmosphere* create(QQmlEngine* /*unused*/, QJSEngine* /*unused*/)
    {
        return GlobalObject::atmosphere();
    }


    //
    // PROPERTIES
    //

    /*! \brief Ambient pressure
     *
     *  This property holds the ambient pressure recorded by the device sensor (if any).
     */
    Q_PROPERTY(double ambientPressure READ ambientPressure NOTIFY ambientPressureChanged)

    /*! \brief Ambient temperature
     *
     *  This property holds the ambient temperature recorded by the device sensor (if any).
     */
    Q_PROPERTY(double ambientTemperature READ ambientTemperature NOTIFY ambientTemperatureChanged)


    //
    // Getter Methods
    //

    /*! \brief Getter function for the property with the same name
     *
     *  @returns Property ambientPressure
     */
    [[nodiscard]] double ambientPressure() const { return m_ambientPressure; }

    /*! \brief Getter function for the property with the same name
     *
     *  @returns Property ambientPressure
     */
    [[nodiscard]] double ambientTemperature() const { return m_ambientTemperature; }


signals:
    /*! \brief Notifier signal */
    void ambientPressureChanged();

    /*! \brief Notifier signal */
    void ambientTemperatureChanged();

private slots:
    // Update sensor readings. For performance reasons, we poll sensors.
    void updateSensorReadings();

private:
    Q_DISABLE_COPY_MOVE(Atmosphere)

#if defined(Q_OS_ANDROID) or defined(Q_OS_IOS)
    // Ambient temperature sensor
    QAmbientTemperatureSensor m_temperatureSensor;

    // Ambient pressure sensor
    QPressureSensor m_pressureSensor;
#endif

    double m_ambientPressure { qQNaN() };
    double m_ambientTemperature { qQNaN() };
};

} // namespace Navigation
