suite('Metric Show Controller')

test('Passes the given metric through to the MetricChartView', ->
  actualMetricChartView = MetricChartView
  window.MetricChartView = sinon.stub()

  metric =
    id: 1,
    data: []

  try
    new DasBoard.MetricShowController(metric)
    assert.strictEqual window.MetricChartView.callCount, 1,
      "Expected a metric chart view to be created"

    assert.deepEqual window.MetricChartView.getCall(0).args[1].attributes, metric,
      "Expected the metric to be passed to the constructor"
  finally
    window.MetricChartView = actualMetricChartView
)
