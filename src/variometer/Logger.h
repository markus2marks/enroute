/*
 * Logger.h
 *
 *  Created on: 15.01.2021
 *      Author: markus
 */

#ifndef SRC_VARIOMETER_LOGGER_H_
#define SRC_VARIOMETER_LOGGER_H_

#include <QSerialPort>
#include <QSerialPortInfo>
#include <QtCore>
#include <QTextStream>
#include "DataSwitch.h"

class Logger : public QThread
{
    Q_OBJECT


	public:
		Logger(QString path);
		~Logger();
		void run() override;
		void setSensordata(struct sensorData data);
	private:
		QFile* m_file;
		QVector<struct sensorData> values;
		bool m_fileopen;

	public slots:
		void storeData(struct sensorData* Data);
};



#endif /* SRC_VARIOMETER_LOGGER_H_ */
