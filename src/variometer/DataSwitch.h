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

struct sensorData{
			uint8_t id;
			uint32_t timestamp;
			int32_t sensor1;
			int32_t sensor2;
			int32_t sensor3;
			int32_t sensor4;
			int32_t sensor5;
			int32_t temp;
};


class DataSwitch : public QObject
{
	Q_OBJECT
	public:

		DataSwitch(UdpConnection* udpConnection, QQmlApplicationEngine* engine);

	public slots:
		void setData(QByteArray data);

	private:
		UdpConnection *m_udpConnection;
		QByteArray sensordata;
		QList<QVector<QPointF> > m_sensorData;
		QObject *object;
		KalmanFilter* kalman1;
		KalmanFilter* kalman2;
		KalmanFilter* kalman3;
		KalmanFilter* kalman4;
		KalmanFilter* kalman5;
};



#endif /* SRC_DATASWITCH_H_ */
