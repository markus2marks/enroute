/*
 * udpConnection.cpp
 *
 *  Created on: 11.12.2020
 *      Author: markus
 */


#include "UdpConnection.h"

UdpConnection::UdpConnection()
{

}

void UdpConnection::initSocket()
{
	udpSocket = new QUdpSocket(this);
	udpSocket->bind(QHostAddress::AnyIPv4,8888);//Bind IP and address

	connect(udpSocket, &QUdpSocket::readyRead,this, &UdpConnection::readData);
}

void UdpConnection::readData()
{
	QByteArray datagram;

	while (udpSocket->hasPendingDatagrams()) {
		datagram.resize(int(udpSocket->pendingDatagramSize()));
		udpSocket->readDatagram(datagram.data(), datagram.size());
		qInfo() << "Received datagram:" << datagram.constData() << "\n";
	}
}

