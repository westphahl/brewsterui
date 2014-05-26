#include "brewsterclient.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QWebSocket>
#include <QFile>
#include <QDebug>

BrewsterClient::BrewsterClient(QObject *parent) :
    QObject(parent), socket(0)
{
    qDebug() << Q_FUNC_INFO;
}

BrewsterClient::~BrewsterClient()
{
    qDebug() << Q_FUNC_INFO;

    if (socket != Q_NULLPTR) {
        delete socket;
        socket = 0;
    }
}

float BrewsterClient::temperature() const
{
    return _temperature;
}

quint8 BrewsterClient::heaterOutput() const
{
    return _heaterOutput;
}

bool BrewsterClient::pumpState() const
{
    return _pumpState;
}

void BrewsterClient::initialize(QString host, quint16 port)
{
    qDebug() << Q_FUNC_INFO;
    socket = new QWebSocket;
    connect(socket, &QWebSocket::textMessageReceived, this, &BrewsterClient::handleTextMessage);
    connect(socket, &QWebSocket::binaryMessageReceived, this, &BrewsterClient::handleBinaryMessage);
    connect(socket, SIGNAL(connected()), this, SLOT(onConnected()));
    connect(socket, SIGNAL(connected()), this, SIGNAL(initialized()));
    socket->open(QUrl(QString("ws://%1:%2").arg(host).arg(port)));
}

void BrewsterClient::setPumpState(bool pumpState)
{
    QJsonObject message;
    message.insert("type", PumpState);
    message.insert("state", pumpState);
    socket->sendTextMessage(QJsonDocument(message).toJson());
}

void BrewsterClient::saveProtocol(const QUrl &fileUrl, const QByteArray &json)
{
    qDebug() << Q_FUNC_INFO;
    QFile protocolFile(fileUrl.toLocalFile());
    if (!protocolFile.open(QIODevice::WriteOnly))
        return;

    protocolFile.write(json);
    protocolFile.close();
}

void BrewsterClient::onConnected()
{
    qDebug() << Q_FUNC_INFO;
}

void BrewsterClient::setHeaterOutput(quint8 level)
{
    QJsonObject message;
    message.insert("type", HeaterOutput);
    message.insert("level", level);
    socket->sendTextMessage(QJsonDocument(message).toJson());
}

void BrewsterClient::setTemperature(float temp)
{
    Q_UNUSED(temp)
}

void BrewsterClient::handleTextMessage(const QString &messageData)
{
    qDebug() << Q_FUNC_INFO << messageData;

    QJsonParseError error;
    QJsonDocument jsonDocument = QJsonDocument::fromJson(messageData.toUtf8(), &error);

    if (error.error != QJsonParseError::NoError) {
        qWarning() << Q_FUNC_INFO << "Invalid data received";
        return;
    }

    QJsonObject message = jsonDocument.object();
    MessageType messageType = static_cast<MessageType>(message.value("type").toInt(Undefined));

    switch (messageType) {
    case PumpState: {
        QJsonValue pumpState = message.value("state");
        if (pumpState.isBool()) {
            _pumpState = pumpState.toBool();
            emit pumpStateChanged(_pumpState);
        }
        break;
    }
    case HeaterOutput: {
        QJsonValue heaterLevel = message.value("level");
        if (heaterLevel.isDouble()) {
            _heaterOutput = heaterLevel.toInt();
            emit heaterOutputChanged(_heaterOutput);
        }
        break;
    }
    case KettleTemperature: {
        QJsonValue kettleTemperature = message.value("temperature");
        if (kettleTemperature.isDouble()) {
            _temperature = kettleTemperature.toDouble();
            emit temperatureChanged(_temperature);
        }
        break;
    }
    default:
        qWarning() << "Unknown message type" << messageType;
    }
}

void BrewsterClient::handleBinaryMessage(const QByteArray &message)
{
    qDebug() << Q_FUNC_INFO << message;
}
