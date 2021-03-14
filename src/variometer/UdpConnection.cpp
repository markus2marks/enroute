/*
 * udpConnection.cpp
 *
 *  Created on: 11.12.2020
 *      Author: markus
 */


#include "UdpConnection.h"

UdpConnection::UdpConnection(int port) : m_port(port)
{

}

void UdpConnection::initSocket()
{

	udpSocket = new QUdpSocket(this);
	udpSocket->bind(QHostAddress("0.0.0.0"), m_port);//Bind IP and address
	connect(udpSocket, &QUdpSocket::readyRead,this, &UdpConnection::readData);
	qInfo() << "Udp Socket init\n";
}

void UdpConnection::readData()
{
	QByteArray datagram;
	while (udpSocket->hasPendingDatagrams()) {
		datagram.resize(int(udpSocket->pendingDatagramSize()));
		udpSocket->readDatagram(datagram.data(), datagram.size());
		emit dataAvailable(datagram);
	}
}


void UdpConnection::sendData(char *data)
{
    udpSocket->writeDatagram((const char*)data, QHostAddress("192.168.0.3"), m_port);
}
