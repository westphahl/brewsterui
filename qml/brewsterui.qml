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
        onHeaterOutputChanged: {
            heaterLevel.value = level
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

    Text {
        id: tempLabel
        x: 299
        y: 39
        text: qsTr("Kesseltemperatur")
        font.pixelSize: 18
    }

    Text {
        id: heaterLabel
        x: 41
        y: 275
        text: qsTr("Heizleistung")
        font.pixelSize: 18
    }

    Slider {
        id: heaterLevelSlider
        x: 41
        y: 352
        width: 418
        height: 28
        tickmarksEnabled: true
        updateValueWhileDragging: false
        minimumValue: 0
        maximumValue: 100
        stepSize: 2
        onValueChanged: brewster.setHeaterOutput(heaterLevelSlider.value)
    }

    ProgressBar {
        id: heaterLevel
        x: 41
        y: 317
        width: 418
        height: 23
        value: 0
        minimumValue: 0
        maximumValue: 100
    }
}
