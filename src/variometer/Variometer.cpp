/*
 * Variometer.cpp
 *
 *  Created on: 11.12.2020
 *      Author: markusx
 */
#include "Variometer.h"
#include "QWindow"
#include <QApplication>
#include <QScreen>

Variometer::Variometer ()
{
    m_kalmanfilter = new KalmanFilter();
    m_kalmanfilter->Configure(Z_VARIANCE, ZACCEL_VARIANCE, ZACCELBIAS_VARIANCE,980,0.001f,0.001f);
    UdpConnection* udpConnection = new UdpConnection(7u);

    m_dataswitch = new DataSwitch(udpConnection);
    m_dataswitch->openConnection();
    connect(m_dataswitch, &DataSwitch::sensorDataAvailable,this, &Variometer::readSensordata);
    newDataAvailable = false;

//    QScreen * s = QGuiApplication::screens()[1];
//    qDebug() << "size " << s->size().height();
//    m_display->show();
//    QWindow *test =m_display->windowHandle();
//    m_display->windowHandle()->setScreen(s);
//    QScreen * s2 = test->screen();
//    qDebug() << "size 2 " << s2->size().height();

}


void Variometer::startVario()
{
    qDebug() << "open connection";
    m_dataswitch->openConnection();
    this->start();
}

float Variometer::calculateAltitude(float pressure)
{
    float altitude = ((pow(102300.0f / pressure, 1.0f/5.257f) - 1.0f) * 293.15f) /0.0065f;
//    qDebug() << "altitude: " << altitude;
    return altitude;
}

float Variometer::imu_gravityCompensatedAccel(float ax, float ay, float az, float q0, float q1, float q2, float q3)
{
    float acc = 2.0*(q1*q3 - q0*q2)*ax + 2.0f*(q0*q1 + q2*q3)*ay + (q0*q0 - q1*q1 - q2*q2 + q3*q3)*az;
    //acc *= 0.9807f; // in cm/s/s, assuming ax, ay, az are in milli-Gs
    return acc;
}


void Variometer::run()
{
    float pZ = 0.0f;
    float pV = 0.0f;
    int tmp_timestamp = 0;
    float a = 0;

    float sinValue = 0.0f;
    bool b = true;
    while(true)
    {
        if(newDataAvailable)
        {
            newDataAvailable = false;
            m_mutex.lock();
            a = imu_gravityCompensatedAccel(m_sensorData.ax, m_sensorData.ay, m_sensorData.az, m_sensorData.quat_w, m_sensorData.quat_x, m_sensorData.quat_y, m_sensorData.quat_z);
            qDebug() << a;
            m_kalmanfilter->Update(calculateAltitude((float)m_sensorData.sensor2 * 1.0f) * 100.0f, a, (float)(m_sensorData.timestamp - tmp_timestamp)/1000.0f, &pZ, &pV);
            qDebug() << "time " << (m_sensorData.timestamp - tmp_timestamp)/1000.0f << "\tpZ " << pZ <<"\tpV " << pV / 100.0f;
            tmp_timestamp = m_sensorData.timestamp;
            m_mutex.unlock();

        }

        	m_display->valueChanged(5 * sin(sinValue));

        	if((sinValue < 1.0) && (b == true))
        	{
        	   sinValue += 0.01f;
            }
            else if(sinValue > -1.0)
            {
            	sinValue -= 0.01f;
            	b = false;
            }
            else
            {
            	b = true;
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
