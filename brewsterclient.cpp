#include "brewsterclient.h"

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
    socket = new QTcpSocket(this);
    connect(socket, SIGNAL(readyRead()), this, SLOT(onDataAvailable()));
    connect(socket, SIGNAL(connected()), this, SIGNAL(initialized()));
    connect(socket, SIGNAL(error(QAbstractSocket::SocketError)),
            this, SLOT(onSocketError(QAbstractSocket::SocketError)));
    socket->connectToHost(host, port);
}

void BrewsterClient::onSocketError(QAbstractSocket::SocketError socketError)
{
    Q_UNUSED(socketError);

    emit error(socket->errorString());
}

void BrewsterClient::setPumpState(bool pumpState)
{
    qDebug() << Q_FUNC_INFO << pumpState;
    writeSocketData(QVariantList() << (quint8) PumpState << pumpState);
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

void BrewsterClient::setHeaterOutput(quint8 level)
{
    qDebug() << Q_FUNC_INFO << level;
    writeSocketData(QVariantList() << (quint8) HeaterOutput << level);
}

void BrewsterClient::setTemperature(float temp)
{
    Q_UNUSED(temp)
}

void BrewsterClient::handleMessage(const QVariant &message)
{
    QVariantList paramList(message.toList());

    if (paramList.isEmpty()) {
        qWarning() << Q_FUNC_INFO << "Invalid data received";
        return;
    }

    MessageType messageType = (MessageType) paramList.takeFirst().value<quint8>();
    switch (messageType) {
    case PumpState: {
        if (!paramList.isEmpty()) {
            QVariant pumpState = paramList.takeFirst();
            if (static_cast<QMetaType::Type>(pumpState.type()) == QMetaType::Bool) {
                _pumpState = pumpState.toBool();
                emit pumpStateChanged(_pumpState);
            }
        }
        break;
    }
    case HeaterOutput: {
        if (!paramList.isEmpty()) {
            QVariant heaterLevel = paramList.takeFirst();
            if (static_cast<QMetaType::Type>(heaterLevel.type()) == QMetaType::Int) {
                _heaterOutput = heaterLevel.toInt();
                emit heaterOutputChanged(_heaterOutput);
            }
        }
        break;
    }
    case KettleTemperature: {
        if (!paramList.isEmpty()) {
            QVariant kettleTemperature = paramList.takeFirst();
            if (static_cast<QMetaType::Type>(kettleTemperature.type()) == QMetaType::Float) {
                _temperature = kettleTemperature.toFloat();
                emit temperatureChanged(_temperature);
            }
        }
        break;
    }
    }
}

void BrewsterClient::onDataAvailable()
{
    QVariant message;
    while(readSocketData(message)) {
        qDebug() << Q_FUNC_INFO << message;
        handleMessage(message);
    }
}

bool BrewsterClient::readSocketData(QVariant &message)
{
    QDataStream stream;
    stream.setDevice(socket);
    stream.setVersion(QDataStream::Qt_5_2);

    if (messageLength == 0) {
        if (socket->bytesAvailable() < 4)
            return false;
        stream >> messageLength;
    }

    if (messageLength == 0) {
        qWarning() << Q_FUNC_INFO << "Message with length 0 received";
        return false;
    }

    if (socket->bytesAvailable() < messageLength)
        return false;

    messageLength = 0;
    stream >> message;

    if (!message.isValid()) {
        qWarning() << Q_FUNC_INFO << "Corrupt data received";
        return false;
    }

    return true;
}

void BrewsterClient::writeSocketData(const QVariant &message)
{
    if (!socket->isOpen()) {
        qWarning() << Q_FUNC_INFO << "Server connection closed";
        return;
    }

    QDataStream stream;
    stream.setDevice(socket);
    stream.setVersion(QDataStream::Qt_5_2);

    QByteArray data;
    QDataStream out(&data, QIODevice::WriteOnly);
    out.setVersion(QDataStream::Qt_5_2);

    out << message;
    stream << data;
}
