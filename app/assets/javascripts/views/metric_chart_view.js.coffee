class window.MetricChartView
  constructor: (@$el, @metric) ->
    unless @metric?
      throw new Error("No metric provided, can't create MetricChartView")

    @render()

  dateFormatter: (data) ->
    d1 = data[0].date
    d2 = data[data.length - 1].date
    period = d2 - d1

    if period > 2.62974e6
      return { format: '%b', ticks: 6 }
    else if period > (86400 * 3)
      return { format: '%a %e %b', ticks: 4 }
    else if period > 86400
      return { format: '%H%M %a %e %b', ticks: 4 }
    else
      return { format: '%H%M', ticks: 6 }

  getCircleRadius: (data) ->
    l = data.length
    if l > 50
      return 2
    else if l > 10
      return 4
    else
      return 5

  render: ->
    if @metric.attributes.data? && @metric.attributes.data.length > 0
      d3 = chart.d3
      
      viz_element = $('<div style="width: 800px; height: 600px;"></div>')
      @$el.html(viz_element)
      selection = d3.select(viz_element[0])

      format = d3.time.format("%Y-%m-%d")
      tooltip_conf =
        html: (d, i) ->
          '<b>Date:</b> ' + format(d[0]) + ' <br> <b>Value:</b> ' + d[1]
        offset: [-5, 0]

      # This is a workaround, until I fix nightcharts!
      max = 0
      for d in @metric.attributes.data
        if d.value > max then max = d.value

      dt = @dateFormatter(@metric.attributes.data)

      linechart = chart.Line()
        .margin({right: 50})
        .width(750)
        .height(500)
        .duration(0)
        .x_axis({tickFormat: d3.time.format(dt.format), ticks: dt.ticks})
        .y_axis_offset(8)
        .x_scale('time')
        .date_type('epoch')
        .date_format('%Y-%m-%d')
        .max(max)
        .categoricalValue( (d) -> d.date )
        .quantativeValue( (d) -> d.value )
        .overlapping_charts({ 
          names: ['circles'],
          options: { circles: { 
            tooltip: tooltip_conf,
            r: @getCircleRadius(@metric.attributes.data)
          } }
        })
        
      chart.draw(linechart, selection, [@metric.attributes.data])