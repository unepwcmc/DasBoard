suite("AddObjectiveView")

test("renders a select box for picking a metric", ->
  server = sinon.fakeServer.create()

  metric =
    value:
      name: "Total downloads"
  server.respondWith(
    new RegExp("/metrics$"),
    JSON.stringify([metric])
  )

  view = new AddObjectiveView(5)

  server.respond()

  selects = view.$el.find('select')

  try
    assert.lengthOf selects, 1,
      "Expected there to be a select box"

    assert.match selects.text(), new RegExp(metric.value.name),
      "Expected to see the metric name in the select"
  finally
    server.restore()
)

test(".createObjective posts an objective with the correct attributes", sinon.test(->
  metric =
    id: 5
    value: {name: 'hat'}

  view = {
    $el: $("""
      <div>
        #{AddObjectiveView::template(metrics: [metric])}
      </div>
    """)
    close: ->
    getSelectedMetricId: ->
      metric.id
  }

  newObjectiveName = "My lovely objective"
  view.$el.find('input').val(newObjectiveName)

  @server.respondWith(
    new RegExp("/objectives$"),
    "ok"
  )

  AddObjectiveView::createObjective.call(view)

  @server.respond()
  
  request = @server.requests[0]
  postedObjective = JSON.parse(request.requestBody).objective

  assert.strictEqual postedObjective.name, newObjectiveName
  assert.strictEqual postedObjective.type, "objective"
  assert.strictEqual postedObjective.metric_id, metric.id
))

test(".getSelectedMetricId gets the id from the select box", ->
  metric =
    id: '5'
    value: {name: 'hat'}

  view =
    $el: $("""
      <div>
        #{AddObjectiveView::template(metrics: [metric])}
      </div>
    """)

  view.$el.find('select').val(metric.id)
  result = AddObjectiveView::getSelectedMetricId.call(view)

  assert.strictEqual result, metric.id,
    "Expected the correct metric id to be returned"
)

