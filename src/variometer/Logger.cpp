/*
 * Logger.cpp
 *
 *  Created on: 15.01.2021
 *      Author: markus
 */

#include "Logger.h"

/*
 * init logger to store data every second
 */
Logger::Logger(QString path)
{
	m_file = new QFile(path);
	m_fileopen = m_file->open(QIODevice::ReadWrite);
}

/*
 * Deconstructor
 */
Logger::~Logger()
{

}

/*
 * this function stores avarage of data in a file
 */
void Logger::run()
{
	if(m_fileopen)
	{
		QTextStream in(m_file);
	}
	msleep(1000U);
}

/*
 * this functions stores all incomming data in a vector
 */
void Logger::storeData(struct sensorData* Data)
{

}
