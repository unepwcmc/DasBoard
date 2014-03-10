class window.MetricChartView
  constructor: (@$el, @metric) ->
    unless @metric?
      throw new Error("No metric provided, can't create MetricChartView")

    @render()

  render: ->
    if @metric.attributes.data? && @metric.attributes.data.length > 0
      d3 = chart.d3
      @$el.html('<div id="viz" style="width: 800px; height: 600px;"></div>')
      selection = d3.select('#viz')

      format = d3.time.format("%Y-%m-%d")
      tooltip_conf =
        html: (d, i) ->
          '<b>Date:</b> ' + format(d[0]) + ' <br> <b>Value:</b> ' + d[1]
        offset: [-5, 0]

      # This is a workaround, until I fix nightcharts!
      max = 0
      for d in @metric.attributes.data
        if d.value > max then max = d.value

      linechart = chart.Line()
        .margin({right: 50})
        .width(750)
        .height(500)
        .duration(0)
        .x_axis({tickFormat: d3.time.format("%a %d")})
        .y_axis_offset(8)
        .x_scale('time')
        .date_type('epoch')
        .date_format('%Y-%m-%d')
        .max(max)
        .categoricalValue( (d) -> d.date )
        .quantativeValue( (d) -> d.value )
        .overlapping_charts({ 
          names: ['circles'],
          options: { circles: { tooltip: tooltip_conf } }
        })
        
      chart.draw(linechart, selection, [@metric.attributes.data])