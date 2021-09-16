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
	qInfo() << "Flarm init \n";
	for(uint8_t i = 0;i < ports.size(); i++)
	{
		qInfo()<< "Port: " << ports.takeAt(i).portName() << "\n";

		if(ports.takeAt(i).portName().compare("ttyAMA0"))
		{
		    m_serialPort->setPort(ports.takeAt(i));
		}
	}
	m_serialPort->setBaudRate(QSerialPort::Baud9600,QSerialPort::AllDirections);
	m_serialPort->setStopBits(QSerialPort::OneStop);
	m_serialPort->setParity(QSerialPort::NoParity);
	m_serialPort->setDataBits(QSerialPort::Data8);
	m_serialPort->setFlowControl(QSerialPort::NoFlowControl);
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
    qInfo() << sentence;
    while( m_textStream.readLineInto(&sentence) ) {
        processFLARMSentence(sentence);
    }

}




