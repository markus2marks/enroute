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
#include <QMutex>
#include "display/Display.h"

#define Z_VARIANCE          20.0f
#define ZACCEL_VARIANCE     10.0f
#define ZACCELBIAS_VARIANCE 0.1f


class Variometer : public QThread
{
	Q_OBJECT


	public:

		Variometer();
		void startVario();
		void run() override;
		float calculateAltitude(float pressure);
		float imu_gravityCompensatedAccel(float ax, float ay, float az, float q0, float q1, float q2, float q3);

	public slots:
		void readSensordata(struct sensorData* sensordata);

	private:
		KalmanFilter* m_kalmanfilter;
		DataSwitch* m_dataswitch;
		sensorData m_sensorData;
		bool newDataAvailable;
		QMutex m_mutex;
		Display* m_display;
};




#endif /* SRC_VARIOMETER_H_ */
