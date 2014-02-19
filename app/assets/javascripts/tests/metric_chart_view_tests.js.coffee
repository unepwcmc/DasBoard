suite("MetricChartView")

test(".contructor throws an error if no metric provided", ->
  assert.throws((->
    new MetricChartView({}, null)
  ), "No metric provided, can't create MetricChartView")
)

test(".getCanvas returns the correct selector", ->
  $Backup = window.$
  window.$ = sinon.spy()

  objective = {_id: 4}
  metric = new Metric(
    _id: 5
  )

  view =
    objective: objective
    metric: metric

  try
    MetricChartView::getCanvas.call(view)
    expectedSelector = "section#4 #metric-5"

    assert window.$.calledWith(expectedSelector),
      "Expected $(#{expectedSelector}) to be called, but $(#{window.$.getCall(0).args[0]})"
  finally
    window.$ = $Backup
)

test('.render does not throw exception if canvas does not exist', sinon.test(->
  @stub(MetricChartView::, 'getCanvas', -> [])

  assert.doesNotThrow( (->
    view = new MetricChartView({}, {})
  ), TypeError, 'Expected render to not throw exception when Canvas el does not exist')
))
