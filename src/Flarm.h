/*
 * Flarm.h
 *
 *  Created on: 02.12.2020
 *      Author: markus
 */

#ifndef SRC_FLARM_H_
#define SRC_FLARM_H_

#include <QSerialPort>
#include <QSerialPortInfo>
#include <QtCore>

class Flarm : public QThread
{
    Q_OBJECT


	public:



	Flarm();
	~Flarm();
	bool trafficAvailable();
	void handleReadyRead();

	private:
		QByteArray m_readData;
		QTextStream m_standardOutput;
		QSerialPort *m_serialPort;
		bool isTraffic = false;
};


#endif /* SRC_FLARM_H_ */
