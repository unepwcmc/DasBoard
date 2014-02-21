class window.MetricChartView
  constructor: (@$el, @metric) ->
    unless @metric?
      throw new Error("No metric provided, can't create MetricChartView")

    @render()

  render: ->
    @$canvas = $('<canvas width=900 height=562></canvas>')
    @$el.html(@$canvas)

    context = @$canvas.get(0).getContext("2d")

    if @metric.attributes.data?
      labels = @metric.getDataLabels()
      data = @metric.getDataPoints()

      @chart = new Chart(context).Line({
        labels : labels
        datasets : [
          {
            fillColor : "rgba(220,220,220,0.5)",
            strokeColor : "rgba(220,220,220,1)",
            pointColor : "rgba(220,220,220,1)",
            pointStrokeColor : "#fff",
            data : data
          }
        ]
      },{
        bezierCurve: false,
        animation: false
      })
    else
      @$canvas.html("No data for this metric")
