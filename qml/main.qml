import QtQuick 2.2
import QtQuick.Controls 1.1
import Brewster.UI 1.0

ApplicationWindow {
    id: applicationWindow
    title: qsTr("Brewster")
    minimumWidth: 800
    minimumHeight: 600

    BrewsterClient {
        id: brewster
    }

    Loader {
        id: viewLoader
        anchors.fill: parent
        source: "connectdialog.qml"
    }

    Connections {
        target: viewLoader.item
    }
}
