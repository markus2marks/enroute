/*
 * DataSwitch.cpp
 *
 *  Created on: 15.12.2020
 *      Author: markus
 */

#include "DataSwitch.h"


DataSwitch::DataSwitch(UdpConnection* udpConnection, QQmlApplicationEngine* engine):m_udpConnection(udpConnection)
{
	m_udpConnection->initSocket();
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
	struct sensorData* sensorData = (struct sensorData*) data.data();

	int32_t filterValue2 = kalman2->filterUpdate(sensorData->sensor2, 0.2f);
	int32_t filterValue5 = kalman5->filterUpdate(sensorData->sensor5, 0.2f);

	qInfo() << "timestamp: " << sensorData->timestamp << \
	"\tp1: " << sensorData->sensor1 << \
	"\tp2: " << sensorData->sensor2 << \
	"\tp3: " << sensorData->sensor3 << \
	"\tp4: " << sensorData->sensor4 << \
	"\tp5: " << sensorData->sensor5 << \
	"\ttemp: " << sensorData->temp << \
	"\tout2: " << filterValue2 << \
	"\tout5: " << filterValue5 ;
	qInfo() << " ";
}
