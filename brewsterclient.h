#ifndef BREWSTERCLIENT_H
#define BREWSTERCLIENT_H

#include <QObject>
#include <QtNetwork>

class QTcpSocket;

class BrewsterClient : public QObject
{
    Q_OBJECT
    Q_PROPERTY(float temperature READ temperature WRITE setTemperature NOTIFY temperatureChanged)
    Q_PROPERTY(quint8 heaterOutput READ heaterOutput WRITE setHeaterOutput NOTIFY heaterOutputChanged)
    Q_PROPERTY(bool pumpState READ pumpState WRITE setPumpState NOTIFY pumpStateChanged)
public:
    explicit BrewsterClient(QObject *parent = 0);
    ~BrewsterClient();

    enum MessageType {
        PumpState = 1,
        HeaterOutput,
        KettleTemperature
    };

    float temperature() const;
    quint8 heaterOutput() const;
    bool pumpState() const;

Q_SIGNALS:
    void initialized();
    void error(QString errorMsg);
    void temperatureChanged(float temp);
    void heaterOutputChanged(quint8 level);
    void pumpStateChanged(bool state);

public slots:
    void initialize(QString host, quint16 port);
    void onSocketError(QAbstractSocket::SocketError socketError);
    void setHeaterOutput(quint8 level);
    void setPumpState(bool pumpState);

private slots:
    void setTemperature(float temp);
    void onDataAvailable();
    void writeSocketData(const QVariant &message);
    bool readSocketData(QVariant &message);
    void handleMessage(const QVariant &message);

private:
    float _temperature;
    quint8 _heaterOutput;
    bool _pumpState;

    QTcpSocket *socket;
    quint32 messageLength;
};

#endif // BREWSTERCLIENT_H
