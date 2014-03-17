class window.MetricChartView
  constructor: (@$el, @metric) ->
    unless @metric?
      throw new Error("No metric provided, can't create MetricChartView")

    @d3 = chart.d3
    @render()

  dateFormat: ->
    data = @metric.attributes.data
    firstDate = data[0].date
    lastDate = data[data.length - 1].date
    period = lastDate - firstDate

    format = { format: '%H:%M', tickCount: 6 }

    if period > 2.62974e6
      format = { format: '%b', tickCount: 6 }
    else if period > (86400 * 3)
      format = { format: '%a %e %b', tickCount: 4 }
    else if period > 86400
      format = { format: '%H:%M %a %e %b', tickCount: 4 }

    return {
      tickFormat: @d3.time.format(format.format)
      ticks: format.tickCount
    }

  render: ->
    if @metric.attributes.data? && @metric.attributes.data.length > 0

      containerWidth = $('.objective').width()
      $vizEl = $("<div style='width: #{containerWidth}px; height: 600px;'></div>")
      @$el.html($vizEl)
      selection = @d3.select($vizEl[0])
      format = @d3.time.format("%Y-%m-%d")
      tooltip_conf =
        html: (d, i) ->
          '<b>Date:</b> ' + format(d[0]) + ' <br> <b>Value:</b> ' + d[1]
        offset: [-5, 0]

      linechart = chart.Line()
        .margin({top: 10, right: 30, bottom: 40, left: 110})
        .width(containerWidth)
        .height(500)
        .duration(0)
        .x_axis(@dateFormat())
        .y_axis_offset(8)
        .x_scale('time')
        .force_scale_bounds(true)
        .date_type('epoch')
        .date_format('%Y-%m-%d')
        .categoricalValue( (d) -> d.date )
        .quantativeValue( (d) -> d.value )
        .overlapping_charts({
          names: ['circles'],
          options: { circles: {
            tooltip: tooltip_conf
            r: 2
          } }
        })

      chart.draw(linechart, selection, [@metric.attributes.data])
