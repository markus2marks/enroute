/*
 * TrafficDataSource_Serial.cpp
 *
 *  Created on: 24.08.2021
 *      Author: markus
 */

#include "traffic/TrafficDataSource_Serial.h"


// Member functions

Traffic::TrafficDataSource_Serial::TrafficDataSource_Serial(QObject *parent) :
    Traffic::TrafficDataSource_AbstractSocket(parent)
{

	m_serialPort = new QSerialPort(this);
	QList<QSerialPortInfo> ports = QSerialPortInfo::availablePorts();
	QList<QSerialPortInfo>::iterator info;
	qInfo()<< "Flarm init \n";
	for(info = ports.begin(); info != ports.end(); info++)
	{
		qInfo()<< "Port: " << info->portName() << "\n";
	}
	connect(m_serialPort, &QSerialPort::readyRead, this, &TrafficDataSource_Serial::onReadyRead);

}


Traffic::TrafficDataSource_Serial::~TrafficDataSource_Serial()
{

    Traffic::TrafficDataSource_Serial::disconnectFromTrafficReceiver();
    setReceivingHeartbeat(false); // This will release the WiFi lock if necessary

}


void Traffic::TrafficDataSource_Serial::connectToTrafficReceiver()
{
	m_serialPort->open(QIODevice::ReadWrite);
}


void Traffic::TrafficDataSource_Serial::disconnectFromTrafficReceiver()
{
	m_serialPort->close();
}


void Traffic::TrafficDataSource_Serial::onReadyRead()
{

    QString sentence;
    m_readData.append(m_serialPort->readAll());
    sentence = (QString)m_readData;
    while( m_textStream.readLineInto(&sentence) ) {
        processFLARMSentence(sentence);
    }

}




