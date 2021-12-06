/*
 * Variometer.h
 *
 *  Created on: 11.12.2020
 *      Author: markus
 */

#ifndef SRC_VARIOMETER_H_
#define SRC_VARIOMETER_H_

#include "KalmanFilter.h"
#include "DataSwitch.h"
#include <QThreadPool>

#define Z_VARIANCE          200.0f
#define ZACCEL_VARIANCE     100.0f
#define ZACCELBIAS_VARIANCE 1.0f


class Variometer : public QThread
{
	Q_OBJECT


	public:

		Variometer();
		void startVario();
		void run() override;

	public slots:
		void readSensordata(struct sensorData* sensordata);

	private:
		KalmanFilter* m_kalmanfilter;
		DataSwitch* m_dataswitch;
		int32_t m_sensorValue;
		bool newDataAvailable;
};




#endif /* SRC_VARIOMETER_H_ */
