/*
 * Flarm.cpp
 *
 *  Created on: 02.12.2020
 *      Author: markus
 */
#include "Flarm.h"
#include <QDebug>
#include <QList>

Flarm::Flarm()
{
	m_serialPort = new QSerialPort(this);
	QList<QSerialPortInfo> ports = QSerialPortInfo::availablePorts();
	QList<QSerialPortInfo>::iterator info;
	qInfo()<< "Flarm init \n";
	for(info = ports.begin(); info != ports.end(); info++)
	{
		qInfo()<< "Port: " << info->portName() << "\n";
	}
	connect(m_serialPort, &QSerialPort::readyRead, this, &Flarm::handleReadyRead);
}

Flarm::~Flarm()
{

}

void Flarm::handleReadyRead()
{
    m_readData.append(m_serialPort->readAll());
}

bool Flarm::trafficAvailable()
{
	return isTraffic;
}

bool Flarm::connectionstatus()
{

}
