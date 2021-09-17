/*
 * TrafficDataSource_Serial.h
 *
 *  Created on: 24.08.2021
 *      Author: markus
 */

#ifndef SRC_TRAFFIC_TRAFFICDATASOURCE_SERIAL_H_
#define SRC_TRAFFIC_TRAFFICDATASOURCE_SERIAL_H_

#include <QPointer>
#include <QtSerialPort/QSerialPort>
#include <QtSerialPort/QSerialPortInfo>
#include <QtCore>
#include <QDebug>
#include <QList>
#include "traffic/TrafficDataSource_AbstractSocket.h"


namespace Traffic {

/*! \brief Traffic receiver: TCP connection to FLARM/NMEA source
 *
 *  This class connects to a traffic receiver via a TCP connection. It expects
 *  to find a receiver at the specifed IP-Address and port that emits FLARM/NMEA
 *  sentences.
 *
 *  In most use cases, the connection will be established via the device's WiFi
 *  interface.  The class will therefore try to lock the WiFi once a heartbeat
 *  has been detected, and release the WiFi at the appropriate time.
 */

class TrafficDataSource_Serial : public TrafficDataSource_AbstractSocket {
    Q_OBJECT

public:
    /*! \brief Default constructor
     *
     *  @param hostName Name of the host where the traffic receiver is expected
     *
     *  @param port Port at the host where the traffic receiver is expected
     *
     * @param parent The standard QObject parent pointer
     */
    explicit TrafficDataSource_Serial(QObject *parent = nullptr);

    // Standard destructor
    ~TrafficDataSource_Serial() override;

    /*! \brief Getter function for the property with the same name
     *
     *  This method implements the pure virtual method declared by its superclass.
     *
     *  @returns Property sourceName
     */
    QString sourceName() const override
    {
        return "";
    }

public slots:
    /*! \brief Start attempt to connect to traffic receiver
     *
     *  This method implements the pure virtual method declared by its superclass.
     */
    void connectToTrafficReceiver() override;

    /*! \brief Disconnect from traffic receiver
     *
     *  This method implements the pure virtual method declared by its superclass.
     */
    void disconnectFromTrafficReceiver() override;

private slots:
    // Read lines from the socket's text stream and passes the string on to
    // processFLARMMessage.
    void onReadyRead();

private:
    quint16 m_port;
    QByteArray m_readData;
    QTextStream m_standardOutput;
    QSerialPort *m_serialPort;
};

}


#endif /* SRC_TRAFFIC_TRAFFICDATASOURCE_SERIAL_H_ */
