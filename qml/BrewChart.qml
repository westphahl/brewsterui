import QtQuick 2.0

Rectangle {
    id: chart
    width: 500
    height: 100
    color: "transparent"

    property var dataModel: null

    function update() {
        canvas.requestPaint();
    }

    Canvas {
        id: canvas
        width: parent.width
        height: parent.height

        property string temperatureColor: "#FF0080"
        property string heaterLevelColor: "#0174DF"

        function paintGrid(ctx, graphX, graphY, graphXEnd, graphYEnd, gridYStep, gridXStep) {
            ctx.save()
            ctx.lineWidth = 1
            ctx.strokeStyle = "#cccccc";

            ctx.beginPath()

            ctx.fillStyle = "#ffffff"
            ctx.fillRect(graphX, graphY, graphXEnd-graphX, graphYEnd-graphY)

            for (var y = graphYEnd; y >= graphY; y = y - gridYStep) {
                ctx.moveTo(graphX, y)
                ctx.lineTo(graphXEnd, y)
            }

            for (var x = graphXEnd; x >= graphX; x = x - gridXStep) {
                ctx.moveTo(x, graphY)
                ctx.lineTo(x, graphYEnd)
            }

            ctx.stroke()
            ctx.restore()
        }

        function paintXLabels(ctx, labelX, labelY, labelXEnd, labelYEnd, labelXStep) {
            ctx.save()
            ctx.lineWidth = 1
            ctx.strokeStyle = "#000000";
            ctx.font = "normal normal normal 12px sans-serif"
            ctx.textAlign = "center"

            ctx.beginPath()

            var graphStart = labelXEnd - 50
            var y = labelY + 20
            for (var i = 0; (graphStart - labelXStep * i) >= labelX; i++) {
                ctx.fillText(-i+"m", graphStart-labelXStep*i, y)
            }

            ctx.restore()
        }

        function paintYLabels(ctx, labelX, labelY, labelXEnd, labelYEnd, labelYStep) {
            ctx.save()
            ctx.lineWidth = 1
            ctx.strokeStyle = "#000000";
            ctx.font = "normal normal normal 12px sans-serif"
            ctx.textAlign = "left"
            ctx.textBaseline = "middle"

            ctx.beginPath()

            var x = labelX + 20
            for (var i = 1; (labelYEnd - i * labelYStep - 6) >= labelY; i++) {
                ctx.fillText(i*10, x, labelYEnd-i*labelYStep)
            }

            ctx.restore()
        }

        function paintData(ctx, key, color, graphX, graphY, graphXEnd, graphYEnd, unitY) {
            ctx.save()
            ctx.lineWidth = 1
            ctx.strokeStyle = color;

            ctx.beginPath()
            var endIndex = dataModel.count - 1
            var graphWidth = graphXEnd - graphX
            for (var x = 0; (x <= endIndex) && (x <= graphWidth); x++) {
                var entry = dataModel.get(endIndex-x)
                var y = graphYEnd - (unitY * entry[key])
                if (x == 0) {
                    ctx.moveTo(graphXEnd-x, y)
                } else {
                    ctx.lineTo(graphXEnd-x, y)
                }
            }

            ctx.stroke()
            ctx.restore()
        }

        function paintKey(ctx, graphX, graphY) {
            ctx.save()
            ctx.beginPath()

            ctx.font = "normal normal normal 12px sans-serif"
            ctx.textAlign = "left"
            ctx.textBaseline = "middle"

            ctx.fillStyle = canvas.temperatureColor
            ctx.fillRect(graphX+20, graphY+20, 20, 20)
            ctx.fillStyle = "#000000"
            ctx.fillText("Temperature in °C", graphX+50, graphY+30)

            ctx.fillStyle = canvas.heaterLevelColor
            ctx.fillRect(graphX+20, graphY+50, 20, 20)
            ctx.fillStyle = "#000000"
            ctx.fillText("Heizleistung in %", graphX+50, graphY+60)

            ctx.stroke()
            ctx.restore()
        }

        onPaint: {
            var ctx = canvas.getContext("2d")

            var graphX = 0
            var graphY = 0
            var graphWidth = canvas.width - 50
            var graphHeight = canvas.height - 25

            var graphXEnd = graphWidth + graphX
            var graphYEnd = graphHeight + graphY

            var unitX = 1 // FIXME: Can not be changed since currently hardcoded in paintTemperature
            var unitY = graphHeight / 110
            var gridYStep = unitY * 10
            var gridXStep = unitX * 60

            ctx.clearRect(0, 0, canvas.width, canvas.height)

            paintGrid(ctx, graphX, graphY, graphXEnd, graphYEnd, gridYStep, gridXStep)

            paintXLabels(ctx, 0, graphYEnd, canvas.width, canvas.height, gridXStep)
            paintYLabels(ctx, graphXEnd, 0, canvas.width, graphHeight, gridYStep)

            paintData(ctx, "temperature", canvas.temperatureColor, graphX, graphY, graphXEnd, graphYEnd, unitY)
            paintData(ctx, "heaterLevel", canvas.heaterLevelColor, graphX, graphY, graphXEnd, graphYEnd, unitY)

            paintKey(ctx, graphX, graphY)
        }
    }
}
