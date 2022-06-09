/*
 * Display.cpp
 *
 *  Created on: Feb 25, 2022
 *      Author: markus
 */

#include "Display.h"
#include <QtGui>
#include <QQmlComponent>
#include <QQmlEngine>

Display::Display(QWidget *parent) :
	QMainWindow(parent)
{


}

void Display::showDisplay()
{
    if(QGuiApplication::screens().size() >= 2)
    {
        this->move(2500,0);
        this->showFullScreen();
    }
    else
    {
        this->show();
    }
}


void Display::initVarioGauge()
{
    mVarioGauge = new QcGaugeWidget;
    //    mSpeedGauge->addBackground(99);
    //    QcBackgroundItem *bkg1 = mSpeedGauge->addBackground(92);
    //    bkg1->clearrColors();
    //    bkg1->addColor(0.1,Qt::black);
    //    bkg1->addColor(1.0,Qt::white);
    //
    QcBackgroundItem *bkg2 = mVarioGauge->addBackground(88);
    bkg2->clearrColors();
    bkg2->addColor(0.1,Qt::black);
    //bkg2->addColor(1.0,Qt::darkGray);


    mVarioGauge->addArc(55);

    QcDegreesItem* degreesItem = mVarioGauge->addDegrees(5);
    degreesItem->setValueRange(-5.0,5.0);
    degreesItem->setStep(0.1);

    QcColorBand* colorBand = mVarioGauge->addColorBand(50);
    colorBand->setValueRange(-5,5);

    QcValuesItem* valuesItem = mVarioGauge->addValues(80);
    valuesItem->setStep(1);
    valuesItem->setValueRange(-5,5);


    QcLabelItem* label = mVarioGauge->addLabel(70);
    label->setText("m/s");
    label->setAngle(180);
    QcLabelItem *lab = mVarioGauge->addLabel(40);
    lab->setText("0.0");
    lab->setAngle(180);

    mVarioNeedle = mVarioGauge->addNeedle(90);
    mVarioNeedle->setLabel(lab);
    mVarioNeedle->setColor(Qt::white);
   // mSpeedNeedle->
    mVarioNeedle->setValueRange(-5,5);
    //mSpeedNeedle->setDgereeRange(-5,5);
    mVarioGauge->addBackground(8);
    setCentralWidget(mVarioGauge);
    m_value = 0.0f;
}

void Display::initTrafficRadar()
{
//    mTrafficRadar = new QcGaugeWidget;
//    //    mSpeedGauge->addBackground(99);
//    //    QcBackgroundItem *bkg1 = mSpeedGauge->addBackground(92);
//    //    bkg1->clearrColors();
//    //    bkg1->addColor(0.1,Qt::black);
//    //    bkg1->addColor(1.0,Qt::white);
//    //
//    QcBackgroundItem *bkg2 = mTrafficRadar->addBackground(88);
//    bkg2->clearrColors();
//    bkg2->addColor(0.1,Qt::black);
//    setCentralWidget(mTrafficRadar);
    QQmlEngine engine(this);
    QQmlComponent component(&engine, QUrl("qrc:/qml/items/Radar.qml"),this);
    QObject *myObject = component.create();

//    QQuickView *view = new QQuickView(QUrl("qrc:/qml/items/Radar.qml"));
//    QWidget *container = QWidget::createWindowContainer(view);
//    this->setCentralWidget(container);
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
	mVarioNeedle->setCurrentValue(value);
}
