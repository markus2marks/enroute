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
    UdpConnection* udpConnection = new UdpConnection(22);
    m_dataswitch = new DataSwitch(udpConnection);

    connect(m_dataswitch, &DataSwitch::sensorDataAvailable,this, &Variometer::readSensordata);
    newDataAvailable = false;
}


void Variometer::startVario()
{
    this->start();
}


void Variometer::run()
{
    while(true)
    {
        if(newDataAvailable)
        {
            //m_kalmanfilter->Update(baro.zCmSample_, zAccelAverage, kfTimeDeltaUSecs/1000000.0f, &kfAltitudeCm, &kfClimbrateCps);
        }
        qDebug() << "Hello world from thread" << QThread::currentThread();
        QThread::msleep(1000);
    }
}

void Variometer::readSensordata(struct sensorData* sensordata)
{
    static uint32_t timestamp_tmp = 0u;
    m_sensorValue = sensordata->sensor1;
    if((sensordata->timestamp - timestamp_tmp) != 0u)
    {
        newDataAvailable = true;
    }

    timestamp_tmp = sensordata->timestamp;

}
