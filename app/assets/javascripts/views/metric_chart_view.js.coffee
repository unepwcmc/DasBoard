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

      parse = d3.time.format("%Y-%m-%d").parse
      format = d3.time.format("%Y-%m-%d")
      format(new Date(2011, 0, 1))

      data = @metric.attributes.data.map( (o) ->
        [format(new Date(o.date * 1000)), o.value]
      )
      
      linechart = chart.line()
        .margin({right: 50})
        .width(750)
        .height(500)
        .duration(0)
        .parseDate(parse)
        .x_axis({tickFormat: d3.time.format("%a %d")})
      chart.draw(linechart, selection, data)