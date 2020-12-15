/*
 * Variometer.cpp
 *
 *  Created on: 11.12.2020
 *      Author: markus
 */
#include "Variometer.h"



Variometer::Variometer()
{
	data = new UdpConnection();
	data->initSocket();
}
