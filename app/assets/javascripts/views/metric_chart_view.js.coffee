class window.MetricChartView
  constructor: (@objective, @metric) ->
    unless @metric?
      throw new Error("No metric provided, can't create MetricChartView")

    @render()

  render: ->
    @$canvas = @getCanvas()

    context = @$canvas.get(0).getContext("2d")
    if @metric.data?

      labels = @metric.data.map( (data_point) ->
        new Date(data_point.date*1000).toDateString()
      )

      data = @metric.data.map( (data_point) ->
        data_point.value
      )

      @chart = new Chart(context).Line(
        labels : labels
        datasets : [
          {
            fillColor : "rgba(220,220,220,0.5)",
            strokeColor : "rgba(220,220,220,1)",
            pointColor : "rgba(220,220,220,1)",
            pointStrokeColor : "#fff",
            bezierCurve: false,
            data : data
          }
        ]
      )
    else
      @$canvas.html("No data for this metric")

  getCanvas: ->
    $("section##{@objective._id} #metric-#{@metric._id}")

