suite("Metric")

test(".getDataLabels returns all data epochs as human readable dates", ->
  metric = new Metric(
    data: [{
      date: 1388793600
    }, {
      date: 1391472000
    }]
  )

  labels = metric.getDataLabels()

  assert.deepEqual(labels, [
    "Sat Jan 04 2014",
    "Tue Feb 04 2014"
  ])
)

test(".getDataPoints returns all data values", ->
  metric = new Metric(
    data: [{
      value: 3
    }, {
      value: 5
    }]
  )

  labels = metric.getDataPoints()

  assert.deepEqual(labels, [
    3, 5
  ])
)
