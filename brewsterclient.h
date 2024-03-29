#ifndef BREWSTERCLIENT_H
#define BREWSTERCLIENT_H

#include <QObject>

class QWebSocket;

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
        KettleTemperature,
        Undefined = 255
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
    void setHeaterOutput(quint8 level);
    void setPumpState(bool pumpState);

    void saveProtocol(const QUrl &fileUrl, const QByteArray &json);
    void onConnected();

private slots:
    void setTemperature(float temp);
    void handleTextMessage(const QString &messageData);
    void handleBinaryMessage(const QByteArray &message);

private:
    float _temperature;
    quint8 _heaterOutput;
    bool _pumpState;

    QWebSocket *socket;
    quint32 messageLength;
};

#endif // BREWSTERCLIENT_H
