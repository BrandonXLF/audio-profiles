#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QObject>
#include <QSettings>
#include <QHash>
#include "classes/AudioDevices.h"
#include "classes/AudioDeviceModel.h"
#include "classes/DataFlowModel.h"
#include "classes/ProfileModel.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    qmlRegisterType<AudioDeviceModel>("AudioDeviceModel", 1, 0, "AudioDeviceModel");
    qmlRegisterType<ProfileModel>("ProfileModel", 1, 0, "ProfileModel");
    qmlRegisterType<DataFlowModel>("DataFlowModel", 1, 0, "DataFlowModel");

    QQmlApplicationEngine engine;

    QSettings settings("Brandon Fowler", "Audio Profiles");
    engine.rootContext()->setContextProperty("appSettings", &settings);

    AudioDevices audioDevices;
    engine.rootContext()->setContextProperty("audioDevices", &audioDevices);

    const QUrl url(u"qrc:/qml/MainWindow.qml"_qs);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl) QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection
    );

    engine.load(url);

    return app.exec();
}
