/*
 * DiagSensorboard.cpp
 *
 *  Created on: Mar 14, 2021
 *      Author: markus
 */

#include "DiagSensorboard.h"


DiagSensorboard::DiagSensorboard(UdpConnection* udpConnection) : m_udpConnection(udpConnection)
{
	connect(m_udpConnection, &UdpConnection::dataAvailable,this, &DiagSensorboard::receiveDiagResponse);
}


bool DiagSensorboard::sendDiagRequest(int ID, char* data)
{
	bool ret = true;
	if(diagRequestPending == false)
	{
		diagRequestPending = true;
		txData.id = ID;
		txData.data[0] = data[0];
		m_udpConnection->sendData((char*)&txData);
	}
	else
	{
		ret = false;
	}
	return ret;
}

void DiagSensorboard::receiveDiagResponse(QByteArray data)
{
	struct diag_data* rxData = (struct diag_data*)  data.data();
	if(diagRequestPending == true)
	{
		diagRequestPending = false;
		qInfo() << "Receive DiagResponse" << rxData->id;
	}
}
