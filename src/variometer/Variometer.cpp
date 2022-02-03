/*
 * Variometer.cpp
 *
 *  Created on: 11.12.2020
 *      Author: markus
 */
#include "Variometer.h"



Variometer::Variometer ()
{
    m_kalmanfilter = new KalmanFilter();
    m_kalmanfilter->Configure(Z_VARIANCE, ZACCEL_VARIANCE, ZACCELBIAS_VARIANCE,0,0.0f,0.0f);
    UdpConnection* udpConnection = new UdpConnection(7u);

    m_dataswitch = new DataSwitch(udpConnection);
    m_dataswitch->openConnection();
    connect(m_dataswitch, &DataSwitch::sensorDataAvailable,this, &Variometer::readSensordata);
    newDataAvailable = false;
}


void Variometer::startVario()
{
    qDebug() << "open connection";
    m_dataswitch->openConnection();
    this->start();
}

float Variometer::calculateAltitude(float pressure)
{
    float altitude = ((pow(101325.0f / pressure, 1.0f/5.257f) - 1.0f) * 293.15f) /0.0065f;
   // qDebug() << "altitude: " << altitude;
    return altitude;
}
void Variometer::run()
{
    float pZ = 0.0f;
    float pV = 0.0f;
    int tmp_timestamp = 0;
    while(true)
    {
        if(newDataAvailable)
        {
            newDataAvailable = false;
            m_mutex.lock();
            m_kalmanfilter->Update(calculateAltitude((float)m_sensorData.sensor2 * 1.0f) * 100.0f, m_sensorData.az, (float)(m_sensorData.timestamp - tmp_timestamp), &pZ, &pV);
            tmp_timestamp = m_sensorData.timestamp;
            m_mutex.unlock();
            qDebug() << "pZ" << pZ <<"\tpV " << pV;
        }
        QThread::msleep(20);
    }
}

void Variometer::readSensordata(struct sensorData* sensordata)
{
    static uint32_t timestamp_tmp = 0u;
    if((sensordata->timestamp - timestamp_tmp) != 0u)
    {
        newDataAvailable = true;
        m_mutex.lock();
        m_sensorData = *sensordata;
        m_mutex.unlock();
    }
    timestamp_tmp = sensordata->timestamp;

}
