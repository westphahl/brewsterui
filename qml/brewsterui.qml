import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Dialogs 1.1

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
                pumpSwitch.setState(true)
                pumpSwitch.backgroundColor = "#61c850"
            } else {
                pumpSwitch.setState(false)
                pumpSwitch.backgroundColor = "#dc3737"
            }
        }
        onTemperatureChanged: {
            kettleTemp.text = Number(temp).toFixed(1)
            dataModel.append({
                temperature: Number(temp).toFixed(1),
                timestamp: new Date
            })
        }
        onHeaterOutputChanged: {
            heaterLevel.value = level
            heaterLevelSlider.value = level
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
        y: 134
        text: qsTr("Heizleistung")
        font.pixelSize: 18
    }

    Slider {
        id: heaterLevelSlider
        x: 41
        y: 211
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
        y: 176
        width: 418
        height: 23
        value: 0
        minimumValue: 0
        maximumValue: 100

        Text {
            text: parent.value + " %"
            anchors.centerIn: parent
        }
    }

    ListModel {
        id: dataModel
    }

    Text {
        id: protocolLabel
        x: 41
        y: 292
        text: qsTr("Protokoll")
        font.pixelSize: 18
    }

    MessageDialog {
        id: clearProtocolDialog
        icon: StandardIcon.Critical
        title: qsTr("Löschen bestätigen")
        text: qsTr("Protokolldaten wirklich löschen?")
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: dataModel.clear()
    }

    Button {
        id: clearProtocolButton
        x: 41
        y: 329
        text: qsTr("Löschen")
        onClicked: clearProtocolDialog.open()
    }
}
