suite("MetricChartView")

test(".contructor throws an error if no metric provided", ->
  assert.throws((->
    new MetricChartView({}, null)
  ), "No metric provided, can't create MetricChartView")
)
