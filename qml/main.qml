import QtQuick 2.2
import QtQuick.Controls 1.1
import Brewster.UI 1.0

ApplicationWindow {
    id: applicationWindow
    title: qsTr("Brewster")
    width: 640
    height: 480

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
