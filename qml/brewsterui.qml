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

    Rectangle {
        id: pumpState
        x: 123
        y: 53
        width: 76
        height: 57
        color: "#cccccc"
        radius: 10
        anchors.top: parent.top
        anchors.topMargin: 39
        border.color: "#00000000"

        Connections {
            target: brewster
            onPumpStateChanged: {
                if (state) {
                    pumpState.state = "OFF"
                } else {
                    pumpState.state = "ON"
                }
            }
            onTemperatureChanged: {
                kettleTemp.text = Number(temp).toFixed(1)
            }
        }

        states: [
            State {
                name: "ON"
                PropertyChanges {
                    target: pumpState
                    color: "#dc3737"
                }
            },
            State {
                name: "OFF"
                PropertyChanges {
                    target: pumpState
                    color: "#61c850"
                }
            }
        ]
    }

    ToggleSwitch {
        id: pumpSwitch
        x: 41
        y: 71
        onToggle: brewster.setPumpState(active)
    }

    Text {
        id: tempUnit
        x: 411
        y: 39
        text: qsTr("°C")
        font.pixelSize: 18
    }

    Text {
        id: kettleTemp
        x: 346
        y: 39
        width: 59
        height: 26
        text: ""
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 18
    }
}
