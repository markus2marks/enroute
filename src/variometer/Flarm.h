/*
 * Flarm.h
 *
 *  Created on: 02.12.2020
 *      Author: markus
 */

#ifndef SRC_FLARM_H_
#define SRC_FLARM_H_

#include <QtSerialPort/QSerialPort>
#include <QtSerialPort/QSerialPortInfo>
#include <QtCore>

class Flarm : public QObject
{
    Q_OBJECT


	public:



	Flarm();
	~Flarm();
	bool trafficAvailable();
	void handleReadyRead();
	bool connectionstatus();

	private:
		QByteArray m_readData;
		QTextStream m_standardOutput;
		QSerialPort *m_serialPort;
		bool isTraffic = false;
};


#endif /* SRC_FLARM_H_ */
