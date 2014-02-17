import QtQuick 2.2
import QtQuick.Controls 1.1

Item {
    id: connectDialog
    width: 250
    height: 150

    Connections {
        target: brewster
        onInitialized: viewLoader.source = "brewsterui.qml"
        onError: console.log(error)
    }

    Button {
        x: 25
        y: 62
        text: "Connect"

        onClicked: {
            brewster.initialize(host.text, port.text)
        }
    }

    TextField {
        id: host
        x: 25
        y: 25
        width: 100
        height: 27
        text: "192.168.7.2"
        placeholderText: qsTr("Hostname/IP")
    }

    TextField {
        id: port
        x: 150
        y: 25
        width: 70
        height: 27
        text: "2337"
        placeholderText: "Port"
    }
}
