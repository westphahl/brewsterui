import QtQuick 2.0
import QtQuick.Controls 1.1

Item {
    id: toggleSwitch

    property color backgroundColor
    signal toggle(bool active)

    onBackgroundColorChanged: switchBackground.color = backgroundColor

    x: 0
    y: 0
    width: 70
    height: 25

    SystemPalette { id: switchColor; colorGroup: SystemPalette.Active }

    states: [
        State {
            name: "ON"
            when: toggleSwitch.clicked
            PropertyChanges {
                target: switchButton
                x: switchButton.width
            }
        }
    ]

    Rectangle {
        id: switchBackground
        color: switchColor.mid
        radius: 4
        border.color: switchColor.dark
        border.width: 1
        anchors.fill: parent
    }

    Button {
        id: switchButton
        text: ""
        checkable: true
        checked: false
        width: parent.width/2
        height: parent.height
        onClicked: {
            if (parent.state == "ON") {
                parent.state = ""
                toggleSwitch.toggle(false)
            } else {
                parent.state = "ON"
                toggleSwitch.toggle(true)
            }
        }
    }
}
