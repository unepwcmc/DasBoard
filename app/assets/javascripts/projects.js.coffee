class window.MetricChartView
  constructor: (@objective, @metric) ->
    @render()

  render: ->
    @$canvas = $('<canvas width="400" height="400"></canvas>')
    #@(@objective.id).append(@$canvas)
    $('section').append(@$canvas)

    context = @$canvas.get(0).getContext("2d")
    @chart = new Chart(context).Line(
      labels : ["January","February","March","April","May","June","July"],
      datasets : [
        {
          fillColor : "rgba(220,220,220,0.5)",
          strokeColor : "rgba(220,220,220,1)",
          pointColor : "rgba(220,220,220,1)",
          pointStrokeColor : "#fff",
          data : [65,59,90,81,56,55,40]
        },
        {
          fillColor : "rgba(151,187,205,0.5)",
          strokeColor : "rgba(151,187,205,1)",
          pointColor : "rgba(151,187,205,1)",
          pointStrokeColor : "#fff",
          data : [28,48,40,19,96,27,100]
        }
      ]
    )