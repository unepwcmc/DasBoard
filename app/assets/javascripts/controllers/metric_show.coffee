window.DasBoard ||= {}

class window.DasBoard.MetricShowController
  constructor: (@metric_attributes) ->
    $metricEl = $('.metric')
    new MetricChartView($metricEl, new Metric(@metric_attributes))
