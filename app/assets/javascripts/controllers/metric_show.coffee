window.DasBoard ||= {}

class window.DasBoard.MetricShowController
  constructor: (@metric) ->
    $metricEl = $('<div>')
    debugger
    new MetricChartView($metricEl, new Metric(@metric))
