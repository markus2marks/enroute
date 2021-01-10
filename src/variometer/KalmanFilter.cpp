/*
 * KalmanFilter.cpp
 *
 *  Created on: 16.12.2020
 *      Author: markus
 */

#include "KalmanFilter.h"

KalmanFilter::KalmanFilter()
{

}

float KalmanFilter::calculateAverage(int32_t value)
{
	float sum = 0;

	for(int i = 0; i < values.size(); i++)
	{
		sum += values.at(i);
	}
	sum /= values.size();

	return sum;
}

float KalmanFilter::calculateVariance(int32_t value)
{
	float average = calculateAverage(value);
	float tmp = 0.0f;
	for(int i = 0; i < values.size(); i++)
	{
		tmp += ((float)values.at(i) - average) * ((float)values.at(i) - average);
	}
	return (tmp / (float)(values.size()));
}

int KalmanFilter::filterUpdate(int32_t input, float var)
{
	static int32_t count = 0;
	static float tmp = 1;

	float var_new;

	if(values.size() < 10)
	{
		var_new = 0.1;
	}
	else
	{
		var_new = calculateVariance(input);
	}
	//k_gain = var_new / (float)(var_new + var);
	k_gain = tmp / (float)(tmp + var);

	tmp = (float)tmp + k_gain * ((float)input - (float)tmp);

	//add value to array
	if(values.size() < 20)
	{
		values.append(tmp);
	}
	else
	{
		values.removeFirst();
		values.append(tmp);
	}


	return tmp;
}

