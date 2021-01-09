/*
 * Variometer.h
 *
 *  Created on: 11.12.2020
 *      Author: markus
 */

#ifndef SRC_VARIOMETER_H_
#define SRC_VARIOMETER_H_

#include "UdpConnection.h"


class Variometer : public QObject
{
	Q_OBJECT
	public:

		Variometer();

	private:
		UdpConnection *data;
};




#endif /* SRC_VARIOMETER_H_ */
