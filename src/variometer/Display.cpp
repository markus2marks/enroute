/*
 * Display.cpp
 *
 *  Created on: Feb 25, 2022
 *      Author: markus
 */

#include "Display.h"
#include <QtGui>


Display::Display(QWidget *parent) :
	QMainWindow(parent)
{

    mSpeedGauge = new QcGaugeWidget;
//    mSpeedGauge->addBackground(99);
//    QcBackgroundItem *bkg1 = mSpeedGauge->addBackground(92);
//    bkg1->clearrColors();
//    bkg1->addColor(0.1,Qt::black);
//    bkg1->addColor(1.0,Qt::white);
//
    QcBackgroundItem *bkg2 = mSpeedGauge->addBackground(88);
    bkg2->clearrColors();
    bkg2->addColor(0.1,Qt::black);
    //bkg2->addColor(1.0,Qt::darkGray);


    mSpeedGauge->addArc(55);

    QcDegreesItem* degreesItem = mSpeedGauge->addDegrees(5);
    degreesItem->setValueRange(-5.0,5.0);
    degreesItem->setStep(0.1);

    QcColorBand* colorBand = mSpeedGauge->addColorBand(50);
    colorBand->setValueRange(-5,5);

    QcValuesItem* valuesItem = mSpeedGauge->addValues(80);
    valuesItem->setStep(1);
    valuesItem->setValueRange(-5,5);


    QcLabelItem* label = mSpeedGauge->addLabel(70);
    label->setText("m/s");
    label->setAngle(180);
    QcLabelItem *lab = mSpeedGauge->addLabel(40);
    lab->setText("0.0");
    lab->setAngle(180);

    mSpeedNeedle = mSpeedGauge->addNeedle(90);
    mSpeedNeedle->setLabel(lab);
    mSpeedNeedle->setColor(Qt::white);
   // mSpeedNeedle->
    mSpeedNeedle->setValueRange(-5,5);
    //mSpeedNeedle->setDgereeRange(-5,5);
    mSpeedGauge->addBackground(8);
    setCentralWidget(mSpeedGauge);
    m_value = 0.0f;
}

Display::~Display()
{
    delete this;
}

void Display::valueChanged(float value)
{

	if(m_value < value)
	{
		m_value += 0.1f;
	}
	else if(m_value > value)
	{
		m_value -= 0.1f;
	}
	mSpeedNeedle->setCurrentValue(value);
}
