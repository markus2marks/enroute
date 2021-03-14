/*
 * DataSwitch.cpp
 *
 *  Created on: 15.12.2020
 *      Author: markus
 */

#include "DataSwitch.h"


DataSwitch::DataSwitch(UdpConnection* udpConnection, QQmlApplicationEngine* engine):m_udpConnection(udpConnection)
{
	connect(m_udpConnection, &UdpConnection::dataAvailable,this, &DataSwitch::setData);

	QQmlComponent component(engine, QUrl::fromLocalFile("VarioManager.qml"));
	object = component.create();
	QMetaObject::invokeMethod(object, "addPoint",Q_ARG(float, 0.1),Q_ARG(float, 0.2));

	kalman5 = new KalmanFilter();
	kalman2 = new KalmanFilter();
}

/*
 * get Data from Network and analyse this
 */
void DataSwitch::setData(QByteArray data)
{
	m_sensorData = (struct sensorData*) data.data();

	int32_t filterValue2 = kalman2->filterUpdate(m_sensorData->sensor2, 0.2f);
	int32_t filterValue5 = kalman5->filterUpdate(m_sensorData->sensor5, 0.2f);

	/*qInfo() << "timestamp: " << m_sensorData->timestamp << \
	"\tp1: " << m_sensorData->sensor1 << \
	"\tp2: " << m_sensorData->sensor2 << \
	"\tp3: " << m_sensorData->sensor3 << \
	"\tp4: " << m_sensorData->sensor4 << \
	"\tp5: " << m_sensorData->sensor5 << \
	"\tp6: " << m_sensorData->sensor6 << \
	"\tp7: " << m_sensorData->sensor7 << \
	"\ttemp: " << m_sensorData->temp2 << \
	"\tout2: " << filterValue2 << \
	"\tout5: " << filterValue5 ;
	qInfo() << " ";*/
	emit sensorDataAvailable(m_sensorData);
}
