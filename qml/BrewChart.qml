import QtQuick 2.0

Rectangle {
    id: chart
    width: 500
    height: 100
    color: "white"

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

        function paintGrid(ctx, unit) {
            ctx.save()
            ctx.lineWidth = 1
            ctx.strokeStyle = "#cccccc";

            ctx.beginPath()
            var gridStep = unit * 10
            for(var y = 0; y <= canvas.height; y = y + gridStep) {
                ctx.moveTo(0, y)
                ctx.lineTo(canvas.width, y)
            }

            ctx.stroke()
            ctx.restore()
        }

        function paintTemperature(ctx, unit) {
            ctx.save()
            ctx.lineWidth = 1
            ctx.strokeStyle = "blue";

            ctx.beginPath()
            var endIndex = dataModel.count - 1
            for(var x = 0; x <= endIndex && x <= canvas.width; x++) {
                var entry = dataModel.get(endIndex-x)
                var y = canvas.height - (unit * entry.temperature)
                if (x == 0) {
                    ctx.moveTo(canvas.width-x, y)
                } else {
                    ctx.lineTo(canvas.width-x, y)
                }
            }

            ctx.stroke()
            ctx.restore()
        }

        onPaint: {
            var ctx = canvas.getContext("2d")
            var unit = canvas.height / 100

            ctx.clearRect(0, 0, canvas.width, canvas.height)
            paintGrid(ctx, unit)
            paintTemperature(ctx, unit)
        }
    }
}
