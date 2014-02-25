import QtQuick 2.2
import QtQuick.Controls 1.1

import "components"

Item {
    height: 500
    width: 500

    Text {
        id: pumpLabel
        x: 41
        y: 39
        text: qsTr("Pumpe")
        font.pixelSize: 18
    }

    Connections {
        target: brewster
        onPumpStateChanged: {
            if (state) {
                pumpSwitch.backgroundColor = "#61c850"
            } else {
                pumpSwitch.backgroundColor = "#dc3737"
            }
        }
        onTemperatureChanged: {
            kettleTemp.text = Number(temp).toFixed(1)
        }
    }

    ToggleSwitch {
        id: pumpSwitch
        x: 41
        y: 71
        onToggle: brewster.setPumpState(active)
    }

    Text {
        id: tempUnit
        x: 437
        y: 71
        text: qsTr("°C")
        font.pixelSize: 18
    }

    Text {
        id: kettleTemp
        x: 372
        y: 71
        width: 59
        height: 26
        text: "n/a"
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 18
    }
}
