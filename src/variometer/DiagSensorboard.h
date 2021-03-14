/*
 * DiagSensorboard.h
 *
 *  Created on: Mar 14, 2021
 *      Author: markus
 */

#ifndef SRC_VARIOMETER_DIAGSENSORBOARD_H_
#define SRC_VARIOMETER_DIAGSENSORBOARD_H_


#include "UdpConnection.h"
#include <QQmlApplicationEngine>
#include <QQmlComponent>


#define DIAG_BOARD_ID 0x50

struct diag_data
{
	char id;
	char data[8];
};


class DiagSensorboard : public QObject
{
	Q_OBJECT
	public:
		DiagSensorboard(UdpConnection* udpConnection);
		bool sendDiagRequest(int ID, char* data);
		void receiveDiagResponse(QByteArray data);
	private:
		UdpConnection *m_udpConnection;
		bool diagRequestPending;
		struct diag_data txData;
};



#endif /* SRC_VARIOMETER_DIAGSENSORBOARD_H_ */
