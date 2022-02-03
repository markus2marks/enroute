/*
 * DataSwitch.cpp
 *
 *  Created on: 15.12.2020
 *      Author: markus
 */

#include "DataSwitch.h"


DataSwitch::DataSwitch(UdpConnection* udpConnection):m_udpConnection(udpConnection)
{
	connect(m_udpConnection, &UdpConnection::dataAvailable,this, &DataSwitch::setData);

//	QQmlComponent component(engine, QUrl::fromLocalFile("VarioManager.qml"));
//	object = component.create();
//	QMetaObject::invokeMethod(object, "addPoint",Q_ARG(float, 0.1),Q_ARG(float, 0.2));

}

/*
 *
 */
void DataSwitch::openConnection()
{
    m_udpConnection->initSocket();
}
/*
 * get Data from Network and analyse this
 */
void DataSwitch::setData(QByteArray data)
{
	m_sensorData = (struct sensorData*) data.data();

	qInfo() << "timestamp: " << m_sensorData->timestamp << \
	"\tp1: " << m_sensorData->sensor1 << \
	"\tp2: " << m_sensorData->sensor2 << \
	"\tp3: " << m_sensorData->sensor3 << \
	"\ttemp: " << m_sensorData->temp2 ;
	qInfo() << " ";
	emit sensorDataAvailable(m_sensorData);
}
