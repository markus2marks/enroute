/*
 * DataSwitch.h
 *
 *  Created on: 15.12.2020
 *      Author: markus
 */

#ifndef SRC_DATASWITCH_H_
#define SRC_DATASWITCH_H_

#include "UdpConnection.h"
#include "KalmanFilter.h"
#include <QQmlApplicationEngine>
#include <QQmlComponent>

struct sensorData
{
			uint8_t id;
			uint32_t timestamp;
			int32_t sensor1;
			int32_t sensor2;
			int32_t sensor3;
			int32_t sensor4;
			int32_t sensor5;
			int32_t sensor6;
			int32_t sensor7;
			int32_t temp1;
			int32_t temp2;
			int32_t temp3;
			int32_t temp4;
			int32_t temp5;
			int32_t temp6;
			int32_t temp7;
};


class DataSwitch : public QObject
{
	Q_OBJECT
	public:

		DataSwitch(UdpConnection* udpConnection);
		bool sendData(void* data);
	public slots:
		void setData(QByteArray data);
	signals:
		void sensorDataAvailable(struct sensorData* sensorData);
	private:
		UdpConnection *m_udpConnection;
		struct sensorData* m_sensorData;
		QObject *object;
};



#endif /* SRC_DATASWITCH_H_ */
