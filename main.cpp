#ifdef QT_WIDGETS_LIB
#include <QtWidgets/QApplication>
#else
#include <QtGui/QGuiApplication>
#endif
#include <QtQml>
#include <QtQuick/QQuickView>
#include <QtCore/QString>

#include "brewsterclient.h"

int main(int argc, char *argv[])
{
#ifdef QT_WIDGETS_LIB
    QApplication app(argc, argv);
#else
    QGuiApplication app(argc, argv);
#endif
    qmlRegisterType<BrewsterClient>("Brewster.UI", 1, 0, "BrewsterClient");
    QQmlApplicationEngine engine(QUrl("qrc:/qml/main.qml"));
    QObject *topLevel = engine.rootObjects().value(0);
    QQuickWindow *window = qobject_cast<QQuickWindow *>(topLevel);
    if ( !window ) {
        qWarning("Error: Your root item has to be a Window.");
        return -1;
    }
    window->show();
    return app.exec();
}
