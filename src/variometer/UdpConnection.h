/*
 * udpConnection.h
 *
 *  Created on: 11.12.2020
 *      Author: markus
 */

#ifndef SRC_UDPCONNECTION_H_
#define SRC_UDPCONNECTION_H_

#include <QtNetwork>

class UdpConnection : public QObject
{
	Q_OBJECT
	public:

		UdpConnection();
		void initSocket(int port);
		void readData();
		void sendData(char *data);

	signals:
		void	dataAvailable(QByteArray data);
	private:
		QUdpSocket *udpSocket;
};


#endif /* SRC_UDPCONNECTION_H_ */
