/*
 * KalmanFilter.h
 *
 *  Created on: 16.12.2020
 *      Author: markus
 */

#ifndef SRC_KALMANFILTER_H_
#define SRC_KALMANFILTER_H_

#include <QQmlComponent>

class KalmanFilter: QObject
{
	public:
		KalmanFilter();
		int filterUpdate(int32_t input, float var);

	private:
		float k_gain;
		QVector<int> values;

		float calculateVariance(int32_t value);
		float calculateAverage(int32_t value);

};


#endif /* SRC_KALMANFILTER_H_ */
