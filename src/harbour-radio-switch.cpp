/*
  Copyright (C) 2014 Janne Edelman.
  Contact: Janne Edelman <janne.edelman@gmail.com>
  All rights reserved.
*/

#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif
#include <QGuiApplication>
#include <QQmlEngine>
#include <QQuickView>
#include <QQmlContext>
#include <sailfishapp.h>


int main(int argc, char *argv[])
{
    // SailfishApp::main() will display "qml/template.qml", if you need more
    // control over initialization, you can use:
    //
    //   - SailfishApp::application(int, char *[]) to get the QGuiApplication *
    //   - SailfishApp::createView() to get a new QQuickView * instance
    //   - SailfishApp::pathTo(QString) to get a QUrl to a resource file
    //
    // To display the view, call "show()" (will show fullscreen on device).

    QGuiApplication* app = SailfishApp::application(argc, argv);
    QQuickView* view = SailfishApp::createView();

    view->setSource(SailfishApp::pathTo("qml/harbour-radio-switch.qml"));
    QObject::connect((QObject*)view->engine(), SIGNAL(quit()), app, SLOT(quit()));

    view->showMinimized();
    int retVal = app->exec();

    if(view)
        delete view;
    if(app)
        delete app;
    return retVal;
}

