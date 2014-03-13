import QtQuick 2.0

Rectangle {
    id: chart
    width: 100
    height: 62
    color: "transparent"

    property var dataModel: null

    function update() {
        canvas.requestPaint();
    }

    Canvas {
        id: canvas
        width: parent.width
        height: parent.height

        renderTarget: Canvas.FramebufferObject
        antialiasing: true

        onPaint: {
            var ctx = canvas.getContext("2d")

            ctx.globalCompositeOperation = "source-over"

            ctx.clearRect(0, 0, canvas.width, canvas.height)

            ctx.save()
            ctx.lineWidth = 1
            ctx.strokeStyle = "blue";

            var offset = 0;
            if (dataModel.count > canvas.width) {
                offset = dataModel.count - canvas.width
            }

            ctx.beginPath()
            for(var i = 0; (i + offset) < dataModel.count && i < canvas.width; i++) {
                var entry = dataModel.get(i+offset)
                var y = canvas.height - (canvas.height / 100 * entry.temperature)
                if (i == 0) {
                    ctx.moveTo(i, y)
                } else {
                    ctx.lineTo(i, y)
                }
            }

            ctx.stroke()
            ctx.restore()
        }
    }
}
