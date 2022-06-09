/*
 * Display.h
 *
 *  Created on: Feb 25, 2022
 *      Author: markus
 */

#ifndef SRC_VARIOMETER_DISPLAY_H_
#define SRC_VARIOMETER_DISPLAY_H_

#include <QMainWindow>
#include "qcgaugewidget.h"

namespace Ui {
class Display;
}

class Display : public QMainWindow
{
    Q_OBJECT

public:
    Display(QWidget *parent = 0);
    ~Display();
    void valueChanged(float value);
    void initVarioGauge();
    void initTrafficRadar();
    void showDisplay();
private:
    Ui::Display *ui;

	QcGaugeWidget * mVarioGauge;
	QcGaugeWidget * mTrafficRadar;
	QcNeedleItem *mVarioNeedle;
	float m_value;

};



#endif /* SRC_VARIOMETER_DISPLAY_H_ */
